open Core

[@@@ocaml.flambda_o3]

(** A parallel sexp parser using SSE intrinsics.

    The underlying design is inspired by SIMD-json, which is described in the following
    paper: https://arxiv.org/pdf/1902.08318.pdf.

    Additionally, structural character detection is near-directly ported from Cheng Sun's
    Rust implementation at https://github.com/chengsun/simd-sexp.

    Each iteration of the parser loop processes 64 bytes of the input string. Each chunk
    is processed in two phases:

    - [Lex]: compute a bit mask indicating which characters are _structural_. Structural
      characters require the parser to undergo a state transition. The main benefit of
      using SIMD instructions is that we can quickly compute this mask and use it to skip
      over non-structural characters. (This code is rather complicated due to supporting
      quoted strings and escape sequences.)

    - [Parse]: iterate through the set bits of the mask, updating the parser state based
      on the relevant character. When the parser finds the start of a (quoted or unquoted)
      atom, it greedly parses the entire atom before continuing. SIMD instructions are
      also used to skip through atoms that contain non-structural characters. *)

module Int8_u = Stdlib_stable.Int8_u
module I8x16 = Ocaml_simd_sse.Int8x16
module I64x2 = Ocaml_simd_sse.Int64x2

module String_intrin = struct
  include Ocaml_simd_sse.String

  let[@inline] spaces () = I8x16.const1 (Int8_u.of_int (Char.to_int ' '))

  (** Behaves like [I8x16.shifti_{left,right}_bytes] without the restriction that the
      shift amount has to be a literal constant.

      The shift [amount] is signed: positive [amount] means shifting right; negative means
      shifting left. *)
  let shift_bytes =
    let zero_pattern =
      "\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80\x80"
    in
    let no_op_pattern =
      "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
    in
    let pattern = zero_pattern ^ no_op_pattern ^ zero_pattern in
    fun [@inline] x amount ->
      (* assert (-16 <= amount && amount <= 16); *)
      let pattern = I8x16.String.unsafe_get pattern ~byte:(16 + amount) in
      I8x16.shuffle ~pattern x
  ;;

  (** Behaves like [I8x16.concat_shift_right_bytes] without the restriction that the shift
      amount has to be a literal constant. *)
  let[@inline] concat_shift_right_bytes hi lo amount =
    (* assert (0 <= amount && amount <= 16); *)
    let hi = shift_bytes hi (amount - 16) in
    let lo = shift_bytes lo amount in
    I8x16.(lo lor hi)
  ;;

  (* Load 16 bytes, padding with spaces *)
  let[@inline] extract_16 string ~len ~idx ~extract_16_buffer =
    if idx + 16 <= len
    then I8x16.String.unsafe_get string ~byte:idx
    else if idx >= len
    then spaces ()
    else if len < 16
    then (
      Bigstring.memset ~pos:0 ~len:16 extract_16_buffer ' ';
      Bigstring.From_string.unsafe_blit
        ~src:string
        ~src_pos:idx
        ~dst:extract_16_buffer
        ~dst_pos:0
        ~len:(len - idx);
      I8x16.Bigstring.unsafe_aligned_get extract_16_buffer ~byte:0)
    else
      concat_shift_right_bytes
        (spaces ())
        (I8x16.String.unsafe_get string ~byte:(len - 16))
        (idx - (len - 16))
  ;;

  type i8x16x4 =
    { v0 : I8x16.t
    ; v1 : I8x16.t
    ; v2 : I8x16.t
    ; v3 : I8x16.t
    }

  (* Load 64 bytes, padding with spaces *)
  let[@inline] extract_64 string ~len ~idx ~extract_16_buffer =
    { v0 = extract_16 string ~len ~idx ~extract_16_buffer
    ; v1 = extract_16 string ~len ~idx:(idx + 16) ~extract_16_buffer
    ; v2 = extract_16 string ~len ~idx:(idx + 32) ~extract_16_buffer
    ; v3 = extract_16 string ~len ~idx:(idx + 48) ~extract_16_buffer
    }
  ;;
end

module I64_intrin = struct
  include Ocaml_intrinsics.Int64

  let even_bits = 0xAAAAAAAAAAAAAAAAL
  let odd_bits = 0x5555555555555555L
  let[@inline] all_bits () = I64x2.const1 (Int64_u.of_int64 0xFFFFFFFFFFFFFFFFL)
  let to_64 = Int64.of_int
  let of_64 = Int64.to_int_trunc

  let[@inline] check_overflow a b =
    if Stdlib.Int64.unsigned_compare Int64.(a + b) b = -1 then 1 else 0
  ;;

  (** [clmul] has the effect of "filling in" regions of 0s bounded by 1s - so if the
      input, e.g., has 1s in places indicating quotation marks, this will set the bits
      corresponding to quoted characters to 1. (It also sets the bit corresponding to the
      right quote mark, but not the left quote mark, to 1). So, e.g,

      {v
      clmul 0b0010_0001_0000
          = 0b0001_1111_0000

      clmul 0b0100_1001_0010
          = 0b0011_1000_1110
      v}

      Regions to fill in are effectively counted from the right, so if the input contains
      an odd number of 1s, the output will have 1s on the left:

      {v
      clmul 0b0001_0010_0010
          = 0b1111_0001_1110
      v} *)
  let[@inline] clmul n =
    I64x2.mul_without_carry
      #0L
      (I64x2.set (Int64_u.of_int64 n) (Int64_u.of_int64 0L))
      (all_bits ())
    |> I64x2.extract0
    |> Int64_u.to_int64
  ;;

  (* Four 128-bit byte masks -> int64 bit mask *)
  let[@inline] bitmask v0 v1 v2 v3 ~f =
    let v0 = f v0 |> I8x16.movemask in
    let v1 = f v1 |> I8x16.movemask in
    let v2 = f v2 |> I8x16.movemask in
    let v3 = f v3 |> I8x16.movemask in
    Int64_u.(v0 lor (v1 lsl 16) lor (v2 lsl 32) lor (v3 lsl 48)) |> Int64_u.to_int64
  ;;

  let[@inline] sign_extend n = Int64.((n lsl 63) asr 63)
  let[@inline] inot i = if Int64.equal i 0L then 1L else 0L

  (* Xor with the value of the previous bit enabled by the mask *)
  let[@inline] xor_masked_adjacent bits mask lo =
    let open Int64 in
    let d1 = extract_bits bits mask in
    let d2 = d1 lxor ((d1 lsl 1) lor lo) in
    deposit_bits d2 mask
  ;;
end

module Buffer = struct
  (* Does not use a [char Vec.t] because we don't (yet) support storing SIMD vectors to a
     Vec. *)
  type t =
    { mutable s : Bigstring.t
    ; mutable n : int
    }

  let[@inline] create () = { s = Bigstring.create 256; n = 0 }

  let[@inline] reserve t ~bytes =
    let len = Bigstring.length t.s in
    if t.n + bytes >= len
    then (
      let next = Bigstring.create (len * 2) in
      Bigstring.unsafe_blit ~src:t.s ~src_pos:0 ~dst:next ~dst_pos:0 ~len;
      t.s <- next)
    else ()
  ;;

  (* Stores 16 bytes but only advances by [bytes] *)
  let[@inline] store t ~bytes ~v =
    reserve t ~bytes:16;
    I8x16.Bigstring.unsafe_unaligned_set t.s ~byte:t.n v;
    t.n <- t.n + bytes
  ;;

  let[@inline] length t = t.n
  let[@inline] clear t = t.n <- 0

  let[@inline] push t ~c =
    reserve t ~bytes:1;
    Bigstring.unsafe_set t.s t.n c;
    t.n <- t.n + 1
  ;;

  let[@inline] get t i = Bigstring.unsafe_get t.s i
end

module Lex = struct
  (* The ints in this type represent booleans and must be 0 or 1. We do this because they
     are used as bits in the algorithm. *)
  type t =
    { mutable escaped : int (* Is there a preceeding backslash? *)
    ; mutable in_string : int (* Do we start inside a quoted string? *)
    ; mutable atom_like : int (* Do we start inside an atom? *)
    }

  let[@inline] create () = { escaped = 0; in_string = 0; atom_like = 0 }

  (* Chars that are not exclusively seen in atoms, i.e. may require a state transition. *)
  let[@inline] structural_chars () =
    I8x16.const
      (Int8_u.of_int (Char.to_int ' '))
      (Int8_u.of_int (Char.to_int '\t'))
      (Int8_u.of_int (Char.to_int '\n'))
      (Int8_u.of_int (Char.to_int '('))
      (Int8_u.of_int (Char.to_int ')'))
      (Int8_u.of_int (Char.to_int '"'))
      (Int8_u.of_int (Char.to_int ';'))
      (Int8_u.of_int (Char.to_int '#'))
      (Int8_u.of_int (Char.to_int '|'))
      (Int8_u.of_int (Char.to_int '\r'))
      (Int8_u.of_int (Char.to_int '\012'))
      #0s
      #0s
      #0s
      #0s
      #0s
  ;;

  (* Chars that may follow whitespace or a structural char and may require a state
     transition. *)
  let[@inline] pseudostructural_chars () =
    I8x16.const
      (Int8_u.of_int (Char.to_int '('))
      (Int8_u.of_int (Char.to_int ')'))
      (Int8_u.of_int (Char.to_int ';'))
      (Int8_u.of_int (Char.to_int '#'))
      (Int8_u.of_int (Char.to_int '|'))
      (Int8_u.of_int (Char.to_int '\r'))
      #0s
      #0s
      #0s
      #0s
      #0s
      #0s
      #0s
      #0s
      #0s
      #0s
  ;;

  let[@inline] backslashes () = I8x16.const1 (Int8_u.of_int (Char.to_int '\\'))
  let[@inline] quotes () = I8x16.const1 (Int8_u.of_int (Char.to_int '"'))
  let[@inline] newlines () = I8x16.const1 (Int8_u.of_int (Char.to_int '\n'))
  let[@inline] returns () = I8x16.const1 (Int8_u.of_int (Char.to_int '\r'))
  let[@inline] spaces () = I8x16.const1 (Int8_u.of_int (Char.to_int ' '))
  let[@inline] tabs () = I8x16.const1 (Int8_u.of_int (Char.to_int '\t'))

  (* Mask indicating the starts of runs. Note that here (and elsewhere in this module)
     "starts" and "ends" are a bit confusing: the least significant bit of the mask
     corresponds to the first byte of the input chunk, so the order is reversed. *)
  let[@inline] range_starts mask = Int64.(mask land lnot (mask lsl 1))

  (* Mask indicating the starts of runs (including the last bit of the previous step) *)
  let[@inline] range_starts_prev mask prev =
    Int64.(mask land lnot ((mask lsl 1) lor prev))
  ;;

  let[@inline] is_pseudostructural v =
    String_intrin.Byte.cmpestrm
      [%bytes Signed, Eq_any, Pos, Vec_mask]
      ~a:(pseudostructural_chars ())
      ~a_len:#6L
      ~b:v
      ~b_len:#16L
  ;;

  (* Atom-like if not structural. *)
  let[@inline] is_atom_like v =
    String_intrin.Byte.cmpestrm
      [%bytes Signed, Eq_any, Neg, Vec_mask]
      ~a:(structural_chars ())
      ~a_len:#11L
      ~b:v
      ~b_len:#16L
  ;;

  (* Index of first char that may require a state transition. *)
  let[@inline] n_unquoted_string_chars v =
    String_intrin.Byte.cmpestri
      [%bytes Signed, Eq_any, Pos, Least_sig]
      ~a:(structural_chars ())
      ~a_len:#11L
      ~b:v
      ~b_len:#16L
    |> Int64_u.to_int_trunc
  ;;

  (* Index of first char that may require a state transition. *)
  let[@inline] n_quoted_string_chars v =
    let movemask =
      I8x16.((v = quotes ()) lor (v = backslashes ()))
      |> I8x16.movemask
      |> Int64_u.to_int_trunc
    in
    if movemask = 0
    then None
    else Some (Ocaml_intrinsics.Int.count_trailing_zeros movemask)
  ;;

  (* Index of first newline character. *)
  let[@inline] chars_until_newline_or_return v =
    let movemask =
      I8x16.((v = newlines ()) lor (v = returns ()))
      |> I8x16.movemask
      |> Int64_u.to_int_trunc
    in
    if movemask = 0 then 16 else Ocaml_intrinsics.Int.count_trailing_zeros movemask
  ;;

  (* Index of first non-space non-tab character. *)
  let[@inline] chars_until_non_space_or_tab v =
    let movemask =
      I8x16.((v <> spaces ()) land (v <> tabs ()))
      |> I8x16.movemask
      |> Int64_u.to_int_trunc
    in
    if movemask = 0 then 16 else Ocaml_intrinsics.Int.count_trailing_zeros movemask
  ;;

  (* Mask indicating the final bit of odd-length runs. Used for detecting odd-length runs
     of backslashes, which are escaped chars. *)
  let[@inline] odd_range_ends mask prev_escaped =
    let open Int64 in
    (* If we started inside an escaped char... *)
    (* There is a run starting at bit 0. *)
    let start = range_starts mask lor prev_escaped in
    (* But we should not consider it as starting at an even bit. *)
    let start_even = start land (I64_intrin.even_bits lxor prev_escaped) in
    let next_escaped = I64_intrin.check_overflow start_even mask in
    let end_1 = (start_even + mask) land lnot mask in
    let end_odd_1 = end_1 land I64_intrin.odd_bits in
    (* And we should consider it as starting at an odd bit (-1). *)
    let start_odd = start land (I64_intrin.odd_bits lxor prev_escaped) in
    let end_2 = (start_odd + mask) land lnot mask in
    let end_odd_2 = end_2 land I64_intrin.even_bits in
    let end_odd = end_odd_1 lor end_odd_2 in
    end_odd, next_escaped
  ;;

  (* Mask indicating where we transition to/from being inside a quoted string. This must
     ignore escaped quotes inside quoted strings, and must respect the starting quoted
     state. *)
  let[@inline] quote_transitions unescaped escaped prev_in_string =
    let open Int64 in
    let c = I64_intrin.clmul unescaped in
    let d = I64_intrin.xor_masked_adjacent c escaped (I64_intrin.inot prev_in_string) in
    let next = unescaped lor d in
    let next_in_string = prev_in_string lxor (I64_intrin.count_set_bits next land 1L) in
    next, next_in_string
  ;;

  (* Mask indicating when we start a new run. Used to find the start of atoms that start
     with non-structural chars. *)
  let[@inline] range_transitions atom prev_atom_like =
    let open Int64 in
    range_starts_prev atom prev_atom_like
    lor range_starts_prev (lnot atom) (I64_intrin.inot prev_atom_like)
  ;;

  (* Convert 64 bytes of input to a mask indicating which characters may require state
     transitions. Updates state to indicate whether the next 64 bytes begins with an
     escaped character, is inside a quoted string, and is inside an atom. *)
  let[@inline] structural_mask t ~v0 ~v1 ~v2 ~v3 =
    let open Int64 in
    let pseudostructural = I64_intrin.bitmask v0 v1 v2 v3 ~f:is_pseudostructural in
    let atom_like = I64_intrin.bitmask v0 v1 v2 v3 ~f:is_atom_like in
    let backslash = I64_intrin.bitmask v0 v1 v2 v3 ~f:(I8x16.equal (backslashes ())) in
    let quote = I64_intrin.bitmask v0 v1 v2 v3 ~f:(I8x16.equal (quotes ())) in
    let escaped, next_escaped = odd_range_ends backslash (I64_intrin.to_64 t.escaped) in
    t.escaped <- next_escaped;
    let escaped_quotes = quote land escaped in
    let unescaped_quotes = quote land lnot escaped in
    let quote_transitions, next_in_string =
      quote_transitions unescaped_quotes escaped_quotes (I64_intrin.to_64 t.in_string)
    in
    let quoted =
      I64_intrin.(clmul quote_transitions lxor sign_extend (to_64 t.in_string))
    in
    t.in_string <- I64_intrin.of_64 next_in_string;
    let atom_like = atom_like land lnot quoted in
    let structural =
      quote_transitions
      land quoted
      lor (lnot quoted
           land (pseudostructural
                 lor range_transitions atom_like (I64_intrin.to_64 t.atom_like)))
    in
    t.atom_like <- I64_intrin.of_64 (atom_like lsr 63);
    structural
  ;;
end

module Parse = struct
  exception Error of string
  exception Restart of int

  type t =
    { mutable top : Sexp.t list (* List of sexps parsed at this depth *)
    ; mutable consumed : int (* Largest index the parser has consumed *)
    ; mutable block_comment_depth : int (* Nesting depth of block comments. *)
    ; stack : Sexp.t list Vec.t
        (* Parsing state at shallower depths. The length of this stack is the current
           parsing depth (how many parens we are under). Each element is a list of parsed
           sexps at that depth. *)
    ; sexp_comment_depth : int Vec.t
        (* Stack of depths at which we need to ignore a sexp due to a sexp comment. *)
    ; quoted_string_buffer : Buffer.t
    ; extract_16_buffer : Bigstring.t
    }

  let[@inline] create () =
    { top = []
    ; stack = Vec.create ~initial_capacity:16 ()
    ; consumed = -1
    ; sexp_comment_depth = Vec.create ()
    ; block_comment_depth = 0
    ; quoted_string_buffer = Buffer.create ()
    ; extract_16_buffer = Bigstring.create 16
    }
  ;;

  let[@cold] fail_bounds_check ~msg =
    raise (Error (sprintf "Unexpected end of string while parsing %s." msg))
  ;;

  let[@inline] bounds_check ~len ~idx ~msg = if idx >= len then fail_bounds_check ~msg

  let[@inline] get_digit_exn c ~idx =
    match Char.get_digit c with
    | None ->
      raise (Error (sprintf "Invalid decimal digit in escape code at index %d." idx))
    | Some digit -> digit
  ;;

  let[@inline] get_hex_digit_exn c ~idx =
    match Char.get_hex_digit c with
    | None -> raise (Error (sprintf "Invalid hex digit in escape code at index %d." idx))
    | Some digit -> digit
  ;;

  (* Parse "\000" starting from the 0. *)
  let[@inline] parse_decimal_escape input ~len ~idx =
    bounds_check ~len ~idx:(idx + 3) ~msg:"decimal escape code";
    let c0 = String.unsafe_get input idx |> get_digit_exn ~idx in
    let c1 = String.unsafe_get input (idx + 1) |> get_digit_exn ~idx:(idx + 1) in
    let c2 = String.unsafe_get input (idx + 2) |> get_digit_exn ~idx:(idx + 2) in
    (c0 * 100) + (c1 * 10) + c2
  ;;

  (* Parse "\x00" starting from the 0. *)
  let[@inline] parse_hex_escape input ~len ~idx =
    bounds_check ~len ~idx:(idx + 2) ~msg:"hex escape code";
    let c0 = String.unsafe_get input idx |> get_hex_digit_exn ~idx in
    let c1 = String.unsafe_get input (idx + 1) |> get_hex_digit_exn ~idx:(idx + 1) in
    (c0 * 16) + c1
  ;;

  (* Return index of the next non-space and non-tab character. *)
  let[@inline] skip_tabs_and_spaces ~input ~len ~idx ~extract_16_buffer =
    let[@inline] rec advance_from idx =
      let v = String_intrin.extract_16 input ~len ~idx ~extract_16_buffer in
      let n = Lex.chars_until_non_space_or_tab v in
      if idx + n >= len then len else if n = 16 then advance_from (idx + 16) else idx + n
    in
    advance_from idx
  ;;

  (* Check if the next character after an escaped carriage return is a newline. *)
  let[@inline] check_escaped_return ~input ~idx =
    idx < String.length input && Char.(String.unsafe_get input idx = '\n')
  ;;

  (* Parse "\$" for any escape code. Updates consumed to indicate we've seen the whole
     escape. *)
  let[@inline] parse_escaped input ~len ~idx ~extract_16_buffer =
    bounds_check ~len ~idx ~msg:"escape code";
    match String.unsafe_get input idx with
    | '\\' -> Some '\\', idx + 1
    | 'n' -> Some '\n', idx + 1
    | '\n' -> None, skip_tabs_and_spaces ~input ~len ~idx:(idx + 1) ~extract_16_buffer
    | 'r' -> Some '\r', idx + 1
    | '\r' ->
      if check_escaped_return ~input ~idx:(idx + 1)
      then None, skip_tabs_and_spaces ~input ~len ~idx:(idx + 2) ~extract_16_buffer
      else Some '\r', idx + 1
    | 't' -> Some '\t', idx + 1
    | 'b' -> Some '\b', idx + 1
    | '"' -> Some '"', idx + 1
    | '\'' -> Some '\'', idx + 1
    | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' ->
      let n = parse_decimal_escape input ~len ~idx in
      (match Char.of_int n with
       | None ->
         raise (Error (sprintf "Decimal escape sequence out of range at index %d." idx))
       | Some c -> Some c, idx + 3)
    | 'x' ->
      let n = parse_hex_escape input ~len ~idx:(idx + 1) in
      Some (Char.of_int_exn n), idx + 3
    | _ -> Some '\\', idx
  ;;

  (* Starting at [idx], parse an entire quoted string, updating [consumed] to indicate
     that we have processed up until its end. *)
  let[@inline] parse_quoted_string input ~buffer ~idx ~extract_16_buffer =
    let len = String.length input in
    let[@inline] rec advance_from idx =
      bounds_check ~len ~idx ~msg:"quoted string";
      let v = String_intrin.extract_16 input ~len ~idx ~extract_16_buffer in
      let n = Lex.n_quoted_string_chars v in
      Buffer.store buffer ~bytes:(Option.value ~default:16 n) ~v;
      (* If possible, jump forward 16 bytes. *)
      match n with
      | None -> advance_from (idx + 16)
      | Some n ->
        (* Otherwise, check for escaped chars or end of string. *)
        let idx = idx + n in
        if idx >= len
        then ()
        else (
          match String.unsafe_get input idx with
          | '"' -> ()
          | '\\' ->
            let c, idx = parse_escaped input ~len ~idx:(idx + 1) ~extract_16_buffer in
            Option.iter c ~f:(fun c -> Buffer.push buffer ~c);
            advance_from idx
          | c ->
            Buffer.push buffer ~c;
            advance_from (idx + 1))
    in
    Buffer.clear buffer;
    advance_from idx;
    let len = Buffer.length buffer in
    (* Build result string from buffer *)
    String.init len ~f:(Buffer.get buffer), len + 2
  ;;

  (*=If we get a # or | inside an unquoted string, we must check that
     it's not an invalid block comment signifier. *)
  let[@inline] check_block_comment_in_unquoted_string input ~len ~idx ~c =
    if len > idx + 1
    then (
      let next = String.unsafe_get input (idx + 1) in
      match c, next with
      | '#', '|' | '|', '#' ->
        raise (Error (sprintf "Comment token in unquoted atom at index %d." idx))
      | _ -> ())
  ;;

  (* Starting at [idx], parse an entire unquoted string, updating [consumed] to indicate
     that we have processed up until its end. *)
  let[@inline] parse_unquoted_string input ~idx ~extract_16_buffer =
    (* Don't need a buffer as we can copy directly from the input. *)
    let len = String.length input in
    let[@inline] rec advance_from idx =
      let v = String_intrin.extract_16 input ~len ~idx ~extract_16_buffer in
      let n = Lex.n_unquoted_string_chars v in
      (* Try to jump forward 16 bytes. *)
      if n < 16
      then (
        (* Otherwise, check for block comments or end of string. *)
        let idx = idx + n in
        if idx >= len
        then len
        else (
          match String.unsafe_get input idx with
          | ('#' | '|') as c ->
            check_block_comment_in_unquoted_string input ~len ~idx ~c;
            advance_from (idx + 1)
          | _ -> idx))
      else advance_from (idx + 16)
    in
    let fin = advance_from idx in
    (* Build result from substring of input *)
    String.init (fin - idx) ~f:(fun i -> String.unsafe_get input (idx + i))
  ;;

  (* Check for valid state at EOF. *)
  let[@inline] complete t =
    if Vec.length t.stack > 0
    then raise (Error "Found unclosed parentheses at end of input.");
    if t.block_comment_depth > 0
    then raise (Error "Found unclosed block comment at end of input.");
    if Vec.length t.sexp_comment_depth > 0
    then raise (Error "Found unclosed sexp comment at end of input.");
    List.rev t.top
  ;;

  (* Complete one sexp: either push it to the current list or ignore it and update the
     sexp comment state. *)
  let[@inline] complete_one t ~sexp =
    let len = Vec.length t.sexp_comment_depth in
    if len = 0
    then t.top <- sexp :: t.top
    else (
      match Vec.unsafe_get t.sexp_comment_depth (len - 1) with
      | d when d = Vec.length t.stack -> Vec.pop_back_unit_exn t.sexp_comment_depth
      | d when d > Vec.length t.stack ->
        raise (Error (sprintf "Found unclosed sexp comment at index %d." t.consumed))
      | _ -> ())
  ;;

  (*=When we see a # or |, we need to check if it's actually a block
     comment or sexp comment signifier. *)
  let[@inline] try_transition_complex_comment t ~input ~idx ~ctrl =
    if idx + 1 >= String.length input
    then false
    else (
      let next = String.unsafe_get input (idx + 1) in
      match ctrl, next with
      | '#', ';' when t.block_comment_depth = 0 ->
        Vec.push_back t.sexp_comment_depth (Vec.length t.stack);
        t.consumed <- idx + 1;
        true
      | '#', '|' ->
        t.block_comment_depth <- t.block_comment_depth + 1;
        t.consumed <- idx + 1;
        true
      | '|', '#' ->
        if t.block_comment_depth > 0
        then t.block_comment_depth <- t.block_comment_depth - 1
        else raise (Error (sprintf "Unbalanced block comment at index %d." t.consumed));
        t.consumed <- idx + 1;
        true
      | _ -> false)
  ;;

  (* Assert that carriage return is followed by a newline. *)
  let[@inline] require_newline ~input ~idx =
    if not (check_escaped_return ~input ~idx)
    then
      raise
        (Error (sprintf "Unexpected character after carriage return at index %d." idx))
  ;;

  (* Advance until the next newline. *)
  let[@inline] skip_line_comment t ~input ~idx ~extract_16_buffer =
    let len = String.length input in
    let[@inline] rec advance_from idx =
      let v = String_intrin.extract_16 input ~len ~idx ~extract_16_buffer in
      let n = Lex.chars_until_newline_or_return v in
      if idx + n >= len then len else if n = 16 then advance_from (idx + 16) else idx + n
    in
    let nl = advance_from idx in
    if nl < len && Char.(String.unsafe_get input nl = '\r')
    then require_newline ~input ~idx:(nl + 1);
    t.consumed <- nl
  ;;

  (* Update parser state based on the character at [idx]. *)
  let[@inline] transition t ~input ~idx =
    let no_comment = t.block_comment_depth = 0 in
    let ctrl = String.unsafe_get input idx in
    match ctrl with
    (* Whitespace *)
    | '\r' when no_comment -> require_newline ~input ~idx:(idx + 1)
    | ' ' | '\t' | '\n' | '\012' | '\r' -> ()
    (* Line comment *)
    | ';' when no_comment ->
      skip_line_comment t ~input ~idx:(idx + 1) ~extract_16_buffer:t.extract_16_buffer;
      raise (Restart t.consumed)
    (* Possible block or sexp comment *)
    | ('#' | '|') when try_transition_complex_comment t ~input ~idx ~ctrl -> ()
    (* Begin nested sexp *)
    | '(' when no_comment ->
      Vec.push_back t.stack t.top;
      t.top <- []
    (* End nested sexp *)
    | ')' when no_comment ->
      let top =
        match Vec.peek_back t.stack with
        | Null -> raise (Error (sprintf "Unbalanced parenthesis at index %d." idx))
        | This t -> t
      in
      let sexp = Sexp.List (List.rev t.top) in
      t.top <- top;
      Vec.pop_back_unit_exn t.stack;
      complete_one t ~sexp
    (* Quoted string *)
    | '"' ->
      let atom, len =
        parse_quoted_string
          input
          ~buffer:t.quoted_string_buffer
          ~idx:(idx + 1)
          ~extract_16_buffer:t.extract_16_buffer
      in
      t.consumed <- idx + len - 1;
      if no_comment then complete_one t ~sexp:(Sexp.Atom atom)
    (* All other characters indicate an unquoted string *)
    | _ when no_comment ->
      let atom =
        parse_unquoted_string input ~idx ~extract_16_buffer:t.extract_16_buffer
      in
      t.consumed <- idx + String.length atom - 1;
      complete_one t ~sexp:(Sexp.Atom atom)
    | _ -> ()
  ;;

  (* Transition unless the parser has skipped forward by parsing a string. *)
  let[@inline] maybe_transition t ~input ~idx =
    if idx > t.consumed && idx < String.length input
    then (
      t.consumed <- idx;
      transition t ~input ~idx)
    else ()
  ;;

  (* Transition through all structural indices in the 64 bytes starting from at [idx]. *)
  let[@inline] rec feed_masked t ~input ~idx ~structural_mask =
    match structural_mask with
    | 0L -> ()
    | _ ->
      let offset = I64_intrin.(count_trailing_zeros structural_mask |> of_64) in
      maybe_transition t ~input ~idx:(idx + offset);
      let next = Int64.(structural_mask land (structural_mask - 1L)) in
      feed_masked t ~input ~idx ~structural_mask:next
  ;;
end

exception Error = Parse.Error

let[@inline] parse_from input ~(parse : Parse.t) ~pos =
  let lex = Lex.create () in
  let len = String.length input in
  let remaining = len - pos in
  let chunks = (remaining + 63) / 64 in
  (* Process 64 bytes at a time. *)
  for chunk = 0 to chunks - 1 do
    let idx = pos + (chunk * 64) in
    let String_intrin.{ v0; v1; v2; v3 } =
      String_intrin.extract_64 input ~len ~idx ~extract_16_buffer:parse.extract_16_buffer
    in
    let structural_mask = Lex.structural_mask lex ~v0 ~v1 ~v2 ~v3 in
    Parse.feed_masked parse ~input ~idx ~structural_mask
  done
;;

(* Parse a list of sexps from a string. *)
let of_string_many input =
  let parse = Parse.create () in
  let[@inline] rec aux idx =
    try parse_from input ~parse ~pos:idx with
    | Parse.Restart idx -> aux idx
  in
  aux 0;
  Parse.complete parse
;;

(* Parse exactly one sexp from a string. *)
let of_string string =
  let list = of_string_many string in
  match list with
  | [] -> raise (Parse.Error "Found no sexps when exactly one was expected.")
  | [ sexp ] -> sexp
  | _ :: _ :: _ ->
    raise (Parse.Error "Found multiple sexps when exactly one was expected.")
;;

@@ portable

(** {v
 Refer to the Intel Intrinsics Guide (SSE4.2) for detailed specifications.
    https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html

    String comparisons: cmp[e,i]str[m,a,c,i,o,s,z] ~a ~b

    Each intrinsic inputs two [int8x16,int16x8] vectors representing strings.
    The comparison operation is specified by a ppx_simd directive: [%bytes] for
    byte strings, and [%words] for word strings.

    ---- Lengths

    e : the lengths of the strings are given as parameters [a_len] and [b_len].
    i : the strings are assumed to be either null-terminated or full-vector-length.

    ---- Returns

    m : return a vector mask indicating which characters passed the condition.
    - With [Bit_mask]: set only the bottom [16,8] bits of the mask.
    - With [Vec_mask]: set each [byte,word] of the mask to [0xff,0xffff].

    a : return 1 if y is full-length and the comparison mask is zero
    c : return 1 if the comparison mask is non-zero
    i : return the index of the [first,last] character that passed the comparison,
    _   based on [Least_sig,Most_sig].
    o : return the least significant bit of the comparison mask
    s : return 1 if x is not full-length
    z : return 1 if y is not full-length

    ---- Examples

    Finding the index of the first byte that differs:

    [Byte.cmpistri [%bytes Signed, Eq_each, Masked_neg, Least_sig] ~a ~b]

    Creating a mask of bytes that are ASCII decimal digits:

    [
    let a = Int8x16.const 0x30 0x31 0x32 0x33 0x34 0x35 0x36 0x37 0x38 0x39 0x30 0x30 0x30 0x30 0x30 0x30 in
    Byte.cmpistrm [%bytes Signed, Eq_any, Pos, Vec_mask] ~a ~b
    ]

    Checking if any byte is not an ASCII letter:

    [
    let a = Int8x16.const 0x41 0x5A 0x61 0x7A 0x41 0x5A 0x61 0x7A 0x41 0x5A 0x61 0x7A 0x41 0x5A 0x61 0x7A in
    Byte.cmpistrc [%bytes Signed, In_range, Masked_neg] ~a ~b
    ]

    Finding the index of the first byte of the first occurance of a in b:

    [Byte.cmpistri [%bytes Signed, Eq_ordered, Pos, Least_sig] ~a ~b]
    v} *)

module Signed : sig
  type t = Ocaml_simd.String.Signed.t =
    | Signed (** strings contain signed characters *)
    | Unsigned (** strings contain unsigned characters *)
end

module Comparison : sig
  type t = Ocaml_simd.String.Comparison.t =
    | Eq_any (** if y[i] = x[j] for some valid j *)
    | Eq_each (** if x[i] = y[i] *)
    | Eq_ordered (** if x = y[i:i+len(x)] *)
    | In_range (** if y[i] >= x[2*j] and y[i] <= x[2*j+1] for some valid j *)
end

module Polarity : sig
  type t = Ocaml_simd.String.Polarity.t =
    | Pos (** do not negate result *)
    | Neg (** negate result *)
    | Masked_pos (** compute and negate result only before EOS *)
    | Masked_neg (** compute result only before EOS *)
end

module Index : sig
  type t = Ocaml_simd.String.Index.t =
    | Least_sig (** return last significant bit *)
    | Most_sig (** return most significant bit *)
end

module Mask : sig
  type t = Ocaml_simd.String.Mask.t =
    | Bit_mask (** return bit mask *)
    | Vec_mask (** return byte/word mask *)
end

module Byte : sig
  type t = Int8x16.t
  type mask = Int8x16.mask

  (** Specify comparison with pxp_simd: [%bytes S, C, P, M] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (M : Mask.t) *)
  external cmpestrm
    :  (Ocaml_simd.String.Bytesm.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> mask
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrm"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpestra
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestra"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpestrc
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrc"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P, I] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (I : Index.t) *)
  external cmpestri
    :  (Ocaml_simd.String.Bytesi.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestri"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpestro
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestro"
  [@@noalloc] [@@builtin]

  val cmpestrs : a:t -> b:t -> a_len:int64# -> b_len:int64# -> int64#
  val cmpestrz : a:t -> b:t -> a_len:int64# -> b_len:int64# -> int64#

  (** Specify comparison with pxp_simd: [%bytes S, C, P, M] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (M : Mask.t) *)
  external cmpistrm
    :  (Ocaml_simd.String.Bytesm.t[@untagged])
    -> a:t
    -> b:t
    -> mask
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrm"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpistra
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistra"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpistrc
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrc"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P, I] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (I : Index.t) *)
  external cmpistri
    :  (Ocaml_simd.String.Bytesi.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistri"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%bytes S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpistro
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistro"
  [@@noalloc] [@@builtin]

  val cmpistrs : a:t -> b:t -> int64#
  val cmpistrz : a:t -> b:t -> int64#
end

module Word : sig
  type t = Int16x8.t
  type mask = Int16x8.mask

  (** Specify comparison with pxp_simd: [%words S, C, P, M] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (M : Mask.t) *)
  external cmpestrm
    :  (Ocaml_simd.String.Wordsm.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> mask
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrm"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpestra
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestra"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpestrc
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrc"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P, I] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (I : Index.t) *)
  external cmpestri
    :  (Ocaml_simd.String.Wordsi.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestri"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpestro
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestro"
  [@@noalloc] [@@builtin]

  val cmpestrs : a:t -> b:t -> a_len:int64# -> b_len:int64# -> int64#
  val cmpestrz : a:t -> b:t -> a_len:int64# -> b_len:int64# -> int64#

  (** Specify comparison with pxp_simd: [%words S, C, P, M] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (M : Mask.t) *)
  external cmpistrm
    :  (Ocaml_simd.String.Wordsm.t[@untagged])
    -> a:t
    -> b:t
    -> mask
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrm"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpistra
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistra"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpistrc
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrc"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P, I] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t), (I : Index.t) *)
  external cmpistri
    :  (Ocaml_simd.String.Wordsi.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistri"
  [@@noalloc] [@@builtin]

  (** Specify comparison with pxp_simd: [%words S, C, P] where (S : Signed.t), (C :
      Comparison.t), (P : Polarity.t) *)
  external cmpistro
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistro"
  [@@noalloc] [@@builtin]

  val cmpistrs : a:t -> b:t -> int64#
  val cmpistrz : a:t -> b:t -> int64#
end

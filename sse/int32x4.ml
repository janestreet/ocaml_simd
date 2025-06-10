module I = Int32x4_internal

type t = int32x4#
type mask = int32x4#

external box : t -> int32x4 @@ portable = "%box_vec128"
external unbox : int32x4 -> t @@ portable = "%unbox_vec128"

module String = Load_store.String_Int32x4
module Bytes = Load_store.Bytes_Int32x4
module Bigstring = Load_store.Bigstring_Int32x4
module Int32_u_array = Load_store.Int32_u_array

external const1
  :  int32#
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int32x4_const1"
[@@noalloc] [@@builtin]

external const
  :  int32#
  -> int32#
  -> int32#
  -> int32#
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int32x4_const4"
[@@noalloc] [@@builtin]

external shuffle
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse_vec128_shuffle_32"
[@@noalloc] [@@builtin]

let[@inline always] zero () = const1 #0l
let[@inline always] one () = const1 #1l
let[@inline always] all_ones () = const1 #0xffffffffl

let[@inline always] set1 a =
  let a = I.low_of a in
  shuffle [%shuffle 0, 0, 0, 0] a a
;;

let[@inline always] set a b c d =
  (* movd, + 3x insert -> 7 cycle latency
     this              -> 3 cycle latency *)
  let a = I.low_of a in
  let b = I.low_of b in
  let c = I.low_of c in
  let d = I.low_of d in
  let ba = I.interleave_low_32 a b in
  let dc = I.interleave_low_32 c d in
  I.interleave_low_64 ba dc
;;

external extract
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> int32#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int32x4_extract"
[@@noalloc] [@@builtin]

external insert
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> int32#
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int32x4_insert"
[@@noalloc] [@@builtin]

let[@inline always] movemask m = I.movemask_32 m
let[@inline always] select m ~fail ~pass = I.blendv_32 fail pass m
let[@inline always] extract0 x = I.low_to x

type splat =
  { a : int32#
  ; b : int32#
  ; c : int32#
  ; d : int32#
  }

let[@inline always] splat x =
  (* 3x shuffle, 4x movd -> 4 cycle latency
     this                -> 4 cycle latency but fewer registers *)
  { a = extract0 x; b = extract ~idx:1 x; c = extract ~idx:2 x; d = extract ~idx:3 x }
;;

(* Comparisons do not use [C.not_...], as they have different NaN behavior. *)
let[@inline always] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline always] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline always] ( = ) x y = I.cmpeq x y
let[@inline always] ( > ) x y = I.cmpgt x y
let[@inline always] ( < ) x y = I.cmpgt y x
let[@inline always] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline always] equal x y = I.cmpeq x y
let[@inline always] interleave_upper ~lower ~upper = I.interleave_high_32 lower upper
let[@inline always] interleave_lower ~lower ~upper = I.interleave_low_32 lower upper
let[@inline always] duplicate_even x = I.dup_even_32 x
let[@inline always] duplicate_odd x = I.dup_odd_32 x

external blend
  :  (Ocaml_simd.Blend4.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blend_32"
[@@noalloc] [@@builtin]

let[@inline always] min x y = I.min x y
let[@inline always] max x y = I.max x y
let[@inline always] min_unsigned x y = I.min_unsigned x y
let[@inline always] max_unsigned x y = I.max_unsigned x y
let[@inline always] add x y = I.add x y
let[@inline always] sub x y = I.sub x y
let[@inline always] neg x = I.(mulsign x (all_ones ()))
let[@inline always] abs x = I.abs x

external shifti_left_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

external shifti_right_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

external shifti_left_logical
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_srli"
[@@noalloc] [@@builtin]

external shifti_right_arithmetic
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_srai"
[@@noalloc] [@@builtin]

let[@inline always] horizontal_add x y = I.horizontal_add x y
let[@inline always] horizontal_sub x y = I.horizontal_sub x y
let[@inline always] mul_low_bits x y = I.mul_low x y
let[@inline always] mulsign x y = I.mulsign x y
let[@inline always] ( + ) x y = I.add x y
let[@inline always] ( - ) x y = I.sub x y
let[@inline always] ( lor ) x y = I.or_ x y
let[@inline always] ( land ) x y = I.and_ x y
let[@inline always] ( lxor ) x y = I.xor x y
let[@inline always] lnot m = I.(xor (all_ones ()) m)
let[@inline always] landnot ~not y = I.andnot ~not y
let[@inline always] of_float32x4_bits x = I.of_float32x4 x
let[@inline always] of_float64x2_bits x = I.of_float64x2 x
let[@inline always] of_int8x16_bits x = I.of_int8x16 x
let[@inline always] of_int16x8_bits x = I.of_int16x8 x
let[@inline always] of_int64x2_bits x = I.of_int64x2 x
let[@inline always] of_float32x4 x = Float32x4_internal.cvt_i32 x
let[@inline always] of_int8x16 x = Int8x16_internal.cvtsx_i32 x
let[@inline always] of_int8x16_unsigned x = Int8x16_internal.cvtzx_i32 x
let[@inline always] of_int16x8 x = Int16x8_internal.cvtsx_i32 x
let[@inline always] of_int16x8_unsigned x = Int16x8_internal.cvtzx_i32 x
let[@inline always] of_float64x2 x = Float64x2_internal.cvt_i32 x

let[@inline always] shift_left_logical x i =
  let c = Int64x2_internal.low_of (Int64_u.of_int i) in
  I.(sll x c)
;;

let[@inline always] shift_right_logical x i =
  let c = Int64x2_internal.low_of (Int64_u.of_int i) in
  I.(srl x c)
;;

let[@inline always] shift_right_arithmetic x i =
  let c = Int64x2_internal.low_of (Int64_u.of_int i) in
  I.(sra x c)
;;

let[@inline always] to_string x =
  let f = Int32_u.to_int32 in
  let { a; b; c; d } = splat x in
  Stdlib.Printf.sprintf "(%ld %ld %ld %ld)" (f a) (f b) (f c) (f d)
;;

let[@inline always] of_string s =
  let f = Int32_u.of_int32 in
  Stdlib.Scanf.sscanf s "(%ld %ld %ld %ld)" (fun a b c d ->
    set (f a) (f b) (f c) (f d) |> box)
  |> unbox
;;

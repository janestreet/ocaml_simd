module I = Float16x8_internal

type t = float16x8#

external box : t -> float16x8 @@ portable = "%box_vec128"
external unbox : float16x8 @ local -> t @@ portable = "%unbox_vec128"

module Raw = Load_store.Raw_Float16x8
module String = Load_store.String_Float16x8
module Bytes = Load_store.Bytes_Float16x8
module Bigstring = Load_store.Bigstring_Float16x8

external blend
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_16"
[@@noalloc] [@@builtin]

external shuffle_upper
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_high_16"
[@@noalloc] [@@builtin]

external shuffle_lower
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_low_16"
[@@noalloc] [@@builtin]

let[@inline] interleave_upper ~even ~odd = I.interleave_high_16 even odd
let[@inline] interleave_lower ~even ~odd = I.interleave_low_16 even odd
let[@inline] of_float32x4_bits x = I.of_float32x4 x
let[@inline] of_float64x2_bits x = I.of_float64x2 x
let[@inline] of_int8x16_bits x = I.of_int8x16 x
let[@inline] of_int16x8_bits x = I.of_int16x8 x
let[@inline] of_int32x4_bits x = I.of_int32x4 x
let[@inline] of_int64x2_bits x = I.of_int64x2 x

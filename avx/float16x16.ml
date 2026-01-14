module I = Float16x16_internal

type t = float16x16#

external box : t -> float16x16 @@ portable = "%box_vec256"
external unbox : float16x16 @ local -> t @@ portable = "%unbox_vec256"

module Raw = Load_store.Raw_Float16x16
module String = Load_store.String_Float16x16
module Bytes = Load_store.Bytes_Float16x16
module Bigstring = Load_store.Bigstring_Float16x16

external shuffle_upper_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shuffle_high_16"
[@@noalloc] [@@builtin]

external shuffle_lower_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shuffle_low_16"
[@@noalloc] [@@builtin]

external blend_lanes
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_blend_16"
[@@noalloc] [@@builtin]

external insert_lane
  :  idx:int64#
  -> t
  -> float16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

external extract_lane
  :  idx:int64#
  -> t
  -> float16x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

let[@inline] extract_lane0 x = I.low_to_f16x8 x
let[@inline] set_lanes a b = insert_lane ~idx:#1L (I.low_of_f16x8 a) b
let[@inline] interleave_upper_lanes ~even ~odd = I.interleave_high_16 even odd
let[@inline] interleave_lower_lanes ~even ~odd = I.interleave_low_16 even odd
let[@inline] unsafe_of_float16x8 x = I.low_of_f16x8 x
let[@inline] of_float32x8_bits x = I.of_float32x8 x
let[@inline] of_float64x4_bits x = I.of_float64x4 x
let[@inline] of_int8x32_bits x = I.of_int8x32 x
let[@inline] of_int16x16_bits x = I.of_int16x16 x
let[@inline] of_int32x8_bits x = I.of_int32x8 x
let[@inline] of_int64x4_bits x = I.of_int64x4 x

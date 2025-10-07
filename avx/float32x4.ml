include Ocaml_simd_sse.Float32x4

external set1
  :  float32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_broadcast_32"
[@@noalloc] [@@builtin]

external permute
  :  (Ocaml_simd.Permute4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permute_32"
[@@noalloc] [@@builtin]

external permute_by
  :  t
  -> idx:int32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permutev_32"
[@@noalloc] [@@builtin]

let[@inline] of_float64x4 x = Float64x4_internal.cvt_f32 x
let[@inline] of_float32x8 x = Float32x8_internal.low_to_f32x4 x

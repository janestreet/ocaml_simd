include Ocaml_simd_sse.Float64x2

external permute
  :  (Ocaml_simd.Permute2.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permute_64"
[@@noalloc] [@@builtin]

external permute_by
  :  t
  -> idx:int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permutev_64"
[@@noalloc] [@@builtin]

let[@inline] of_float64x4 x = Float64x4_internal.low_to_f64x2 x

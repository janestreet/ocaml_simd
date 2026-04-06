external mul_add
  :  float#
  -> float#
  -> float#
  -> float#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64_mul_add"
[@@noalloc] [@@builtin amd64]

external mul_sub
  :  float#
  -> float#
  -> float#
  -> float#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64_mul_sub"
[@@noalloc] [@@builtin amd64]

external neg_mul_add
  :  float#
  -> float#
  -> float#
  -> float#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64_neg_mul_add"
[@@noalloc] [@@builtin amd64]

external neg_mul_sub
  :  float#
  -> float#
  -> float#
  -> float#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64_neg_mul_sub"
[@@noalloc] [@@builtin amd64]

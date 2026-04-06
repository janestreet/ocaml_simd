external mul_add
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32_mul_add"
[@@noalloc] [@@builtin amd64]

external mul_sub
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32_mul_sub"
[@@noalloc] [@@builtin amd64]

external neg_mul_add
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32_neg_mul_add"
[@@noalloc] [@@builtin amd64]

external neg_mul_sub
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32_neg_mul_sub"
[@@noalloc] [@@builtin amd64]

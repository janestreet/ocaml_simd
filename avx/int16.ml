include Ocaml_simd_sse.Int16

external count_leading_zeros
  :  int16#
  -> int16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_lzcnt_int16"
[@@noalloc] [@@builtin amd64]

external count_trailing_zeros
  :  int16#
  -> int16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_tzcnt_int16"
[@@noalloc] [@@builtin amd64]

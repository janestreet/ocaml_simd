module Raw = Load_store.Int32

external count_set_bits
  :  int32#
  -> int32#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_popcnt_int32"
[@@noalloc] [@@builtin amd64]

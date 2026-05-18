module Raw = Load_store.Int64

external count_set_bits
  :  int64#
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_popcnt_int64"
[@@noalloc] [@@builtin amd64]

module Raw = Load_store.Int64

external count_set_bits
  :  int64#
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int64_popcnt_unboxed_to_untagged"
[@@noalloc] [@@builtin]

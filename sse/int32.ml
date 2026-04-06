module Raw = Load_store.Int32

external count_set_bits
  :  int32#
  -> int32#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int32_popcnt_unboxed_to_untagged"
[@@noalloc] [@@builtin]

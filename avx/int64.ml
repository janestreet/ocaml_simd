include Ocaml_simd_sse.Int64

external count_leading_zeros
  :  int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_lzcnt_int64"
[@@noalloc] [@@builtin amd64]

external and_not
  :  int64#
  -> int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_andn_int64"
[@@noalloc] [@@builtin amd64]

external extract_bits
  :  int64#
  -> int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_bextr_int64"
[@@noalloc] [@@builtin amd64]

let[@inline] extract_bits x ~pos ~len =
  let ctrl = Int64_u.(shift_left len 8 lor pos) in
  extract_bits x ctrl
;;

external extract_lowest_set_bit
  :  int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_blsi_int64"
[@@noalloc] [@@builtin amd64]

external mask_up_to_lowest_set_bit
  :  int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_blsmsk_int64"
[@@noalloc] [@@builtin amd64]

external clear_lowest_set_bit
  :  int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_blsr_int64"
[@@noalloc] [@@builtin amd64]

external count_trailing_zeros
  :  int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_tzcnt_int64"
[@@noalloc] [@@builtin amd64]

external zero_high_bits
  :  int64#
  -> idx:int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_bzhi_int64"
[@@noalloc] [@@builtin amd64]

external mul_unsigned
  :  int64#
  -> int64#
  -> #(low:int64# * high:int64#)
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_mulx_int64"
[@@noalloc] [@@builtin amd64]

external gather_bits
  :  int64#
  -> mask:int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_pext_int64"
[@@noalloc] [@@builtin amd64]

external scatter_bits
  :  int64#
  -> mask:int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_pdep_int64"
[@@noalloc] [@@builtin amd64]

external rotate_right
  :  bits:int64#
  -> int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_rorx_int64"
[@@noalloc] [@@builtin amd64]

external shift_right
  :  int64#
  -> int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_sarx_int64"
[@@noalloc] [@@builtin amd64]

external shift_right_logical
  :  int64#
  -> int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_shrx_int64"
[@@noalloc] [@@builtin amd64]

external shift_left
  :  int64#
  -> int64#
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_shlx_int64"
[@@noalloc] [@@builtin amd64]

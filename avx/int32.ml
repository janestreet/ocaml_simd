include Ocaml_simd_sse.Int32

external count_leading_zeros
  :  int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_lzcnt_int32"
[@@noalloc] [@@builtin amd64]

external and_not
  :  int32#
  -> int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_andn_int32"
[@@noalloc] [@@builtin amd64]

external extract_bits
  :  int32#
  -> int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_bextr_int32"
[@@noalloc] [@@builtin amd64]

let[@inline] extract_bits x ~pos ~len =
  let ctrl = Int32_u.(shift_left len 8 lor pos) in
  extract_bits x ctrl
;;

external extract_lowest_set_bit
  :  int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_blsi_int32"
[@@noalloc] [@@builtin amd64]

external mask_up_to_lowest_set_bit
  :  int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_blsmsk_int32"
[@@noalloc] [@@builtin amd64]

external clear_lowest_set_bit
  :  int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_blsr_int32"
[@@noalloc] [@@builtin amd64]

external count_trailing_zeros
  :  int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi_tzcnt_int32"
[@@noalloc] [@@builtin amd64]

external zero_high_bits
  :  int32#
  -> idx:int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_bzhi_int32"
[@@noalloc] [@@builtin amd64]

external mul_unsigned
  :  int32#
  -> int32#
  -> #(low:int64# * high:int64#)
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_mulx_int32"
[@@noalloc] [@@builtin amd64]

let[@inline] mul_unsigned x y =
  let open struct
    external i64_to_i32 : int64# -> int32# @@ portable = "%int32#_of_int64#"
  end in
  let #(~low, ~high) = mul_unsigned x y in
  #(~low:(i64_to_i32 low), ~high:(i64_to_i32 high))
;;

external gather_bits
  :  int32#
  -> mask:int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_pext_int32"
[@@noalloc] [@@builtin amd64]

external scatter_bits
  :  int32#
  -> mask:int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_pdep_int32"
[@@noalloc] [@@builtin amd64]

external rotate_right
  :  bits:int64#
  -> int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_rorx_int32"
[@@noalloc] [@@builtin amd64]

external shift_right
  :  int32#
  -> int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_sarx_int32"
[@@noalloc] [@@builtin amd64]

external shift_right_logical
  :  int32#
  -> int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_shrx_int32"
[@@noalloc] [@@builtin amd64]

external shift_left
  :  int32#
  -> int32#
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_bmi2_shlx_int32"
[@@noalloc] [@@builtin amd64]

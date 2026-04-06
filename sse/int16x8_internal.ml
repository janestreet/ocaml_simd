type t = int16x8#

external const1
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int16x8_const1"
[@@noalloc] [@@builtin]

external low_of
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int16x8_low_of_int16"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> int16#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int16x8_low_to_int16"
[@@noalloc] [@@builtin]

external insert
  :  idx:int64#
  -> t
  -> int16#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int16x8_insert") (arm64, "caml_neon_int16x8_insert")]

external extract
  :  idx:int64#
  -> t
  -> int16#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int16x8_extract") (arm64, "caml_neon_int16x8_extract")]

external of_int8x16
  :  int8x16#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_vec128_cast"
[@@noalloc] [@@builtin]

external of_int32x4
  :  int32x4#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_vec128_cast"
[@@noalloc] [@@builtin]

external of_int64x2
  :  int64x2#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_vec128_cast"
[@@noalloc] [@@builtin]

external of_float16x8
  :  float16x8#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_vec128_cast"
[@@noalloc] [@@builtin]

external of_float32x4
  :  float32x4#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_vec128_cast"
[@@noalloc] [@@builtin]

external of_float64x2
  :  float64x2#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_vec128_cast"
[@@noalloc] [@@builtin]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int16x8_add") (arm64, "caml_neon_int16x8_add")]

external add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int16x8_add_saturating") (arm64, "caml_neon_int16x8_add_saturating")]

external add_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int16x8_add_saturating_unsigned")
    (arm64, "caml_neon_int16x8_add_saturating_unsigned")]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int16x8_sub") (arm64, "caml_neon_int16x8_sub")]

external sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int16x8_sub_saturating") (arm64, "caml_neon_int16x8_sub_saturating")]

external sub_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int16x8_sub_saturating_unsigned")
    (arm64, "caml_neon_int16x8_sub_saturating_unsigned")]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int16x8_max") (arm64, "caml_neon_int16x8_max")]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int16x8_min") (arm64, "caml_neon_int16x8_min")]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_int16x8_max_unsigned") (arm64, "caml_neon_int16x8_max_unsigned")]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_int16x8_min_unsigned") (arm64, "caml_neon_int16x8_min_unsigned")]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int16x8_cmpeq") (arm64, "caml_neon_int16x8_cmpeq")]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int16x8_cmpgt") (arm64, "caml_neon_int16x8_cmpgt")]

external abs
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_ssse3_int16x8_abs") (arm64, "caml_neon_int16x8_abs")]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_ssse3_int16x8_hadd") (arm64, "caml_neon_int16x8_hadd")]

external horizontal_add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int16x8_hadd_saturating"
[@@noalloc] [@@builtin amd64]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int16x8_hsub"
[@@noalloc] [@@builtin amd64]

external horizontal_sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int16x8_hsub_saturating"
[@@noalloc] [@@builtin amd64]

external mul_sign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int16x8_mulsign"
[@@noalloc] [@@builtin amd64]

external avg_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int16x8_avg_unsigned"
[@@noalloc] [@@builtin amd64]

external minpos_unsigned
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_int16x8_minpos_unsigned"
[@@noalloc] [@@builtin amd64]

external mul_low
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int16x8_mul_low") (arm64, "caml_neon_int16x8_mul_low")]

external mul_horizontal_add
  :  t
  -> t
  -> int32x4#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int16x8_mul_hadd_int32x4"
[@@noalloc] [@@builtin amd64]

external mul_round
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int16x8_mul_round"
[@@noalloc] [@@builtin amd64]

external and_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_and") (arm64, "caml_neon_int16x8_bitwise_and")]

external or_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_or") (arm64, "caml_neon_int16x8_bitwise_or")]

external xor
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_xor") (arm64, "caml_neon_int16x8_bitwise_xor")]

external shuffle_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_vec128_shuffle_8"
[@@noalloc] [@@builtin amd64]

external interleave_low_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_low_16") (arm64, "caml_neon_int16x8_zip1")]

external interleave_high_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_high_16") (arm64, "caml_neon_int16x8_zip2")]

external interleave_low_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse_vec128_interleave_low_32") (arm64, "caml_neon_float32x4_zip1")]

external interleave_low_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_low_64") (arm64, "caml_neon_float64x2_zip1")]

external cvt_su8
  :  t
  -> t
  -> int8x16#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_cvt_int16x8_int8x16_saturating_unsigned"
[@@noalloc] [@@builtin amd64]

external cvtsx_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_cvtsx_int16x8_int32x4") (arm64, "caml_neon_cvtsx_int16x8_to_int32x4")]

external cvtzx_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_cvtzx_int16x8_int32x4") (arm64, "caml_neon_cvtzx_int16x8_to_int32x4")]

(* Not implemented on arm64. *)
module Sse = struct
  external cvt_si8
    :  t
    -> t
    -> int8x16#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_cvt_int16x8_int8x16_saturating"]

  external andnot
    :  not:t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse_vec128_andnot"]

  external mul_high
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int16x8_mul_high"]

  external mul_high_unsigned
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int16x8_mul_high_unsigned"]

  external sll
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int16x8_sll"]

  external srl
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int16x8_srl"]

  external sra
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int16x8_sra"]

  external cvtsx_i64
    :  t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_cvtsx_int16x8_int64x2"]

  external cvtzx_i64
    :  t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_cvtzx_int16x8_int64x2"]
end

(* Not implemented on amd64. *)
module Neon = struct
  external shift
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int16x8_sshl"]

  external shift_logical
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int16x8_ushl"]

  external broadcast
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int16x8_dup"]

  external cvt_si8_low
    :  t
    -> int8x16#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int16x8_to_int8x16_low_saturating"]

  external cvt_si8_high
    :  int8x16#
    -> t
    -> int8x16#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int16x8_to_int8x16_high_saturating"]

  external mul32_low
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int16x8_mul_low_long"]

  external mul32_high
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int16x8_mul_high_long"]

  external mul32_low_unsigned
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int16x8_mul_low_long_unsigned"]

  external mul32_high_unsigned
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int16x8_mul_high_long_unsigned"]
end

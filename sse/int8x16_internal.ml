type t = int8x16#

external low_of
  :  int8#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int8x16_low_of_int8"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> int8#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int8x16_low_to_int8"
[@@noalloc] [@@builtin]

external insert
  :  idx:int64#
  -> t
  -> int8#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int8x16_insert") (arm64, "caml_neon_int8x16_insert")]

external extract
  :  idx:int64#
  -> t
  -> int8#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int8x16_extract") (arm64, "caml_neon_int8x16_extract")]

external const1
  :  int8#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int8x16_const1"
[@@noalloc] [@@builtin]

external of_int16x8
  :  int16x8#
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
[@@noalloc] [@@builtin (amd64, "caml_sse2_int8x16_add") (arm64, "caml_neon_int8x16_add")]

external add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int8x16_add_saturating") (arm64, "caml_neon_int8x16_add_saturating")]

external add_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int8x16_add_saturating_unsigned")
    (arm64, "caml_neon_int8x16_add_saturating_unsigned")]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int8x16_sub") (arm64, "caml_neon_int8x16_sub")]

external sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int8x16_sub_saturating") (arm64, "caml_neon_int8x16_sub_saturating")]

external sub_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int8x16_sub_saturating_unsigned")
    (arm64, "caml_neon_int8x16_sub_saturating_unsigned")]

external mul_horizontal_add_saturating
  :  t
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int8x16_mul_unsigned_hadd_saturating_int16x8"
[@@noalloc] [@@builtin amd64]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse41_int8x16_max") (arm64, "caml_neon_int8x16_max")]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse41_int8x16_min") (arm64, "caml_neon_int8x16_min")]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int8x16_max_unsigned") (arm64, "caml_neon_int8x16_max_unsigned")]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_int8x16_min_unsigned") (arm64, "caml_neon_int8x16_min_unsigned")]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int8x16_cmpeq") (arm64, "caml_neon_int8x16_cmpeq")]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int8x16_cmpgt") (arm64, "caml_neon_int8x16_cmpgt")]

external and_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_and") (arm64, "caml_neon_int8x16_bitwise_and")]

external or_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_or") (arm64, "caml_neon_int8x16_bitwise_or")]

external xor
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_xor") (arm64, "caml_neon_int8x16_bitwise_xor")]

external movemask_8
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_movemask_8"
[@@noalloc] [@@builtin amd64]

external interleave_low_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_vec128_interleave_low_8") (arm64, "caml_neon_int8x16_zip1")]

external interleave_high_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_high_8") (arm64, "caml_neon_int8x16_zip2")]

external interleave_low_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_low_16") (arm64, "caml_neon_int16x8_zip1")]

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

external abs
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_ssse3_int8x16_abs") (arm64, "caml_neon_int8x16_abs")]

external mul_sign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int8x16_mulsign"
[@@noalloc] [@@builtin amd64]

external avg_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int8x16_avg_unsigned"
[@@noalloc] [@@builtin amd64]

external sadu
  :  t
  -> t
  -> int64x2#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int8x16_sad_unsigned"
[@@noalloc] [@@builtin amd64]

external shuffle_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_vec128_shuffle_8"
[@@noalloc] [@@builtin amd64]

external blendv_8
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blendv_8"
[@@noalloc] [@@builtin amd64]

external cvtsx_i16
  :  t
  -> int16x8#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_cvtsx_int8x16_int16x8") (arm64, "caml_neon_cvtsx_int8x16_to_int16x8")]

external cvtzx_i16
  :  t
  -> int16x8#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_cvtzx_int8x16_int16x8") (arm64, "caml_neon_cvtzx_int8x16_to_int16x8")]

(* Not implemented on arm64. *)
module Sse = struct
  external andnot
    :  not:t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse_vec128_andnot"]

  external cvtsx_i32
    :  t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_cvtsx_int8x16_int32x4"]

  external cvtzx_i32
    :  t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_cvtzx_int8x16_int32x4"]

  external cvtsx_i64
    :  t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_cvtsx_int8x16_int64x2"]

  external cvtzx_i64
    :  t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_cvtzx_int8x16_int64x2"]
end

(* Not implemented on amd64. *)
module Neon = struct
  external broadcast
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int8x16_dup"]
end

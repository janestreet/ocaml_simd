type t = int32x4#

external low_of
  :  int32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int32x4_low_of_int32"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> int32#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int32x4_low_to_int32"
[@@noalloc] [@@builtin]

external insert
  :  idx:int64#
  -> t
  -> int32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int32x4_insert") (arm64, "caml_neon_int32x4_insert")]

external extract
  :  idx:int64#
  -> t
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int32x4_extract") (arm64, "caml_neon_int32x4_extract")]

external of_int8x16
  :  int8x16#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_vec128_cast"
[@@noalloc] [@@builtin]

external of_int16x8
  :  int16x8#
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

external movemask_32
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse_vec128_movemask_32"
[@@noalloc] [@@builtin amd64]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int32x4_add") (arm64, "caml_neon_int32x4_add")]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int32x4_sub") (arm64, "caml_neon_int32x4_sub")]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int32x4_cmpeq") (arm64, "caml_neon_int32x4_cmpeq")]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int32x4_cmpgt") (arm64, "caml_neon_int32x4_cmpgt")]

external abs
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_ssse3_int32x4_abs") (arm64, "caml_neon_int32x4_abs")]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_ssse3_int32x4_hadd") (arm64, "caml_neon_int32x4_hadd")]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int32x4_hsub"
[@@noalloc] [@@builtin amd64]

external mul_sign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_int32x4_mulsign"
[@@noalloc] [@@builtin amd64]

external mul_even
  :  t
  -> t
  -> int64x2#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_int32x4_mul_even"
[@@noalloc] [@@builtin amd64]

external mul_even_unsigned
  :  t
  -> t
  -> int64x2#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int32x4_mul_even_unsigned"
[@@noalloc] [@@builtin amd64]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse41_int32x4_max") (arm64, "caml_neon_int32x4_max")]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_int32x4_max_unsigned") (arm64, "caml_neon_int32x4_max_unsigned")]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse41_int32x4_min") (arm64, "caml_neon_int32x4_min")]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_int32x4_min_unsigned") (arm64, "caml_neon_int32x4_min_unsigned")]

external mul_low
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int32x4_mul_low") (arm64, "caml_neon_int32x4_mul_low")]

external interleave_low_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse_vec128_interleave_low_32") (arm64, "caml_neon_float32x4_zip1")]

external interleave_high_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse_vec128_interleave_high_32") (arm64, "caml_neon_float32x4_zip2")]

external interleave_low_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_low_64") (arm64, "caml_neon_float64x2_zip1")]

external blendv_32
  :  t
  -> t
  -> int32x4#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blendv_32"
[@@noalloc] [@@builtin amd64]

external dup_odd_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_vec128_dup_odd_32"
[@@noalloc] [@@builtin amd64]

external dup_even_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_vec128_dup_even_32"
[@@noalloc] [@@builtin amd64]

external and_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_and") (arm64, "caml_neon_int32x4_bitwise_and")]

external or_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_or") (arm64, "caml_neon_int32x4_bitwise_or")]

external xor
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_xor") (arm64, "caml_neon_int32x4_bitwise_xor")]

external cvtsx_i64
  :  t
  -> int64x2#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_cvtsx_int32x4_int64x2") (arm64, "caml_neon_cvtsx_int32x4_to_int64x2")]

external cvtzx_i64
  :  t
  -> int64x2#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse41_cvtzx_int32x4_int64x2") (arm64, "caml_neon_cvtzx_int32x4_to_int64x2")]

external cvt_su16
  :  t
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_cvt_int32x4_int16x8_saturating_unsigned"
[@@noalloc] [@@builtin amd64]

external cvt_f32
  :  t
  -> float32x4#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_cvt_int32x4_float32x4") (arm64, "caml_neon_cvt_int32x4_to_float32x4")]

external const1
  :  int32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int32x4_const1"
[@@noalloc] [@@builtin]

(* Not implemented on arm64. *)
module Sse = struct
  external sll
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int32x4_sll"]

  external srl
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int32x4_srl"]

  external sra
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int32x4_sra"]

  external andnot
    :  not:t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse_vec128_andnot"]

  external cvt_si16
    :  t
    -> t
    -> int16x8#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_cvt_int32x4_int16x8_saturating"]

  external cvt_f64
    :  t
    -> float64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_cvt_int32x4_float64x2"]
end

(* Not implemented on amd64. *)
module Neon = struct
  external cvt_i16_low
    :  t
    -> int16x8#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int32x4_to_int16x8_low"]

  external cvt_i16_high
    :  int16x8#
    -> t
    -> int16x8#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int32x4_to_int16x8_high"]

  external cvt_si16_low
    :  t
    -> int16x8#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int32x4_to_int16x8_low_saturating"]

  external cvt_si16_high
    :  int16x8#
    -> t
    -> int16x8#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int32x4_to_int16x8_high_saturating"]

  external shift
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int32x4_sshl"]

  external shift_logical
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int32x4_ushl"]

  external broadcast
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int32x4_dup"]
end

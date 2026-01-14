type t = int16x16#

module I16x8 = struct
  type t = int16x8#

  external low_of
    :  int16#
    -> t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int16x8_low_of_int16"
  [@@noalloc] [@@builtin]

  external low_to
    :  t
    -> int16#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int16x8_low_to_int16"
  [@@noalloc] [@@builtin]

  external cvtsx_i32
    :  t
    -> int32x8#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtsx_int16x8_int32x8"
  [@@noalloc] [@@builtin]

  external cvtzx_i32
    :  t
    -> int32x8#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int16x8_int32x8"
  [@@noalloc] [@@builtin]

  external cvtsx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtsx_int16x8_int64x4"
  [@@noalloc] [@@builtin]

  external cvtzx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int16x8_int64x4"
  [@@noalloc] [@@builtin]
end

external low_of
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_low_of_int16"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> int16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_low_to_int16"
[@@noalloc] [@@builtin]

external low_of_i16x8
  :  int16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_of_vec128"
[@@noalloc] [@@builtin]

external low_to_i16x8
  :  t
  -> int16x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_to_vec128"
[@@noalloc] [@@builtin]

external const1
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_const1"
[@@noalloc] [@@builtin]

external broadcast_16
  :  int16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec256_broadcast_16"
[@@noalloc] [@@builtin]

external blend_32
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_32"
[@@noalloc] [@@builtin]

external and_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_and"
[@@noalloc] [@@builtin]

external andnot
  :  not:t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_andnot"
[@@noalloc] [@@builtin]

external or_ : t -> t -> t @@ portable = "ocaml_simd_avx_unreachable" "caml_avx_vec256_or"
[@@noalloc] [@@builtin]

external xor
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_xor"
[@@noalloc] [@@builtin]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_cmpeq"
[@@noalloc] [@@builtin]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_cmpgt"
[@@noalloc] [@@builtin]

external interleave_high_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_interleave_high_16"
[@@noalloc] [@@builtin]

external interleave_low_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_interleave_low_16"
[@@noalloc] [@@builtin]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_max"
[@@noalloc] [@@builtin]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_min"
[@@noalloc] [@@builtin]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_max_unsigned"
[@@noalloc] [@@builtin]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_min_unsigned"
[@@noalloc] [@@builtin]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_add"
[@@noalloc] [@@builtin]

external add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_add_saturating"
[@@noalloc] [@@builtin]

external add_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_add_saturating_unsigned"
[@@noalloc] [@@builtin]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sub"
[@@noalloc] [@@builtin]

external sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sub_saturating"
[@@noalloc] [@@builtin]

external sub_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sub_saturating_unsigned"
[@@noalloc] [@@builtin]

external mul_sign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mulsign"
[@@noalloc] [@@builtin]

external abs : t -> t @@ portable = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_abs"
[@@noalloc] [@@builtin]

external avg_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_avg_unsigned"
[@@noalloc] [@@builtin]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hadd"
[@@noalloc] [@@builtin]

external horizontal_add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hadd_saturating"
[@@noalloc] [@@builtin]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hsub"
[@@noalloc] [@@builtin]

external horizontal_sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hsub_saturating"
[@@noalloc] [@@builtin]

external mul_high
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_high"
[@@noalloc] [@@builtin]

external mul_low
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_low"
[@@noalloc] [@@builtin]

external mul_high_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_high_unsigned"
[@@noalloc] [@@builtin]

external mul_horizontal_add
  :  t
  -> t
  -> int32x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_hadd_int32x8"
[@@noalloc] [@@builtin]

external mul_round
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_round"
[@@noalloc] [@@builtin]

external sll
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sll"
[@@noalloc] [@@builtin]

external srl
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_srl"
[@@noalloc] [@@builtin]

external sra
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sra"
[@@noalloc] [@@builtin]

external of_float16x16
  :  float16x16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin]

external of_float32x8
  :  float32x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin]

external of_float64x4
  :  float64x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin]

external of_int8x32
  :  int8x32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin]

external of_int32x8
  :  int32x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin]

external of_int64x4
  :  int64x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin]

external cvt_si8
  :  t
  -> t
  -> int8x32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_cvt_int16x16_int8x32_saturating"
[@@noalloc] [@@builtin]

external cvt_su8
  :  t
  -> t
  -> int8x32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_cvt_int16x16_int8x32_saturating_unsigned"
[@@noalloc] [@@builtin]

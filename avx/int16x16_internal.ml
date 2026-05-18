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
  [@@noalloc] [@@builtin amd64]

  external cvtzx_i32
    :  t
    -> int32x8#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int16x8_int32x8"
  [@@noalloc] [@@builtin amd64]

  external cvtsx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtsx_int16x8_int64x4"
  [@@noalloc] [@@builtin amd64]

  external cvtzx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int16x8_int64x4"
  [@@noalloc] [@@builtin amd64]
end

external low_of
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_low_of_int16"
[@@noalloc] [@@builtin amd64]

external low_to
  :  t
  -> int16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_low_to_int16"
[@@noalloc] [@@builtin amd64]

external low_of_i16x8
  :  int16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_of_vec128"
[@@noalloc] [@@builtin amd64]

external low_to_i16x8
  :  t
  -> int16x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_to_vec128"
[@@noalloc] [@@builtin amd64]

external const1
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_const1"
[@@noalloc] [@@builtin amd64]

external broadcast_16
  :  int16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec256_broadcast_16"
[@@noalloc] [@@builtin amd64]

external blend_32
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_32"
[@@noalloc] [@@builtin amd64]

external and_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_and"
[@@noalloc] [@@builtin amd64]

external andnot
  :  not:t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_andnot"
[@@noalloc] [@@builtin amd64]

external or_ : t -> t -> t @@ portable = "ocaml_simd_avx_unreachable" "caml_avx_vec256_or"
[@@noalloc] [@@builtin amd64]

external xor
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_xor"
[@@noalloc] [@@builtin amd64]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_cmpeq"
[@@noalloc] [@@builtin amd64]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_cmpgt"
[@@noalloc] [@@builtin amd64]

external interleave_high_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_interleave_high_16"
[@@noalloc] [@@builtin amd64]

external interleave_low_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_interleave_low_16"
[@@noalloc] [@@builtin amd64]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_max"
[@@noalloc] [@@builtin amd64]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_min"
[@@noalloc] [@@builtin amd64]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_max_unsigned"
[@@noalloc] [@@builtin amd64]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_min_unsigned"
[@@noalloc] [@@builtin amd64]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_add"
[@@noalloc] [@@builtin amd64]

external add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_add_saturating"
[@@noalloc] [@@builtin amd64]

external add_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_add_saturating_unsigned"
[@@noalloc] [@@builtin amd64]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sub"
[@@noalloc] [@@builtin amd64]

external sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sub_saturating"
[@@noalloc] [@@builtin amd64]

external sub_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sub_saturating_unsigned"
[@@noalloc] [@@builtin amd64]

external mul_sign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mulsign"
[@@noalloc] [@@builtin amd64]

external abs : t -> t @@ portable = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_abs"
[@@noalloc] [@@builtin amd64]

external avg_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_avg_unsigned"
[@@noalloc] [@@builtin amd64]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hadd"
[@@noalloc] [@@builtin amd64]

external horizontal_add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hadd_saturating"
[@@noalloc] [@@builtin amd64]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hsub"
[@@noalloc] [@@builtin amd64]

external horizontal_sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x8x2_hsub_saturating"
[@@noalloc] [@@builtin amd64]

external mul_high
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_high"
[@@noalloc] [@@builtin amd64]

external mul_low
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_low"
[@@noalloc] [@@builtin amd64]

external mul_high_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_high_unsigned"
[@@noalloc] [@@builtin amd64]

external mul_horizontal_add
  :  t
  -> t
  -> int32x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_hadd_int32x8"
[@@noalloc] [@@builtin amd64]

external mul_round
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_mul_round"
[@@noalloc] [@@builtin amd64]

external sll
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sll"
[@@noalloc] [@@builtin amd64]

external srl
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_srl"
[@@noalloc] [@@builtin amd64]

external sra
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_sra"
[@@noalloc] [@@builtin amd64]

external of_float16x16
  :  float16x16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin amd64]

external of_float32x8
  :  float32x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin amd64]

external of_float64x4
  :  float64x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin amd64]

external of_int8x32
  :  int8x32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin amd64]

external of_int32x8
  :  int32x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin amd64]

external of_int64x4
  :  int64x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_cast"
[@@noalloc] [@@builtin amd64]

external cvt_si8
  :  t
  -> t
  -> int8x32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_cvt_int16x16_int8x32_saturating"
[@@noalloc] [@@builtin amd64]

external cvt_su8
  :  t
  -> t
  -> int8x32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_cvt_int16x16_int8x32_saturating_unsigned"
[@@noalloc] [@@builtin amd64]

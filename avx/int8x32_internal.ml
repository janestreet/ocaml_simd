type t = int8x32#

module I8x16 = struct
  type t = int8x16#

  external low_of
    :  int8#
    -> t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int8x16_low_of_int8"
  [@@noalloc] [@@builtin]

  external low_to
    :  t
    -> int8#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int8x16_low_to_int8"
  [@@noalloc] [@@builtin]

  external cvtsx_i16
    :  t
    -> int16x16#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtsx_int8x16_int16x16"
  [@@noalloc] [@@builtin]

  external cvtzx_i16
    :  t
    -> int16x16#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int8x16_int16x16"
  [@@noalloc] [@@builtin]

  external cvtsx_i32
    :  t
    -> int32x8#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtsx_int8x16_int32x8"
  [@@noalloc] [@@builtin]

  external cvtzx_i32
    :  t
    -> int32x8#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int8x16_int32x8"
  [@@noalloc] [@@builtin]

  external cvtsx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtsx_int8x16_int64x4"
  [@@noalloc] [@@builtin]

  external cvtzx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int8x16_int64x4"
  [@@noalloc] [@@builtin]
end

external low_of
  :  int8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int8x32_low_of_int8"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> int8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int8x32_low_to_int8"
[@@noalloc] [@@builtin]

external low_of_i8x16
  :  int8x16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_of_vec128"
[@@noalloc] [@@builtin]

external low_to_i8x16
  :  t
  -> int8x16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_to_vec128"
[@@noalloc] [@@builtin]

external const1
  :  int8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int8x32_const1"
[@@noalloc] [@@builtin]

external shuffle_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shuffle_8"
[@@noalloc] [@@builtin]

external broadcast_8
  :  int8x16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec256_broadcast_8"
[@@noalloc] [@@builtin]

external blendv_8
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec256_blendv_8"
[@@noalloc] [@@builtin]

external blend_32
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_32"
[@@noalloc] [@@builtin]

external movemask_8
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec256_movemask_8"
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
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_cmpeq"
[@@noalloc] [@@builtin]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_cmpgt"
[@@noalloc] [@@builtin]

external interleave_high_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_interleave_high_8"
[@@noalloc] [@@builtin]

external interleave_low_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_interleave_low_8"
[@@noalloc] [@@builtin]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_max"
[@@noalloc] [@@builtin]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_min"
[@@noalloc] [@@builtin]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_max_unsigned"
[@@noalloc] [@@builtin]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_min_unsigned"
[@@noalloc] [@@builtin]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_add"
[@@noalloc] [@@builtin]

external add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_add_saturating"
[@@noalloc] [@@builtin]

external add_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_add_saturating_unsigned"
[@@noalloc] [@@builtin]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_sub"
[@@noalloc] [@@builtin]

external sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_sub_saturating"
[@@noalloc] [@@builtin]

external sub_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_sub_saturating_unsigned"
[@@noalloc] [@@builtin]

external mul_horizontal_add_saturating
  :  t
  -> t
  -> int16x16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_mul_unsigned_hadd_saturating_int16x16"
[@@noalloc] [@@builtin]

external mul_sign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_mulsign"
[@@noalloc] [@@builtin]

external abs : t -> t @@ portable = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_abs"
[@@noalloc] [@@builtin]

external avg_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_avg_unsigned"
[@@noalloc] [@@builtin]

external sadu
  :  t
  -> t
  -> int64x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x32_sad_unsigned"
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

external of_int16x16
  :  int16x16#
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

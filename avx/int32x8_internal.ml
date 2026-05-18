type t = int32x8#

module I32x4 = struct
  type t = int32x4#

  external low_of
    :  int32#
    -> t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int32x4_low_of_int32"
  [@@noalloc] [@@builtin]

  external low_to
    :  t
    -> int32#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int32x4_low_to_int32"
  [@@noalloc] [@@builtin]

  external cvt_f64
    :  t
    -> float64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_cvt_int32x4_float64x4"
  [@@noalloc] [@@builtin amd64]

  external cvtsx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtsx_int32x4_int64x4"
  [@@noalloc] [@@builtin amd64]

  external cvtzx_i64
    :  t
    -> int64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx2_cvtzx_int32x4_int64x4"
  [@@noalloc] [@@builtin amd64]
end

external low_of
  :  int32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int32x8_low_of_int32"
[@@noalloc] [@@builtin amd64]

external low_to
  :  t
  -> int32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int32x8_low_to_int32"
[@@noalloc] [@@builtin amd64]

external low_of_i32x4
  :  int32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_of_vec128"
[@@noalloc] [@@builtin amd64]

external low_to_i32x4
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_to_vec128"
[@@noalloc] [@@builtin amd64]

external const1
  :  int32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int32x8_const1"
[@@noalloc] [@@builtin amd64]

external broadcast_32
  :  int32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_broadcast_32"
[@@noalloc] [@@builtin amd64]

external movemask_32
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_movemask_32"
[@@noalloc] [@@builtin amd64]

external blendv_32
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blendv_32"
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
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_cmpeq"
[@@noalloc] [@@builtin amd64]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_cmpgt"
[@@noalloc] [@@builtin amd64]

external interleave_high_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_interleave_high_32"
[@@noalloc] [@@builtin amd64]

external interleave_low_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_interleave_low_32"
[@@noalloc] [@@builtin amd64]

external dup_even_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_dup_even_32"
[@@noalloc] [@@builtin amd64]

external dup_odd_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_dup_odd_32"
[@@noalloc] [@@builtin amd64]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_max"
[@@noalloc] [@@builtin amd64]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_min"
[@@noalloc] [@@builtin amd64]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_max_unsigned"
[@@noalloc] [@@builtin amd64]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_min_unsigned"
[@@noalloc] [@@builtin amd64]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_add"
[@@noalloc] [@@builtin amd64]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_sub"
[@@noalloc] [@@builtin amd64]

external mul_sign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_mulsign"
[@@noalloc] [@@builtin amd64]

external abs : t -> t @@ portable = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_abs"
[@@noalloc] [@@builtin amd64]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x4x2_hadd"
[@@noalloc] [@@builtin amd64]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x4x2_hsub"
[@@noalloc] [@@builtin amd64]

external mul_low
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_mul_low"
[@@noalloc] [@@builtin amd64]

external mul_even
  :  t
  -> t
  -> int64x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_mul_even"
[@@noalloc] [@@builtin amd64]

external mul_even_unsigned
  :  t
  -> t
  -> int64x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_mul_even_unsigned"
[@@noalloc] [@@builtin amd64]

external sll
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_sll"
[@@noalloc] [@@builtin amd64]

external srl
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_srl"
[@@noalloc] [@@builtin amd64]

external sra
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_sra"
[@@noalloc] [@@builtin amd64]

external sllv
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_sllv"
[@@noalloc] [@@builtin amd64]

external srlv
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_srlv"
[@@noalloc] [@@builtin amd64]

external srav
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_srav"
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

external of_int16x16
  :  int16x16#
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

external cvt_f32
  :  t
  -> float32x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_cvt_int32x8_float32x8"
[@@noalloc] [@@builtin amd64]

external cvt_si16
  :  t
  -> t
  -> int16x16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_cvt_int32x8_int16x16_saturating"
[@@noalloc] [@@builtin amd64]

external cvt_su16
  :  t
  -> t
  -> int16x16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_cvt_int32x8_int16x16_saturating_unsigned"
[@@noalloc] [@@builtin amd64]

type t = float64x4#

module F64x2 = struct
  type t = float64x2#

  external low_of
    :  float#
    -> t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_float64x2_low_of_float"
  [@@noalloc] [@@builtin]

  external low_to
    :  t
    -> float#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_float64x2_low_to_float"
  [@@noalloc] [@@builtin]
end

external low_of
  :  float#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float64x4_low_of_float"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> float#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float64x4_low_to_float"
[@@noalloc] [@@builtin]

external low_of_f64x2
  :  float64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_of_vec128"
[@@noalloc] [@@builtin]

external low_to_f64x2
  :  t
  -> float64x2#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_to_vec128"
[@@noalloc] [@@builtin]

external broadcast_64
  :  float64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_broadcast_64"
[@@noalloc] [@@builtin]

external cvt_f32
  :  t
  -> float32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_cvt_float64x4_float32x4"
[@@noalloc] [@@builtin]

external cvt_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_cvt_float64x4_int32x4"
[@@noalloc] [@@builtin]

external cvtt_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_cvtt_float64x4_int32x4"
[@@noalloc] [@@builtin]

external blendv_64
  :  t
  -> t
  -> int64x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blendv_64"
[@@noalloc] [@@builtin]

external cmp
  :  (Ocaml_simd.Float.Comparison.t[@untagged])
  -> t
  -> t
  -> int64x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_cmp"
[@@noalloc] [@@builtin]

external round
  :  (Ocaml_simd.Float.Rounding.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_round"
[@@noalloc] [@@builtin]

external interleave_high_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_interleave_high_64"
[@@noalloc] [@@builtin]

external interleave_low_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_interleave_low_64"
[@@noalloc] [@@builtin]

external dup_even_64
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_dup_even_64"
[@@noalloc] [@@builtin]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_min"
[@@noalloc] [@@builtin]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_max"
[@@noalloc] [@@builtin]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_add"
[@@noalloc] [@@builtin]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_sub"
[@@noalloc] [@@builtin]

external mul
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_mul"
[@@noalloc] [@@builtin]

external div
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_div"
[@@noalloc] [@@builtin]

external addsub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_addsub"
[@@noalloc] [@@builtin]

external hadd
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x2x2_hadd"
[@@noalloc] [@@builtin]

external hsub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x2x2_hsub"
[@@noalloc] [@@builtin]

external sqrt
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float64x4_sqrt"
[@@noalloc] [@@builtin]

external mul_add
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64x4_mul_add"
[@@noalloc] [@@builtin]

external mul_sub
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64x4_mul_sub"
[@@noalloc] [@@builtin]

external mul_add_sub
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64x4_mul_addsub"
[@@noalloc] [@@builtin]

external mul_sub_add
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64x4_mul_subadd"
[@@noalloc] [@@builtin]

external neg_mul_add
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64x4_neg_mul_add"
[@@noalloc] [@@builtin]

external neg_mul_sub
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float64x4_neg_mul_sub"
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

external of_int8x32
  :  int8x32#
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

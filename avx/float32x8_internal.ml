type t = float32x8#

module F32x4 = struct
  type t = float32x4#

  external low_of
    :  float32#
    -> t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_float32x4_low_of_float32"
  [@@noalloc] [@@builtin]

  external low_to
    :  t
    -> float32#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_float32x4_low_to_float32"
  [@@noalloc] [@@builtin]

  external cvt_f64
    :  t
    -> float64x4#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_cvt_float32x4_float64x4"
  [@@noalloc] [@@builtin]
end

external low_of
  :  float32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float32x8_low_of_float32"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> float32#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float32x8_low_to_float32"
[@@noalloc] [@@builtin]

external low_of_f32x4
  :  float32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_of_vec128"
[@@noalloc] [@@builtin]

external low_to_f32x4
  :  t
  -> float32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_to_vec128"
[@@noalloc] [@@builtin]

external broadcast_32
  :  float32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_broadcast_32"
[@@noalloc] [@@builtin]

external blendv_32
  :  t
  -> t
  -> int32x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blendv_32"
[@@noalloc] [@@builtin]

external cmp
  :  (Ocaml_simd.Float.Comparison.t[@untagged])
  -> t
  -> t
  -> int32x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_cmp"
[@@noalloc] [@@builtin]

external round
  :  (Ocaml_simd.Float.Rounding.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_round"
[@@noalloc] [@@builtin]

external interleave_high_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_interleave_high_32"
[@@noalloc] [@@builtin]

external interleave_low_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_interleave_low_32"
[@@noalloc] [@@builtin]

external dup_even_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_dup_even_32"
[@@noalloc] [@@builtin]

external dup_odd_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_dup_odd_32"
[@@noalloc] [@@builtin]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_min"
[@@noalloc] [@@builtin]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_max"
[@@noalloc] [@@builtin]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_add"
[@@noalloc] [@@builtin]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_sub"
[@@noalloc] [@@builtin]

external mul
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_mul"
[@@noalloc] [@@builtin]

external div
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_div"
[@@noalloc] [@@builtin]

external addsub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_addsub"
[@@noalloc] [@@builtin]

external hadd
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x4x2_hadd"
[@@noalloc] [@@builtin]

external hsub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x4x2_hsub"
[@@noalloc] [@@builtin]

external rcp : t -> t @@ portable = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_rcp"
[@@noalloc] [@@builtin]

external rsqrt
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_rsqrt"
[@@noalloc] [@@builtin]

external sqrt
  :  t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x8_sqrt"
[@@noalloc] [@@builtin]

external dp
  :  int64#
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_float32x4x2_dp"
[@@noalloc] [@@builtin]

external mul_add
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32x8_mul_add"
[@@noalloc] [@@builtin]

external mul_sub
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32x8_mul_sub"
[@@noalloc] [@@builtin]

external mul_add_sub
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32x8_mul_addsub"
[@@noalloc] [@@builtin]

external mul_sub_add
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32x8_mul_subadd"
[@@noalloc] [@@builtin]

external neg_mul_add
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32x8_neg_mul_add"
[@@noalloc] [@@builtin]

external neg_mul_sub
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_fma_float32x8_neg_mul_sub"
[@@noalloc] [@@builtin]

external of_float16x16
  :  float16x16#
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

external cvt_i32
  :  t
  -> int32x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_cvt_float32x8_int32x8"
[@@noalloc] [@@builtin]

external cvtt_i32
  :  t
  -> int32x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_cvtt_float32x8_int32x8"
[@@noalloc] [@@builtin]

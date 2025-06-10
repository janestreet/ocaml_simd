type t = int8x16#

external low_of
  :  (int[@untagged])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int8x16_low_of_int"
[@@noalloc] [@@builtin]

external low_to
  :  (t[@unboxed])
  -> (int[@untagged])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int8x16_low_to_int"
[@@noalloc] [@@builtin]

external const1
  :  (int[@untagged])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int8x16_const1"
[@@noalloc] [@@builtin]

external of_int16x8
  :  int16x8#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_int32x4
  :  int32x4#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_int64x2
  :  int64x2#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_float32x4
  :  float32x4#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_float64x2
  :  float64x2#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external add : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse2_int8x16_add"
[@@noalloc] [@@unboxed] [@@builtin]

external add_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_add_saturating"
[@@noalloc] [@@unboxed] [@@builtin]

external add_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_add_saturating_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external sub : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse2_int8x16_sub"
[@@noalloc] [@@unboxed] [@@builtin]

external sub_saturating
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_sub_saturating"
[@@noalloc] [@@unboxed] [@@builtin]

external sub_saturating_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_sub_saturating_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external mul_horizontal_add_saturating
  :  t
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_unreachable" "caml_ssse3_int8x16_mul_unsigned_hadd_saturating_int16x8"
[@@noalloc] [@@unboxed] [@@builtin]

external max : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse41_int8x16_max"
[@@noalloc] [@@unboxed] [@@builtin]

external min : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse41_int8x16_min"
[@@noalloc] [@@unboxed] [@@builtin]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_max_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_min_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_cmpeq"
[@@noalloc] [@@unboxed] [@@builtin]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_cmpgt"
[@@noalloc] [@@unboxed] [@@builtin]

external and_ : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse2_vec128_and"
[@@noalloc] [@@unboxed] [@@builtin]

external andnot
  :  not:t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_andnot"
[@@noalloc] [@@unboxed] [@@builtin]

external or_ : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse2_vec128_or"
[@@noalloc] [@@unboxed] [@@builtin]

external xor : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse2_vec128_xor"
[@@noalloc] [@@unboxed] [@@builtin]

external movemask_8
  :  (t[@unboxed])
  -> (int[@untagged])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_movemask_8"
[@@noalloc] [@@builtin]

external interleave_high_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_interleave_high_8"
[@@noalloc] [@@unboxed] [@@builtin]

external interleave_low_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_interleave_low_8"
[@@noalloc] [@@unboxed] [@@builtin]

external interleave_low_16
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_interleave_low_16"
[@@noalloc] [@@unboxed] [@@builtin]

external interleave_low_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse_vec128_interleave_low_32"
[@@noalloc] [@@unboxed] [@@builtin]

external interleave_low_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_interleave_low_64"
[@@noalloc] [@@unboxed] [@@builtin]

external abs : t -> t @@ portable = "ocaml_simd_unreachable" "caml_ssse3_int8x16_abs"
[@@noalloc] [@@unboxed] [@@builtin]

external mulsign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_ssse3_int8x16_mulsign"
[@@noalloc] [@@unboxed] [@@builtin]

external avg_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_avg_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external sadu
  :  t
  -> t
  -> int64x2#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int8x16_sad_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external shuffle_8
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_ssse3_vec128_shuffle_8"
[@@noalloc] [@@unboxed] [@@builtin]

external blendv_8
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blendv_8"
[@@noalloc] [@@unboxed] [@@builtin]

external cvtsx_i16
  :  t
  -> int16x8#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtsx_int8x16_int16x8"
[@@noalloc] [@@unboxed] [@@builtin]

external cvtzx_i16
  :  t
  -> int16x8#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtzx_int8x16_int16x8"
[@@noalloc] [@@unboxed] [@@builtin]

external cvtsx_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtsx_int8x16_int32x4"
[@@noalloc] [@@unboxed] [@@builtin]

external cvtzx_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtzx_int8x16_int32x4"
[@@noalloc] [@@unboxed] [@@builtin]

external cvtsx_i64
  :  t
  -> int64x2#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtsx_int8x16_int64x2"
[@@noalloc] [@@unboxed] [@@builtin]

external cvtzx_i64
  :  t
  -> int64x2#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtzx_int8x16_int64x2"
[@@noalloc] [@@unboxed] [@@builtin]

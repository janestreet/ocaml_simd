type t = int32x4#

external low_of
  :  int32#
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int32x4_low_of_int32"
[@@noalloc] [@@builtin]

external low_to
  :  (t[@unboxed])
  -> int32#
  @@ portable
  = "ocaml_simd_unreachable" "caml_int32x4_low_to_int32"
[@@noalloc] [@@builtin]

external of_int8x16
  :  int8x16#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_int16x8
  :  int16x8#
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

external const1
  :  int32#
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int32x4_const1"
[@@noalloc] [@@builtin]

external movemask_32
  :  (t[@unboxed])
  -> (int[@untagged])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse_vec128_movemask_32"
[@@noalloc] [@@builtin]

external add : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse2_int32x4_add"
[@@noalloc] [@@unboxed] [@@builtin]

external sub : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse2_int32x4_sub"
[@@noalloc] [@@unboxed] [@@builtin]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_cmpeq"
[@@noalloc] [@@unboxed] [@@builtin]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_cmpgt"
[@@noalloc] [@@unboxed] [@@builtin]

external sll
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_sll"
[@@noalloc] [@@unboxed] [@@builtin]

external srl
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_srl"
[@@noalloc] [@@unboxed] [@@builtin]

external sra
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int32x4_sra"
[@@noalloc] [@@unboxed] [@@builtin]

external abs : t -> t @@ portable = "ocaml_simd_unreachable" "caml_ssse3_int32x4_abs"
[@@noalloc] [@@unboxed] [@@builtin]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_ssse3_int32x4_hadd"
[@@noalloc] [@@unboxed] [@@builtin]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_ssse3_int32x4_hsub"
[@@noalloc] [@@unboxed] [@@builtin]

external mulsign
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_ssse3_int32x4_mulsign"
[@@noalloc] [@@unboxed] [@@builtin]

external max : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse41_int32x4_max"
[@@noalloc] [@@unboxed] [@@builtin]

external max_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int32x4_max_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external min : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse41_int32x4_min"
[@@noalloc] [@@unboxed] [@@builtin]

external min_unsigned
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int32x4_min_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external mul_low
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int32x4_mul_low"
[@@noalloc] [@@unboxed] [@@builtin]

external interleave_high_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse_vec128_interleave_high_32"
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

external blendv_32
  :  t
  -> t
  -> int32x4#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blendv_32"
[@@noalloc] [@@unboxed] [@@builtin]

external dup_odd_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse3_vec128_dup_odd_32"
[@@noalloc] [@@unboxed] [@@builtin]

external dup_even_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse3_vec128_dup_even_32"
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

external cvtsx_i64
  :  t
  -> int64x2#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtsx_int32x4_int64x2"
[@@noalloc] [@@unboxed] [@@builtin]

external cvtzx_i64
  :  t
  -> int64x2#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_cvtzx_int32x4_int64x2"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_si16
  :  t
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_cvt_int32x4_int16x8_saturating"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_su16
  :  t
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_cvt_int32x4_int16x8_saturating_unsigned"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_f32
  :  t
  -> float32x4#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_cvt_int32x4_float32x4"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_f64
  :  t
  -> float64x2#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_cvt_int32x4_float64x2"
[@@noalloc] [@@unboxed] [@@builtin]

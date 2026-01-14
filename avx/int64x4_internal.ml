type t = int64x4#

module I64x2 = struct
  type t = int64x2#

  external low_of
    :  int64#
    -> t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int64x2_low_of_int64"
  [@@noalloc] [@@builtin]

  external low_to
    :  t
    -> int64#
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_int64x2_low_to_int64"
  [@@noalloc] [@@builtin]
end

external low_of
  :  int64#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int64x4_low_of_int64"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int64x4_low_to_int64"
[@@noalloc] [@@builtin]

external low_of_i64x2
  :  int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_of_vec128"
[@@noalloc] [@@builtin]

external low_to_i64x2
  :  t
  -> int64x2#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_vec256_low_to_vec128"
[@@noalloc] [@@builtin]

external const1
  :  int64#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int64x4_const1"
[@@noalloc] [@@builtin]

external broadcast_64
  :  int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_broadcast_64"
[@@noalloc] [@@builtin]

external movemask_64
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_movemask_64"
[@@noalloc] [@@builtin]

external blendv_64
  :  t
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blendv_64"
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
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_cmpeq"
[@@noalloc] [@@builtin]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_cmpgt"
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

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_add"
[@@noalloc] [@@builtin]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_sub"
[@@noalloc] [@@builtin]

external sll
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_sll"
[@@noalloc] [@@builtin]

external srl
  :  t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_srl"
[@@noalloc] [@@builtin]

external sllv
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_sllv"
[@@noalloc] [@@builtin]

external srlv
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_srlv"
[@@noalloc] [@@builtin]

external slli
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_slli"
[@@noalloc] [@@builtin]

external srli
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_srli"
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

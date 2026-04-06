type t = int64x2#

external low_of
  :  int64#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int64x2_low_of_int64"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int64x2_low_to_int64"
[@@noalloc] [@@builtin]

external insert
  :  idx:int64#
  -> t
  -> int64#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int64x2_insert") (arm64, "caml_neon_int64x2_insert")]

external extract
  :  idx:int64#
  -> t
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int64x2_extract") (arm64, "caml_neon_int64x2_extract")]

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

external of_int32x4
  :  int32x4#
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

external const1
  :  int64#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int64x2_const1"
[@@noalloc] [@@builtin]

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int64x2_add") (arm64, "caml_neon_int64x2_add")]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc] [@@builtin (amd64, "caml_sse2_int64x2_sub") (arm64, "caml_neon_int64x2_sub")]

external cmpeq
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse41_int64x2_cmpeq") (arm64, "caml_neon_int64x2_cmpeq")]

external cmpgt
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse42_int64x2_cmpgt") (arm64, "caml_neon_int64x2_cmpgt")]

external and_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_and") (arm64, "caml_neon_int64x2_bitwise_and")]

external or_
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_or") (arm64, "caml_neon_int64x2_bitwise_or")]

external xor
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_vec128_xor") (arm64, "caml_neon_int64x2_bitwise_xor")]

external slli
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int64x2_slli") (arm64, "caml_neon_int64x2_slli")]

external srli
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int64x2_srli") (arm64, "caml_neon_int64x2_srli")]

external high_64_to_low_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse_vec128_high_64_to_low_64")
    (arm64, "caml_neon_vec128_high_64_to_low_64")]

external low_64_to_high_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse_vec128_low_64_to_high_64")
    (arm64, "caml_neon_vec128_low_64_to_high_64")]

external interleave_low_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_low_64") (arm64, "caml_neon_float64x2_zip1")]

external interleave_high_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_high_64") (arm64, "caml_neon_float64x2_zip2")]

external blendv_64
  :  t
  -> t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blendv_64"
[@@noalloc] [@@builtin amd64]

external dup_low_64
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse3_vec128_dup_low_64") (arm64, "caml_neon_int64x2_dup")]

external movemask_64
  :  t
  -> int64#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_movemask_64"
[@@noalloc] [@@builtin amd64]

(* Not implemented on arm64. *)
module Sse = struct
  external andnot
    :  not:t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse_vec128_andnot"]

  external sll
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int64x2_sll"]

  external srl
    :  t
    -> int64x2#
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_int64x2_srl"]
end

(* Not implemented on amd64. *)
module Neon = struct
  external shift
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int64x2_sshl"]

  external shift_logical
    :  t
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int64x2_ushl"]

  external cvt_i32_saturating
    :  t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int64x2_to_int32x4_low_saturating"]

  external cvt_f64
    :  t
    -> float64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_int64x2_to_float64x2"]
end

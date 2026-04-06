type t = float64x2#

external low_of
  :  float#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_float64x2_low_of_float"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> float#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_float64x2_low_to_float"
[@@noalloc] [@@builtin]

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

external of_int64x2
  :  int64x2#
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

external add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_float64x2_add") (arm64, "caml_neon_float64x2_add")]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_float64x2_sub") (arm64, "caml_neon_float64x2_sub")]

external mul
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_float64x2_mul") (arm64, "caml_neon_float64x2_mul")]

external div
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_float64x2_div") (arm64, "caml_neon_float64x2_div")]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_float64x2_max") (arm64, "caml_neon_float64x2_max")]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_float64x2_min") (arm64, "caml_neon_float64x2_min")]

external sqrt
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_float64x2_sqrt") (arm64, "caml_neon_float64x2_sqrt")]

external addsub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_float64x2_addsub"
[@@noalloc] [@@builtin amd64]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse3_float64x2_hadd") (arm64, "caml_neon_float64x2_hadd")]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_float64x2_hsub"
[@@noalloc] [@@builtin amd64]

external dp
  :  int64#
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_float64x2_dp"
[@@noalloc] [@@builtin amd64]

external blendv_64
  :  t
  -> t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blendv_64"
[@@noalloc] [@@builtin amd64]

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

external dup_low_64
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse3_vec128_dup_low_64") (arm64, "caml_neon_int64x2_dup")]

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

external cvt_f32
  :  t
  -> float32x4#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_cvt_float64x2_float32x2")
    (arm64, "caml_neon_cvt_float64x2_to_float32x2")]

(* Not implemented on arm64. *)
module Sse = struct
  external cmp
    :  (Ocaml_simd.Float.Comparison.t[@untagged])
    -> t
    -> t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_float64x2_cmp"]

  external round
    :  (Ocaml_simd.Float.Rounding.t[@untagged])
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_float64x2_round"]

  external cvt_i32
    :  t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_cvt_float64x2_int32x2"]

  external cvtt_i32
    :  t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse2_cvtt_float64x2_int32x2"]
end

(* Not implemented on amd64 *)
module Neon = struct
  external cmpeq
    :  t
    -> t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_cmeq"]

  external cmpge
    :  t
    -> t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_cmge"]

  external cmpgt
    :  t
    -> t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_cmgt"]

  external cmple
    :  t
    -> t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_cmle"]

  external cmplt
    :  t
    -> t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_cmlt"]

  external round_current
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_round_current"]

  external round_near
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_round_near"]

  external round_neg_inf
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_round_neg_inf"]

  external round_pos_inf
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_round_pos_inf"]

  external round_towards_zero
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float64x2_round_towards_zero"]

  external cvt_i64
    :  t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvt_float64x2_to_int64x2"]

  external cvtt_i64
    :  t
    -> int64x2#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_cvtt_float64x2_to_int64x2"]
end

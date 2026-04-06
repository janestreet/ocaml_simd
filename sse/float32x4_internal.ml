type t = float32x4#

external low_of
  :  float32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_float32x4_low_of_float32"
[@@noalloc] [@@builtin]

external low_to
  :  t
  -> float32#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_float32x4_low_to_float32"
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

external of_float64x2
  :  float64x2#
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
[@@builtin (amd64, "caml_sse_float32x4_add") (arm64, "caml_neon_float32x4_add")]

external sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_sub") (arm64, "caml_neon_float32x4_sub")]

external mul
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_mul") (arm64, "caml_neon_float32x4_mul")]

external div
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_div") (arm64, "caml_neon_float32x4_div")]

external max
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_max") (arm64, "caml_neon_float32x4_max")]

external min
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_min") (arm64, "caml_neon_float32x4_min")]

external rcp
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_rcp") (arm64, "caml_neon_float32x4_rcp")]

external rsqrt
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_rsqrt") (arm64, "caml_neon_float32x4_rsqrt")]

external sqrt
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse_float32x4_sqrt") (arm64, "caml_neon_float32x4_sqrt")]

external cvt_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_cvt_float32x4_int32x4") (arm64, "caml_neon_cvt_float32x4_to_int32x4")]

external cvtt_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_cvtt_float32x4_int32x4")
    (arm64, "caml_neon_cvtt_float32x4_to_int32x4")]

external cvt_f64
  :  t
  -> float64x2#
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_cvt_float32x4_float64x2")
    (arm64, "caml_neon_cvt_float32x2_to_float64x2")]

external addsub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_float32x4_addsub"
[@@noalloc] [@@builtin amd64]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse3_float32x4_hadd") (arm64, "caml_neon_float32x4_hadd")]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_float32x4_hsub"
[@@noalloc] [@@builtin amd64]

external dp
  :  int64#
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_float32x4_dp"
[@@noalloc] [@@builtin amd64]

external interleave_low_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse_vec128_interleave_low_32") (arm64, "caml_neon_float32x4_zip1")]

external interleave_high_32
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse_vec128_interleave_high_32") (arm64, "caml_neon_float32x4_zip2")]

external interleave_low_64
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_interleave_low_64") (arm64, "caml_neon_float64x2_zip1")]

external blendv_32
  :  t
  -> t
  -> int32x4#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blendv_32"
[@@noalloc] [@@builtin amd64]

external dup_odd_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_vec128_dup_odd_32"
[@@noalloc] [@@builtin amd64]

external dup_even_32
  :  t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse3_vec128_dup_even_32"
[@@noalloc] [@@builtin amd64]

external const1
  :  float32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_float32x4_const1"
[@@noalloc] [@@builtin]

(* Not implemented on arm64. *)
module Sse = struct
  external round
    :  (Ocaml_simd.Float.Rounding.t[@untagged])
    -> t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse41_float32x4_round"]

  external cmp
    :  (Ocaml_simd.Float.Comparison.t[@untagged])
    -> t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin amd64, "caml_sse_float32x4_cmp"]
end

(* Not implemented on amd64 *)
module Neon = struct
  external broadcast
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_int32x4_dup"]

  external round_current
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_round_current"]

  external round_near
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_round_near"]

  external round_neg_inf
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_round_neg_inf"]

  external round_pos_inf
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_round_pos_inf"]

  external round_towards_zero
    :  t
    -> t
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_round_towards_zero"]

  external cmpeq
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_cmeq"]

  external cmpge
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_cmge"]

  external cmpgt
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_cmgt"]

  external cmple
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_cmle"]

  external cmplt
    :  t
    -> t
    -> int32x4#
    @@ portable
    = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
  [@@noalloc] [@@builtin arm64, "caml_neon_float32x4_cmlt"]
end

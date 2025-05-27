type t = float64x2#

external low_of
  :  float#
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_float64x2_low_of_float"
[@@noalloc] [@@builtin]

external low_to
  :  (t[@unboxed])
  -> float#
  = "ocaml_simd_unreachable" "caml_float64x2_low_to_float"
[@@noalloc] [@@builtin]

external of_int8x16 : int8x16# -> t = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_int16x8 : int16x8# -> t = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_int32x4 : int32x4# -> t = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_int64x2 : int64x2# -> t = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external of_float32x4 : float32x4# -> t = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external cmp
  :  (Float_ctrl.Compare.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (int64x2#[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_float64x2_cmp"
[@@noalloc] [@@builtin]

external add : t -> t -> t = "ocaml_simd_unreachable" "caml_sse2_float64x2_add"
[@@noalloc] [@@unboxed] [@@builtin]

external sub : t -> t -> t = "ocaml_simd_unreachable" "caml_sse2_float64x2_sub"
[@@noalloc] [@@unboxed] [@@builtin]

external mul : t -> t -> t = "ocaml_simd_unreachable" "caml_sse2_float64x2_mul"
[@@noalloc] [@@unboxed] [@@builtin]

external div : t -> t -> t = "ocaml_simd_unreachable" "caml_sse2_float64x2_div"
[@@noalloc] [@@unboxed] [@@builtin]

external max : t -> t -> t = "ocaml_simd_unreachable" "caml_sse2_float64x2_max"
[@@noalloc] [@@unboxed] [@@builtin]

external min : t -> t -> t = "ocaml_simd_unreachable" "caml_sse2_float64x2_min"
[@@noalloc] [@@unboxed] [@@builtin]

external sqrt : t -> t = "ocaml_simd_unreachable" "caml_sse2_float64x2_sqrt"
[@@noalloc] [@@unboxed] [@@builtin]

external addsub : t -> t -> t = "ocaml_simd_unreachable" "caml_sse3_float64x2_addsub"
[@@noalloc] [@@unboxed] [@@builtin]

external horizontal_add
  :  t
  -> t
  -> t
  = "ocaml_simd_unreachable" "caml_sse3_float64x2_hadd"
[@@noalloc] [@@unboxed] [@@builtin]

external horizontal_sub
  :  t
  -> t
  -> t
  = "ocaml_simd_unreachable" "caml_sse3_float64x2_hsub"
[@@noalloc] [@@unboxed] [@@builtin]

external dp
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse41_float64x2_dp"
[@@noalloc] [@@builtin]

external round
  :  (Float_ctrl.Round.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse41_float64x2_round"
[@@noalloc] [@@builtin]

external blendv_64
  :  t
  -> t
  -> int64x2#
  -> t
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blendv_64"
[@@noalloc] [@@unboxed] [@@builtin]

external high_64_to_low_64
  :  t
  -> t
  -> t
  = "ocaml_simd_unreachable" "caml_sse_vec128_high_64_to_low_64"
[@@noalloc] [@@unboxed] [@@builtin]

external low_64_to_high_64
  :  t
  -> t
  -> t
  = "ocaml_simd_unreachable" "caml_sse_vec128_low_64_to_high_64"
[@@noalloc] [@@unboxed] [@@builtin]

external dup_low_64 : t -> t = "ocaml_simd_unreachable" "caml_sse3_vec128_dup_low_64"
[@@noalloc] [@@unboxed] [@@builtin]

external interleave_high_64
  :  t
  -> t
  -> t
  = "ocaml_simd_unreachable" "caml_sse2_vec128_interleave_high_64"
[@@noalloc] [@@unboxed] [@@builtin]

external interleave_low_64
  :  t
  -> t
  -> t
  = "ocaml_simd_unreachable" "caml_sse2_vec128_interleave_low_64"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_f32
  :  t
  -> float32x4#
  = "ocaml_simd_unreachable" "caml_sse2_cvt_float64x2_float32x4"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_i32
  :  t
  -> int32x4#
  = "ocaml_simd_unreachable" "caml_sse2_cvt_float64x2_int32x4"
[@@noalloc] [@@unboxed] [@@builtin]

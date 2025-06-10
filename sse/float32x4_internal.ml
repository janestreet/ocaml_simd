type t = float32x4#

external low_of
  :  float32#
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_float32x4_low_of_float32"
[@@noalloc] [@@builtin]

external low_to
  :  (t[@unboxed])
  -> float32#
  @@ portable
  = "ocaml_simd_unreachable" "caml_float32x4_low_to_float32"
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

external of_float64x2
  :  float64x2#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_vec128_cast"
[@@noalloc] [@@unboxed] [@@builtin]

external cmp
  :  (Float_ctrl.Compare.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (int32x4#[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse_float32x4_cmp"
[@@noalloc] [@@builtin]

external add : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_add"
[@@noalloc] [@@unboxed] [@@builtin]

external sub : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_sub"
[@@noalloc] [@@unboxed] [@@builtin]

external mul : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_mul"
[@@noalloc] [@@unboxed] [@@builtin]

external div : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_div"
[@@noalloc] [@@unboxed] [@@builtin]

external max : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_max"
[@@noalloc] [@@unboxed] [@@builtin]

external min : t -> t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_min"
[@@noalloc] [@@unboxed] [@@builtin]

external rcp : t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_rcp"
[@@noalloc] [@@unboxed] [@@builtin]

external rsqrt : t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_rsqrt"
[@@noalloc] [@@unboxed] [@@builtin]

external sqrt : t -> t @@ portable = "ocaml_simd_unreachable" "caml_sse_float32x4_sqrt"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_i32
  :  t
  -> int32x4#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_cvt_float32x4_int32x4"
[@@noalloc] [@@unboxed] [@@builtin]

external cvt_f64
  :  t
  -> float64x2#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_cvt_float32x4_float64x2"
[@@noalloc] [@@unboxed] [@@builtin]

external addsub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse3_float32x4_addsub"
[@@noalloc] [@@unboxed] [@@builtin]

external horizontal_add
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse3_float32x4_hadd"
[@@noalloc] [@@unboxed] [@@builtin]

external horizontal_sub
  :  t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse3_float32x4_hsub"
[@@noalloc] [@@unboxed] [@@builtin]

external dp
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_float32x4_dp"
[@@noalloc] [@@builtin]

external round
  :  (Float_ctrl.Round.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_float32x4_round"
[@@noalloc] [@@builtin]

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

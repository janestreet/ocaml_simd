@@ portable

type t = float16x8#

val box : t -> float16x8
val unbox : float16x8 @ local -> t

(* Load/Store *)

module Raw = Load_store.Raw_Float16x8
module String = Load_store.String_Float16x8
module Bytes = Load_store.Bytes_Float16x8
module Bigstring = Load_store.Bigstring_Float16x8

(* Utility *)

(** [_mm_unpackhi_epi16] *)
val interleave_upper : even:t -> odd:t -> t

(** [_mm_unpacklo_epi16] *)
val interleave_lower : even:t -> odd:t -> t

(** [_mm_blend_epi16] Specify blend with ppx_simd: [%blend N, N, N, N, N, N, N, N], where
    each N is in [0,1]. Exposed as an external so user code can compile without
    cross-library inlining. *)
external blend
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_16"
[@@noalloc] [@@builtin]

(** [_mm_shufflehi_epi16] Specify shuffle with ppx_simd: [%shuffle N, N, N, N], where each
    N is in [0,3]. Exposed as an external so user code can compile without cross-library
    inlining. *)
external shuffle_upper
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_high_16"
[@@noalloc] [@@builtin]

(** [_mm_shufflelo_epi16] Specify shuffle with ppx_simd: [%shuffle N, N, N, N], where each
    N is in [0,3]. Exposed as an external so user code can compile without cross-library
    inlining. *)
external shuffle_lower
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_low_16"
[@@noalloc] [@@builtin]

(* Casts *)

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x4_bits : float32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float64x2_bits : float64x2# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int8x16_bits : int8x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int16x8_bits : int16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int32x4_bits : int32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x2_bits : int64x2# -> t

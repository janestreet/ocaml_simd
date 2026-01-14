@@ portable

type t = float16x16#

val box : t -> float16x16
val unbox : float16x16 @ local -> t

(* Creation *)

(** [_mm256_set_m128] Operates on two float16x8 lanes. *)
val set_lanes : float16x8# -> float16x8# -> t

(* Load/Store *)

module Raw = Load_store.Raw_Float16x16
module String = Load_store.String_Float16x16
module Bytes = Load_store.Bytes_Float16x16
module Bigstring = Load_store.Bigstring_Float16x16

(* Utility *)

(** [idx] must be a literal in [0,1]. Operates on two float16x8 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external insert_lane
  :  idx:int64#
  -> t
  -> float16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

(** [idx] must be a literal in [0,1]. Operates on two float16x8 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external extract_lane
  :  idx:int64#
  -> t
  -> float16x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

(** Projection. Has no runtime cost. Operates on two float16x8 lanes. *)
val extract_lane0 : t -> float16x8#

(** [_mm256_unpackhi_epi16] Operates on two float16x8 lanes.
    {[
      interleave_upper_lanes ~even ~odd
      = ( even.(4)
        , odd.(4)
        , even.(5)
        , odd.(5)
        , even.(6)
        , odd.(6)
        , even.(7)
        , odd.(7)
        , even.(12)
        , odd.(12)
        , even.(13)
        , odd.(13)
        , even.(14)
        , odd.(14)
        , even.(15)
        , odd.(15) )
    ]} *)
val interleave_upper_lanes : even:t -> odd:t -> t

(** [_mm256_unpacklo_epi16] Operates on two float16x8 lanes.
    {[
      interleave_lower_lanes ~even ~odd
      = ( even.(0)
        , odd.(0)
        , even.(1)
        , odd.(1)
        , even.(2)
        , odd.(2)
        , even.(3)
        , odd.(3)
        , even.(8)
        , odd.(8)
        , even.(9)
        , odd.(9)
        , even.(10)
        , odd.(10)
        , even.(11)
        , odd.(11) )
    ]} *)
val interleave_lower_lanes : even:t -> odd:t -> t

(** [_mm256_blend_epi16] Specify blend with ppx_simd: [%blend N, N, N, N, N, N, N, N],
    where each N is in [0,1]. Operates on two float16x8 lanes. Exposed as an external so
    user code can compile without cross-library inlining.

    {[
      blend_lanes [%blend 1, 0, 1, 0, 1, 0, 1, 0] x y
      = ( y.(0)
        , x.(1)
        , y.(2)
        , x.(3)
        , y.(4)
        , x.(5)
        , y.(6)
        , x.(7)
        , y.(8)
        , x.(9)
        , y.(10)
        , x.(11)
        , y.(12)
        , x.(13)
        , y.(14)
        , x.(15) )
    ]} *)
external blend_lanes
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_blend_16"
[@@noalloc] [@@builtin]

(** [_mm256_shufflehi_epi16] Specify shuffle with ppx_simd: [%shuffle N, N, N, N], where
    each N is in [0,3]. Operates on two float16x8 lanes. Exposed as an external so user
    code can compile without cross-library inlining.

    {[
      shuffle_upper_lanes [%shuffle 1, 0, 3, 2] x
      = ( x.(0)
        , x.(1)
        , x.(2)
        , x.(3)
        , x.(5)
        , x.(4)
        , x.(7)
        , x.(6)
        , x.(8)
        , x.(9)
        , x.(10)
        , x.(11)
        , x.(13)
        , x.(12)
        , x.(15)
        , x.(14) )
    ]} *)
external shuffle_upper_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shuffle_high_16"
[@@noalloc] [@@builtin]

(** [_mm256_shufflelo_epi16] Specify shuffle with ppx_simd: [%shuffle N, N, N, N], where
    each N is in [0,3]. Operates on two float16x8 lanes. Exposed as an external so user
    code can compile without cross-library inlining.

    {[
      shuffle_lower_lanes [%shuffle 1, 0, 3, 2] x
      = ( x.(1)
        , x.(0)
        , x.(3)
        , x.(2)
        , x.(4)
        , x.(5)
        , x.(6)
        , x.(7)
        , x.(9)
        , x.(8)
        , x.(11)
        , x.(10)
        , x.(12)
        , x.(13)
        , x.(14)
        , x.(15) )
    ]} *)
external shuffle_lower_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shuffle_low_16"
[@@noalloc] [@@builtin]

(* Casts *)

(** Identity; leaves upper 128 bits unspecified. *)
val unsafe_of_float16x8 : float16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x8_bits : float32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float64x4_bits : float64x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int8x32_bits : int8x32# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int16x16_bits : int16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int32x8_bits : int32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x4_bits : int64x4# -> t

@@ portable

type t = int16x16#
type mask = int16x16#

val box : t -> int16x16
val unbox : int16x16 @ local -> t

(* Creation *)

(** Equivalent to [const1 0]. *)
val zero : unit -> t

(** Equivalent to [const1 1]. *)
val one : unit -> t

(** [_mm256_set1_epi16] *)
val set1 : int16# -> t

(** [_mm256_set_epi16] *)
val set
  :  int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> t

(** [_mm256_set_m128] Operates on two int16x8 lanes. *)
val set_lanes : int16x8# -> int16x8# -> t

(** Argument must be an unsigned 16-bit int literal. Compiles to a static vector literal.
    Exposed as an external so user code can compile without cross-library inlining. *)
external const1 : int16# -> t = "ocaml_simd_avx_unreachable" "caml_int16x16_const1"
[@@noalloc] [@@builtin]

(** Arguments must be unsigned 16-bit int literals. Compiles to a static vector literal.
    Exposed as an external so user code can compile without cross-library inlining. *)
external const
  :  int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> t
  = "ocaml_simd_avx_unreachable" "caml_int16x16_const16"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int16x16
module String = Load_store.String_Int16x16
module Bytes = Load_store.Bytes_Int16x16
module Bigstring = Load_store.Bigstring_Int16x16

(* Control Flow *)

module Test : Test.S with type t := t

(** Compiles to cmpgt,cmpeq,orpd. *)
val ( >= ) : t -> t -> mask

(** Compiles to cmpgt,cmpeq,orpd. *)
val ( <= ) : t -> t -> mask

(** [_mm256_cmpeq_epi16] *)
val ( = ) : t -> t -> mask

(** [_mm256_cmpgt_epi16] *)
val ( > ) : t -> t -> mask

(** [_mm256_cmpgt_epi16] with flipped arguments. *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd. *)
val ( <> ) : t -> t -> mask

(** [_mm256_cmpeq_epi16] *)
val equal : t -> t -> mask

(* Utility *)

(** [idx] must be in [0,15]. *)
val insert : idx:int64# -> t -> int16# -> t

(** [idx] must be in [0,15]. *)
val extract : idx:int64# -> t -> int16#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int16#

(** [idx] must be a literal in [0,1]. Operates on two int16x8 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external insert_lane
  :  idx:int64#
  -> t
  -> int16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

(** [idx] must be a literal in [0,1]. Operates on two int16x8 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external extract_lane
  :  idx:int64#
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

(** Projection. Has no runtime cost. Operates on two int16x8 lanes. *)
val extract_lane0 : t -> int16x8#

(** Slow, intended for debugging / printing / etc. *)
val splat
  :  t
  -> #(int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#
      * int16#)

(** [_mm256_unpackhi_epi16] Operates on two int16x8 lanes.
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

(** [_mm256_unpacklo_epi16] Operates on two int16x8 lanes.
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
    where each N is in [0,1]. Operates on two int16x8 lanes. Exposed as an external so
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
    each N is in [0,3]. Operates on two int16x8 lanes. Exposed as an external so user code
    can compile without cross-library inlining.

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
    each N is in [0,3]. Operates on two int16x8 lanes. Exposed as an external so user code
    can compile without cross-library inlining.

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

(* Math *)

(** [_mm256_min_epi16] *)
val min : t -> t -> t

(** [_mm256_max_epi16] *)
val max : t -> t -> t

(** [_mm256_min_epu16] *)
val min_unsigned : t -> t -> t

(** [_mm256_max_epu16] *)
val max_unsigned : t -> t -> t

(** [_mm256_add_epi16] *)
val add : t -> t -> t

(** [_mm256_adds_epi16] *)
val add_saturating : t -> t -> t

(** [_mm256_adds_epu16] *)
val add_saturating_unsigned : t -> t -> t

(** [_mm256_sub_epi16] *)
val sub : t -> t -> t

(** [_mm256_subs_epi16] *)
val sub_saturating : t -> t -> t

(** [_mm256_subs_epu16] *)
val sub_saturating_unsigned : t -> t -> t

(** [_mm256_sign_epi16] with -1. *)
val neg : t -> t

(** [_mm256_abs_epi16] Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

(** [_mm256_sll_epi16] *)
val shift_left_logical : t -> int64# -> t

(** [_mm256_sll_epi16] *)
val shift_right_logical : t -> int64# -> t

(** [_mm256_sll_epi16] *)
val shift_right_arithmetic : t -> int64# -> t

(** [_mm256_bslli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int16x8 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_left_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_left_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_bsrli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int16x8 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_right_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_right_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_slli_epi16] First argument must be an unsigned integer literal in [0,15].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_left_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_slli"
[@@noalloc] [@@builtin]

(** [_mm256_srli_epi16] First argument must be an unsigned integer literal in [0,15].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_right_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_srli"
[@@noalloc] [@@builtin]

(** [_mm256_srai_epi16] First argument must be an unsigned integer literal in [0,15].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_srai"
[@@noalloc] [@@builtin]

(** [_mm256_hadd_epi16] Operates on two int16x8 lanes. *)
val horizontal_add_lanes : t -> t -> t

(** [_mm256_hadds_epi16] Operates on two int16x8 lanes. *)
val horizontal_add_saturating_lanes : t -> t -> t

(** [_mm256_hsub_epi16] Operates on two int16x8 lanes. *)
val horizontal_sub_lanes : t -> t -> t

(** [_mm256_hsubs_epi16] Operates on two int16x8 lanes. *)
val horizontal_sub_saturating_lanes : t -> t -> t

(** [_mm256_sign_epi16] *)
val mul_sign : t -> t -> t

(** [_mm256_avg_epu16] *)
val average_unsigned : t -> t -> t

(** [_mm256_mullo_epi16] *)
val mul_low_bits : t -> t -> t

(** [_mm256_mulhi_epi16] *)
val mul_high_bits : t -> t -> t

(** [_mm256_mulhi_epu16] *)
val mul_high_bits_unsigned : t -> t -> t

(** [_mm256_madd_epi16] *)
val mul_horizontal_add : t -> t -> int32x8#

(** [_mm256_mulhrs_epi16] *)
val mul_round : t -> t -> t

(* Operators *)

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t

(** Compiles to xor with a static constant. *)
val lnot : t -> t

(** [_mm256_or_si256] *)
val ( lor ) : t -> t -> t

(** [_mm256_and_si256] *)
val ( land ) : t -> t -> t

(** [_mm256_andnot_si256] *)
val landnot : not:t -> t -> t

(** [_mm256_xor_si256] *)
val ( lxor ) : t -> t -> t

(* Casts *)

(** Identity; leaves upper 128 bits unspecified. *)
val unsafe_of_int16x8 : int16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float16x16_bits : float16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x8_bits : float32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float64x4_bits : float64x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int8x32_bits : int8x32# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int32x8_bits : int32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x4_bits : int64x4# -> t

(** [_mm256_cvtepi8_epi16] *)
val of_int8x16 : int8x16# -> t

(** [_mm256_cvtepu8_epi16] *)
val of_int8x16_unsigned : int8x16# -> t

(** [_mm256_packs_epi32] Operates on two int16x8 lanes. *)
val of_int32x8_saturating_lanes : int32x8# -> int32x8# -> t

(** [_mm256_packus_epi32] Clamps signed input to [0..0xffff]. Operates on two int16x8
    lanes. *)
val of_int32x8_saturating_unsigned_lanes : int32x8# -> int32x8# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

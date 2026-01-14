@@ portable

type t = int8x32#
type mask = int8x32#

val box : t -> int8x32
val unbox : int8x32 @ local -> t

(* Creation *)

(** Equivalent to [const1 0]. *)
val zero : unit -> t

(** Equivalent to [const1 1]. *)
val one : unit -> t

(** [_mm256_set1_epi8] *)
val set1 : int8# -> t

(** [_mm256_set_epi8] *)
val set
  :  int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> t

(** [_mm256_set_m128] Operates on two int8x16 lanes. *)
val set_lanes : int8x16# -> int8x16# -> t

(** Argument must be an unsigned 8-bit int literal. Compiles to a static vector literal.
    Exposed as an external so user code can compile without cross-library inlining. *)
external const1 : int8# -> t = "ocaml_simd_avx_unreachable" "caml_int8x32_const1"
[@@noalloc] [@@builtin]

(** Arguments must be unsigned 8-bit int literals. Compiles to a static vector literal.
    Exposed as an external so user code can compile without cross-library inlining. *)
external const
  :  int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> t
  = "ocaml_simd_avx_unreachable" "caml_int8x32_const32"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int8x32
module String = Load_store.String_Int8x32
module Bytes = Load_store.Bytes_Int8x32
module Bigstring = Load_store.Bigstring_Int8x32

(* Control Flow *)

module Test : Test.S with type t := t

(** Compiles to cmpgt,cmpeq,orpd *)
val ( >= ) : t -> t -> mask

(** Compiles to cmpgt,cmpeq,orpd *)
val ( <= ) : t -> t -> mask

(** [_mm256_cmpeq_epi8] *)
val ( = ) : t -> t -> mask

(** [_mm256_cmpgt_epi8] *)
val ( > ) : t -> t -> mask

(** [_mm256_cmpgt_epi8] with flipped arguments. *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd *)
val ( <> ) : t -> t -> mask

(** [_mm256_cmpeq_epi8] *)
val equal : t -> t -> mask

(** [_mm256_movemask_epi8] *)
val movemask : mask -> int64#

(** [_mm256_blendv_epi8] Only reads the sign bit of each mask lane. Selects the element
    from [pass] if the sign bit is 1, otherwise [fail].

    There is no static blend; use this for all blend needs. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,31]. *)
val insert : idx:int64# -> t -> int8# -> t

(** [idx] must be in [0,31]. *)
val extract : idx:int64# -> t -> int8#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int8#

(** [idx] must be a literal in [0,1]. Operates on two int8x16 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external insert_lane
  :  idx:int64#
  -> t
  -> int8x16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

(** [idx] must be a literal in [0,1]. Operates on two int8x16 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external extract_lane
  :  idx:int64#
  -> t
  -> int8x16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

(** Projection. Has no runtime cost. Operates on two int8x16 lanes. *)
val extract_lane0 : t -> int8x16#

(** Slow, intended for debugging / printing / etc. *)
val splat
  :  t
  -> #(int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#
      * int8#)

(** [_mm256_unpackhi_epi8] Operates on two int8x16 lanes.
    {[
      interleave_upper_lanes ~even ~odd
      = ( even.(8)
        , odd.(8)
        , even.(9)
        , odd.(9)
        , even.(10)
        , odd.(10)
        , even.(11)
        , odd.(11)
        , even.(12)
        , odd.(12)
        , even.(13)
        , odd.(13)
        , even.(14)
        , odd.(14)
        , even.(15)
        , odd.(15)
        , even.(24)
        , odd.(24)
        , even.(25)
        , odd.(25)
        , even.(26)
        , odd.(26)
        , even.(27)
        , odd.(27)
        , even.(28)
        , odd.(28)
        , even.(29)
        , odd.(29)
        , even.(30)
        , odd.(30)
        , even.(31)
        , odd.(31) )
    ]} *)
val interleave_upper_lanes : even:t -> odd:t -> t

(** [_mm256_unpacklo_epi8] Operates on two int8x16 lanes.
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
        , even.(4)
        , odd.(4)
        , even.(5)
        , odd.(5)
        , even.(6)
        , odd.(6)
        , even.(7)
        , odd.(7)
        , even.(16)
        , odd.(16)
        , even.(17)
        , odd.(17)
        , even.(18)
        , odd.(18)
        , even.(19)
        , odd.(19)
        , even.(20)
        , odd.(20)
        , even.(21)
        , odd.(21)
        , even.(22)
        , odd.(22)
        , even.(23)
        , odd.(23) )
    ]} *)
val interleave_lower_lanes : even:t -> odd:t -> t

(** [_mm256_shuffle_epi8] Operates on two int8x16 lanes. *)
val shuffle_lanes : pattern:t -> t -> t

(** [_mm256_alignr_epi8] First argument must be an 8-bit unsigned integer literal.
    Operates on two int8x16 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external concat_shift_right_bytes_lanes
  :  int64#
  -> t
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_align_right_bytes"
[@@noalloc] [@@builtin]

(* Math *)

(** [_mm256_min_epi8] *)
val min : t -> t -> t

(** [_mm256_max_epi8] *)
val max : t -> t -> t

(** [_mm256_min_epu8] *)
val min_unsigned : t -> t -> t

(** [_mm256_max_epu8] *)
val max_unsigned : t -> t -> t

(** [_mm256_add_epi8] *)
val add : t -> t -> t

(** [_mm256_adds_epi8] *)
val add_saturating : t -> t -> t

(** [_mm256_adds_epu8] *)
val add_saturating_unsigned : t -> t -> t

(** [_mm256_sub_epi8] *)
val sub : t -> t -> t

(** [_mm256_subs_epi8] *)
val sub_saturating : t -> t -> t

(** [_mm256_subs_epu8] *)
val sub_saturating_unsigned : t -> t -> t

(** [_mm256_sign_epi8] with -1. *)
val neg : t -> t

(** [_mm256_abs_epi8] Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

(** [_mm256_bslli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int8x16 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_left_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_left_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_bsrli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int8x16 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_right_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_right_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_sign_epi8] *)
val mul_sign : t -> t -> t

(** [_mm256_avg_epu8] *)
val average_unsigned : t -> t -> t

(** [_mm256_sad_epu8] *)
val sum_absolute_differences_unsigned : t -> t -> int64x4#

(** [_mm256_mpsadbw_epu8] First argument must be an unsigned 3-bit integer literal.
    Operates on two int8x16 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external multi_sum_absolute_differences_unsigned_lanes
  :  int64#
  -> t
  -> t
  -> int16x16#
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x16x2_multi_sad_unsigned"
[@@noalloc] [@@builtin]

(** [_mm256_maddubs_epi16] *)
val mul_unsigned_by_signed_horizontal_add_saturating : t -> t -> int16x16#

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
val unsafe_of_int8x16 : int8x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float16x16_bits : float16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x8_bits : float32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float64x4_bits : float64x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int16x16_bits : int16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int32x8_bits : int32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x4_bits : int64x4# -> t

(** [_mm256_packs_epi16] Operates on two int8x16 lanes. *)
val of_int16x16_saturating_lanes : int16x16# -> int16x16# -> t

(** [_mm256_packus_epi16] Clamps signed input to [0..0xff]. Operates on two int8x16 lanes. *)
val of_int16x16_saturating_unsigned_lanes : int16x16# -> int16x16# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

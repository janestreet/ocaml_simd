@@ portable

type t = int32x8#
type mask = int32x8#

val box : t -> int32x8
val unbox : int32x8 @ local -> t

(* Creation *)

(** Equivalent to [const1 #0l]. *)
val zero : unit -> t

(** Equivalent to [const1 #1l]. *)
val one : unit -> t

(** [_mm256_set1_epi32] *)
val set1 : int32# -> t

(** [_mm256_set_epi32] *)
val set
  :  int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> t

(** [_mm256_set_m128] Operates on two int32x4 lanes. *)
val set_lanes : int32x4# -> int32x4# -> t

(** Argument must be a literal or an unboxing function applied to a literal. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const1 : int32# -> t = "ocaml_simd_avx_unreachable" "caml_int32x8_const1"
[@@noalloc] [@@builtin]

(** Arguments must be literals or unboxing functions applied to literals. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const
  :  int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> t
  = "ocaml_simd_avx_unreachable" "caml_int32x8_const8"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int32x8
module String = Load_store.String_Int32x8
module Bytes = Load_store.Bytes_Int32x8
module Bigstring = Load_store.Bigstring_Int32x8
module Int32_u_array = Load_store.Int32_u_array

(* Control Flow *)

module Test : Test.S with type t := t

(** Compiles to cmpgt,cmpeq,orpd *)
val ( >= ) : t -> t -> mask

(** Compiles to cmpgt,cmpeq,orpd *)
val ( <= ) : t -> t -> mask

(** [_mm256_cmpeq_epi32] *)
val ( = ) : t -> t -> mask

(** [_mm256_cmpgt_epi32] *)
val ( > ) : t -> t -> mask

(** [_mm256_cmpgt_epi32] with flipped arguments. *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd *)
val ( <> ) : t -> t -> mask

(** [_mm256_cmpeq_epi32] *)
val equal : t -> t -> mask

(** [_mm256_movemask_ps] *)
val movemask : mask -> int64#

(** [_mm256_blendv_ps] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail]. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,7]. *)
val insert : idx:int64# -> t -> int32# -> t

(** [idx] must be in [0,7]. *)
val extract : idx:int64# -> t -> int32#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int32#

(** [idx] must be a literal in [0,1]. Operates on two int32x4 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external insert_lane
  :  idx:int64#
  -> t
  -> int32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

(** [idx] must be a literal in [0,1]. Operates on two int32x4 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external extract_lane
  :  idx:int64#
  -> t
  -> int32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

(** Projection. Has no runtime cost. Operates on two int32x4 lanes. *)
val extract_lane0 : t -> int32x4#

(** Slow, intended for debugging / printing / etc. *)
val splat : t -> #(int32# * int32# * int32# * int32# * int32# * int32# * int32# * int32#)

(** [_mm256_unpackhi_ps] Operates on two int32x4 lanes.
    {[
      interleave_upper_lanes ~even ~odd
      = (even.(2), odd.(2), even.(3), odd.(3), even.(6), odd.(6), even.(7), odd.(7))
    ]} *)
val interleave_upper_lanes : even:t -> odd:t -> t

(** [_mm256_unpacklo_ps] Operates on two int32x4 lanes.
    {[
      interleave_lower_lanes ~even ~odd
      = (even.(0), odd.(0), even.(1), odd.(1), even.(4), odd.(4), even.(5), odd.(5))
    ]} *)
val interleave_lower_lanes : even:t -> odd:t -> t

(** [_mm256_moveldup_ps]
    {[
      duplicate_even x = (x.(0), x.(0), x.(2), x.(2), x.(4), x.(4), x.(6), x.(6))
    ]} *)
val duplicate_even : t -> t

(** [_mm256_movehdup_ps]
    {[
      duplicate_odd x = (x.(1), x.(1), x.(3), x.(3), x.(5), x.(5), x.(7), x.(7))
    ]} *)
val duplicate_odd : t -> t

(** [_mm256_blend_ps] Specify blend with ppx_simd: [%blend N, N, N, N, N, N, N, N], where
    each N is in [0,1]. Exposed as an external so user code can compile without
    cross-library inlining.
    {[
      blend [%blend 1, 0, 1, 0, 1, 0, 1, 0] x y
      = (y.(0), x.(1), y.(2), x.(3), y.(4), x.(5), y.(6), x.(7))
    ]} *)
external blend
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_32"
[@@noalloc] [@@builtin]

(** [_mm256_shuffle_ps] Specify shuffle with ppx_simd: [%shuffle N, N, N, N], where each N
    is in [0,3]. Operates on two int32x4 lanes. Exposed as an external so user code can
    compile without cross-library inlining.
    {[
      shuffle_lanes [%shuffle 1, 0, 3, 2] x y
      = (x.(1), x.(0), y.(3), y.(2), x.(5), x.(4), y.(7), y.(6))
    ]} *)
external shuffle_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_shuffle_32"
[@@noalloc] [@@builtin]

(** [_mm256_permute_ps] Specify permute with ppx_simd: [%permute N, N, N, N], where each N
    is in [0,3]. Operates on two int32x4 lanes. Exposed as an external so user code can
    compile without cross-library inlining.
    {[
      permute_lanes [%permute 3, 2, 1, 0] x
      = (x.(3), x.(2), x.(1), x.(0), x.(7), x.(6), x.(5), x.(4))
    ]} *)
external permute_lanes
  :  (Ocaml_simd.Permute4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_permute_32"
[@@noalloc] [@@builtin]

(* Math *)

(** [_mm256_min_epi32] *)
val min : t -> t -> t

(** [_mm256_max_epi32] *)
val max : t -> t -> t

(** [_mm256_min_epu32] *)
val min_unsigned : t -> t -> t

(** [_mm256_max_epu32] *)
val max_unsigned : t -> t -> t

(** [_mm256_add_epi32] *)
val add : t -> t -> t

(** [_mm256_sub_epi32] *)
val sub : t -> t -> t

(** [_mm256_sign_epi32] with -1. *)
val neg : t -> t

(** [_mm256_abs_epi32] Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

(** [_mm256_sll_epi32] *)
val shift_left_logical : t -> int64# -> t

(** [_mm256_srl_epi32] *)
val shift_right_logical : t -> int64# -> t

(** [_mm256_sra_epi32] *)
val shift_right_arithmetic : t -> int64# -> t

(** [_mm256_sllv_epi32] *)
val shift_left_logical_by : t -> shift:t -> t

(** [_mm256_srlv_epi32] *)
val shift_right_logical_by : t -> shift:t -> t

(** [_mm256_srav_epi32] *)
val shift_right_arithmetic_by : t -> shift:t -> t

(** [_mm256_bslli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int32x4 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_left_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_left_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_bsrli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int32x4 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_right_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_right_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_slli_epi32] First argument must be an unsigned integer literal in [0,31].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_left_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_slli"
[@@noalloc] [@@builtin]

(** [_mm256_srli_epi32] First argument must be an unsigned integer literal in [0,31].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_right_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_srli"
[@@noalloc] [@@builtin]

(** [_mm256_srai_epi32] First argument must be an unsigned integer literal in [0,31].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_srai"
[@@noalloc] [@@builtin]

(** [_mm256_hadd_epi32] *)
val horizontal_add_lanes : t -> t -> t

(** [_mm256_hsub_epi32] *)
val horizontal_sub_lanes : t -> t -> t

(** [_mm256_sign_epi32] *)
val mul_sign : t -> t -> t

(** [_mm256_mullo_epi32] *)
val mul_low_bits : t -> t -> t

(** [_mm256_mul_epi32] *)
val mul_even : t -> t -> int64x4#

(** [_mm256_mul_epu32] *)
val mul_even_unsigned : t -> t -> int64x4#

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
val unsafe_of_int32x4 : int32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float16x16_bits : float16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x8_bits : float32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float64x4_bits : float64x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int8x32_bits : int8x32# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int16x16_bits : int16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x4_bits : int64x4# -> t

(** [_mm256_cvtps_epi32] *)
val of_float32x8 : float32x8# -> t

(** [_mm256_cvttps_epi32] *)
val of_float32x8_trunc : float32x8# -> t

(** [_mm256_cvtepi8_epi32] *)
val of_int8x16 : int8x16# -> t

(** [_mm256_cvtepu8_epi32] *)
val of_int8x16_unsigned : int8x16# -> t

(** [_mm256_cvtepi16_epi32] *)
val of_int16x8 : int16x8# -> t

(** [_mm256_cvtepu16_epi32] *)
val of_int16x8_unsigned : int16x8# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

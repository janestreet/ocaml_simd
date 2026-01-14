@@ portable

type t = float64x4#
type mask = int64x4#

val box : t -> float64x4
val unbox : float64x4 @ local -> t

(* Creation *)

(** Equivalent to [const1 #0.0]. *)
val zero : unit -> t

(** Equivalent to [const1 #1.0]. *)
val one : unit -> t

(** [_mm256_set1_pd] *)
val set1 : float# -> t

(** [_mm256_set_pd] *)
val set : float# -> float# -> float# -> float# -> t

(** [_mm256_set_m128] Operates on two float64x2 lanes. *)
val set_lanes : float64x2# -> float64x2# -> t

(** Argument must be a literal or an unboxing function applied to a literal. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const1 : float# -> t = "ocaml_simd_avx_unreachable" "caml_float64x4_const1"
[@@noalloc] [@@builtin]

(** Arguments must be literals or unboxing functions applied to literals. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const
  :  float#
  -> float#
  -> float#
  -> float#
  -> t
  = "ocaml_simd_avx_unreachable" "caml_float64x4_const4"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Float64x4
module String = Load_store.String_Float64x4
module Bytes = Load_store.Bytes_Float64x4
module Bigstring = Load_store.Bigstring_Float64x4
module Float_array = Load_store.Float_array
module Float_iarray = Load_store.Float_iarray
module Floatarray = Load_store.Floatarray
module Float_u_array = Load_store.Float_u_array

(* Control Flow *)

(** [_mm256_cmp_pd] with [_CMP_LE_OS] *)
val ( >= ) : t -> t -> mask

(** [_mm256_cmp_pd] with [_CMP_LE_OS] *)
val ( <= ) : t -> t -> mask

(** [_mm256_cmp_pd] with [_CMP_EQ_OQ] *)
val ( = ) : t -> t -> mask

(** [_mm256_cmp_pd] with [_CMP_LT_OS] *)
val ( > ) : t -> t -> mask

(** [_mm256_cmp_pd] with [_CMP_LT_OS] *)
val ( < ) : t -> t -> mask

(** [_mm256_cmp_pd] with [_CMP_NEQ_UQ] *)
val ( <> ) : t -> t -> mask

(** [_mm256_cmp_pd] with [_CMP_EQ_OQ] *)
val equal : t -> t -> mask

(** [_mm256_cmp_pd] with [_CMP_UNORD_Q] *)
val is_nan : t -> mask

(** [_mm256_cmp_pd] with [_CMP_ORD_Q] *)
val is_not_nan : t -> mask

(** [_mm256_movemask_pd] *)
val movemask : mask -> int64#

(** Identity. *)
val bitmask : mask -> int64x4#

(** [_mm256_blendv_pd] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail]. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,3]. *)
val insert : idx:int64# -> t -> float# -> t

(** [idx] must be in [0,3]. *)
val extract : idx:int64# -> t -> float#

(** Projection. Has no runtime cost. *)
val extract0 : t -> float#

(** [idx] must be a literal in [0,1]. Operates on two float64x2 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external insert_lane
  :  idx:int64#
  -> t
  -> float64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

(** [idx] must be a literal in [0,1]. Operates on two float64x2 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external extract_lane
  :  idx:int64#
  -> t
  -> float64x2#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

(** Projection. Has no runtime cost. Operates on two float64x2 lanes. *)
val extract_lane0 : t -> float64x2#

(** Slow, intended for debugging / printing / etc. *)
val splat : t -> #(float# * float# * float# * float#)

(** [_mm256_unpackhi_pd] Operates on two float64x2 lanes.
    {[
      interleave_upper_lanes ~even ~odd = (even.(1), odd.(1), even.(3), odd.(3))
    ]} *)
val interleave_upper_lanes : even:t -> odd:t -> t

(** [_mm256_unpacklo_pd] Operates on two float64x2 lanes.
    {[
      interleave_lower_lanes ~even ~odd = (even.(0), odd.(0), even.(2), odd.(2))
    ]} *)
val interleave_lower_lanes : even:t -> odd:t -> t

(** [_mm256_movedup_pd]
    {[
      duplicate_even x = (x.(0), x.(0), x.(2), x.(2))
    ]} *)
val duplicate_even : t -> t

(** [_mm256_blend_pd] Specify blend with ppx_simd: [%blend N, N, N, N], where each N is in
    [0,1]. Exposed as an external so user code can compile without cross-library inlining.
    {[
      blend [%blend 1, 0, 1, 0] x y = (y.(0), x.(1), y.(2), x.(3))
    ]} *)
external blend
  :  (Ocaml_simd.Blend4.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_64"
[@@noalloc] [@@builtin]

(** [_mm256_shuffle_pd] Specify shuffle with ppx_simd: [%shuffle (N, N), (N, N)], where
    each N is in [0,1]. Operates on two float64x2 lanes. Exposed as an external so user
    code can compile without cross-library inlining.
    {[
      shuffle_lanes [%shuffle (1, 0), (0, 1)] x y = (x.(1), y.(0), x.(2), y.(3))
    ]} *)
external shuffle_lanes
  :  (Ocaml_simd.Shuffle2x2.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_shuffle_64"
[@@noalloc] [@@builtin]

(** [_mm256_permute4x64_pd] Specify permute with ppx_simd: [%permute N, N, N, N], where
    each N is in [0,3]. Exposed as an external so user code can compile without
    cross-library inlining.
    {[
      permute [%permute 3, 1, 0, 2] x = (x.(3), x.(1), x.(0), x.(2))
    ]} *)
external permute
  :  (Ocaml_simd.Permute4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec256_permute_64"
[@@noalloc] [@@builtin]

(** [_mm256_permute_pd] Specify permute with ppx_simd: [%permute (N, N), (N, N)], where
    each N is in [0,1]. Exposed as an external so user code can compile without
    cross-library inlining.
    {[
      permute_lanes [%permute (1, 0), (0, 1)] x = (x.(1), x.(0), x.(2), x.(3))
    ]} *)
external permute_lanes
  :  (Ocaml_simd.Permute2x2.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_permute_64"
[@@noalloc] [@@builtin]

(** [_mm256_permutevar_pd] Operates on two float64x2 lanes. Each lane of [idx] is
    interpreted as an integer in [0,1] by taking its *second* lowest bit.
    {[
      permute_lanes_by x ~idx:(2, 0, 0, 2) = (x.(1), x.(0), x.(2), x.(3))
    ]} *)
val permute_lanes_by : t -> idx:int64x4# -> t

(* Math *)

(** [_mm256_min_pd] Equivalent to pointwise (x < y ? x : y). If either lane is NaN, the
    second lane is returned. *)
val min : t -> t -> t

(** [_mm256_max_pd] Equivalent to pointwise (x > y ? x : y). If either lane is NaN, the
    second lane is returned. *)
val max : t -> t -> t

(** [_mm256_add_pd] *)
val add : t -> t -> t

(** [_mm256_sub_pd] *)
val sub : t -> t -> t

(** [_mm256_mul_pd] *)
val mul : t -> t -> t

(** [_mm256_div_pd] *)
val div : t -> t -> t

(** Compiles to xor with a static constant. *)
val neg : t -> t

(** Compiles to and with a static constant. *)
val abs : t -> t

(** [_mm256_sqrt_pd] *)
val sqrt : t -> t

(** [_mm256_addsub_pd]
    {[
      add_sub x y = (x.(0) - y.(0), x.(1) + y.(1), x.(2) - y.(2), x.(3) + y.(3))
    ]} *)
val add_sub : t -> t -> t

(** [_mm256_hadd_pd] Operates on two float64x2 lanes.
    {[
      horizontal_add_lanes x y
      = (x.(1) + x.(0), x.(3) + x.(2), y.(1) + y.(0), y.(3) + y.(2))
    ]} *)
val horizontal_add_lanes : t -> t -> t

(** [_mm256_hsub_pd] Operates on two float64x2 lanes.
    {[
      horizontal_sub_lanes x y
      = (x.(0) - x.(1), x.(2) - x.(3), y.(0) - y.(1), y.(2) - y.(3))
    ]} *)
val horizontal_sub_lanes : t -> t -> t

(** [_mm256_fmadd_pd]. Computes [x * y + z] without intermediate rounding. *)
val mul_add : t -> t -> t -> t

(** [_mm256_fmsub_pd]. Computes [x * y - z] without intermediate rounding. *)
val mul_sub : t -> t -> t -> t

(** [_mm256_fnmadd_pd]. Computes [-(x * y) + z] without intermediate rounding. *)
val neg_mul_add : t -> t -> t -> t

(** [_mm256_fnmsub_pd]. Computes [-(x * y) - z] without intermediate rounding. *)
val neg_mul_sub : t -> t -> t -> t

(** [_mm256_fmaddsub_ps]. Computes the following expression without intermediate rounding.
    {[
      mul_add_sub x y z
      = ( (x.(0) * y.(0)) - z.(0)
        , (x.(1) * y.(1)) + z.(1)
        , (x.(2) * y.(2)) - z.(2)
        , (x.(3) * y.(3)) + z.(3) )
    ]} *)
val mul_add_sub : t -> t -> t -> t

(** [_mm256_fmsubadd_ps]. Computes the following expression without intermediate rounding.
    {[
      mul_add_sub x y z
      = ( (x.(0) * y.(0)) + z.(0)
        , (x.(1) * y.(1)) - z.(1)
        , (x.(2) * y.(2)) + z.(2)
        , (x.(3) * y.(3)) - z.(3) )
    ]} *)
val mul_sub_add : t -> t -> t -> t

(* Operators *)

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t
val ( / ) : t -> t -> t
val ( * ) : t -> t -> t

(* Rounding *)

(** [_mm256_cvtpd_epi32] *)
val iround_current : t -> int32x4#

(** [_mm256_round_pd] *)
val round_nearest : t -> t

(** [_mm256_round_pd] *)
val round_current : t -> t

(** [_mm256_round_pd] *)
val round_down : t -> t

(** [_mm256_round_pd] *)
val round_up : t -> t

(** [_mm256_round_pd] *)
val round_toward_zero : t -> t

(* Casts *)

(** Identity; leaves upper 192 bits unspecified. *)
val unsafe_of_float : float# -> t

(** Identity; leaves upper 128 bits unspecified. *)
val unsafe_of_float64x2 : float64x2# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float16x16_bits : float16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x8_bits : float32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int8x32_bits : int8x32# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int16x16_bits : int16x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int32x8_bits : int32x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x4_bits : int64x4# -> t

(** [_mm256_cvtps_pd]. Performs numeric conversion from float32# to float64# *)
val of_float32x4 : float32x4# -> t

(** [_mm256_cvtepi32_pd]. Performs numeric conversion from int32# to float64# *)
val of_int32x4 : int32x4# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

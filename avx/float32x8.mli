@@ portable

type t = float32x8#
type mask = int32x8#

val box : t -> float32x8
val unbox : float32x8 @ local -> t

(* Creation *)

(** Equivalent to [const1 #0.0s]. *)
val zero : unit -> t

(** Equivalent to [const1 #1.0s]. *)
val one : unit -> t

(** [_mm256_set1_ps] *)
val set1 : float32# -> t

(** [_mm256_set_ps] *)
val set
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> t

(** [_mm256_set_m128] Operates on two float32x4 lanes. *)
val set_lanes : float32x4# -> float32x4# -> t

(** Argument must be a float literal. Compiles to a static vector literal. Exposed as an
    external so user code can compile without cross-library inlining. *)
external const1 : float32# -> t = "ocaml_simd_avx_unreachable" "caml_float32x8_const1"
[@@noalloc] [@@builtin]

(** Arguments must be float literals. Compiles to a static vector literal. Exposed as an
    external so user code can compile without cross-library inlining. *)
external const
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> t
  = "ocaml_simd_avx_unreachable" "caml_float32x8_const8"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Float32x8
module String = Load_store.String_Float32x8
module Bytes = Load_store.Bytes_Float32x8
module Bigstring = Load_store.Bigstring_Float32x8
module Float32_u_array = Load_store.Float32_u_array

(* Control Flow *)

(** [_mm256_cmp_ps] with [_CMP_LE_OS] *)
val ( >= ) : t -> t -> mask

(** [_mm256_cmp_ps] with [_CMP_LE_OS] *)
val ( <= ) : t -> t -> mask

(** [_mm256_cmp_ps] with [_CMP_EQ_OQ] *)
val ( = ) : t -> t -> mask

(** [_mm256_cmp_ps] with [_CMP_LT_OS] *)
val ( > ) : t -> t -> mask

(** [_mm256_cmp_ps] with [_CMP_LT_OS] *)
val ( < ) : t -> t -> mask

(** [_mm256_cmp_ps] with [_CMP_NEQ_UQ] *)
val ( <> ) : t -> t -> mask

(** [_mm256_cmp_ps] with [_CMP_EQ_OQ] *)
val equal : t -> t -> mask

(** [_mm256_cmp_ps] with [_CMP_UNORD_Q] *)
val is_nan : t -> mask

(** [_mm256_cmp_ps] with [_CMP_ORD_Q] *)
val is_not_nan : t -> mask

(** [_mm256_movemask_ps] *)
val movemask : mask -> int64#

(** Identity. *)
val bitmask : mask -> int32x8#

(** [_mm256_blendv_ps] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail]. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,7]. *)
val insert : idx:int64# -> t -> float32# -> t

(** [idx] must be in [0,7]. *)
val extract : idx:int64# -> t -> float32#

(** Projection. Has no runtime cost. *)
val extract0 : t -> float32#

(** [idx] must be a literal in [0,1]. Operates on two float32x4 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external insert_lane
  :  idx:int64#
  -> t
  -> float32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

(** [idx] must be a literal in [0,1]. Operates on two float32x4 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external extract_lane
  :  idx:int64#
  -> t
  -> float32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

(** Projection. Has no runtime cost. Operates on two float32x4 lanes. *)
val extract_lane0 : t -> float32x4#

(** Slow, intended for debugging / printing / etc. *)
val splat
  :  t
  -> #(float32#
      * float32#
      * float32#
      * float32#
      * float32#
      * float32#
      * float32#
      * float32#)

(** [_mm256_unpackhi_ps] Operates on two float32x4 lanes.
    {[
      interleave_upper_lanes ~even ~odd
      = (even.(2), odd.(2), even.(3), odd.(3), even.(6), odd.(6), even.(7), odd.(7))
    ]} *)
val interleave_upper_lanes : even:t -> odd:t -> t

(** [_mm256_unpacklo_ps] Operates on two float32x4 lanes.
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
    is in [0,3]. Operates on two float32x4 lanes. Exposed as an external so user code can
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
    is in [0,3]. Operates on two float32x4 lanes. Exposed as an external so user code can
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

(** [_mm256_permutevar_ps] Operates on two float32x4 lanes. Each lane of [idx] is
    interpreted as an integer in [0,3] by taking its bottom two bits.
    {[
      permute_lanes_by x ~idx:(1, 0, 3, 2, 0, 2, 1, 3)
      = (x.(1), x.(0), x.(3), x.(2), x.(4), x.(6), x.(5), x.(7))
    ]} *)
val permute_lanes_by : t -> idx:int32x8# -> t

(* Math *)

(** [_mm256_min_ps] Equivalent to pointwise (x < y ? x : y). If either lane is NaN, the
    second lane is returned. *)
val min : t -> t -> t

(** [_mm256_max_ps] Equivalent to pointwise (x > y ? x : y). If either lane is NaN, the
    second lane is returned. *)
val max : t -> t -> t

(** [_mm256_add_ps] *)
val add : t -> t -> t

(** [_mm256_sub_ps] *)
val sub : t -> t -> t

(** [_mm256_mul_ps] *)
val mul : t -> t -> t

(** [_mm256_div_ps] *)
val div : t -> t -> t

(** Compiles to xor with a static constant. *)
val neg : t -> t

(** Compiles to and with a static constant. *)
val abs : t -> t

(** [_mm256_rcp_ps] WARNING: result has relative error up to 1.5*2^-12, and may differ
    between CPU vendors. *)
val rcp : t -> t

(** [_mm256_rsqrt_ps] WARNING: result has relative error up to 1.5*2^-12, and may differ
    between CPU vendors. *)
val rsqrt : t -> t

(** [_mm256_sqrt_ps] *)
val sqrt : t -> t

(** [_mm256_addsub_ps]
    {[
      add_sub x y
      = ( x.(0) - y.(0)
        , x.(1) + y.(1)
        , x.(2) - y.(2)
        , x.(3) + y.(3)
        , x.(4) - y.(4)
        , x.(5) + y.(5)
        , x.(6) - y.(6)
        , x.(7) + y.(7) )
    ]} *)
val add_sub : t -> t -> t

(** [_mm256_hadd_ps] Operates on two float32x4 lanes.
    {[
      horizontal_add_lanes x y
      = ( x.(1) + x.(0)
        , x.(3) + x.(2)
        , y.(1) + y.(0)
        , y.(3) + y.(2)
        , x.(5) + x.(4)
        , x.(7) + x.(6)
        , y.(5) + y.(4)
        , y.(7) + y.(6) )
    ]} *)
val horizontal_add_lanes : t -> t -> t

(** [_mm256_hsub_ps] Operates on two float32x4 lanes.
    {[
      horizontal_sub_lanes x y
      = ( x.(0) - x.(1)
        , x.(2) - x.(3)
        , y.(0) - y.(1)
        , y.(2) - y.(3)
        , x.(4) - x.(5)
        , x.(6) - x.(7)
        , y.(4) - y.(5)
        , y.(6) - y.(7) )
    ]} *)
val horizontal_sub_lanes : t -> t -> t

(** Dot product. *)
val dot : t -> t -> float32#

(** [_mm256_fmadd_ps]. Computes [x * y + z] without intermediate rounding. *)
val mul_add : t -> t -> t -> t

(** [_mm256_fmsub_ps]. Computes [x * y - z] without intermediate rounding. *)
val mul_sub : t -> t -> t -> t

(** [_mm256_fnmadd_ps]. Computes [-(x * y) + z] without intermediate rounding. *)
val neg_mul_add : t -> t -> t -> t

(** [_mm256_fnmsub_ps]. Computes [-(x * y) - z] without intermediate rounding. *)
val neg_mul_sub : t -> t -> t -> t

(** [_mm256_fmaddsub_ps]. Computes the following expression without intermediate rounding.
    {[
      mul_add_sub x y z
      = ( (x.(0) * y.(0)) - z.(0)
        , (x.(1) * y.(1)) + z.(1)
        , (x.(2) * y.(2)) - z.(2)
        , (x.(3) * y.(3)) + z.(3)
        , (x.(4) * y.(4)) - z.(4)
        , (x.(5) * y.(5)) + z.(5)
        , (x.(6) * y.(6)) - z.(6)
        , (x.(7) * y.(7)) + z.(7) )
    ]} *)
val mul_add_sub : t -> t -> t -> t

(** [_mm256_fmsubadd_ps]. Computes the following expression without intermediate rounding.
    {[
      mul_add_sub x y z
      = ( (x.(0) * y.(0)) + z.(0)
        , (x.(1) * y.(1)) - z.(1)
        , (x.(2) * y.(2)) + z.(2)
        , (x.(3) * y.(3)) - z.(3)
        , (x.(4) * y.(4)) + z.(4)
        , (x.(5) * y.(5)) - z.(5)
        , (x.(6) * y.(6)) + z.(6)
        , (x.(7) * y.(7)) - z.(7) )
    ]} *)
val mul_sub_add : t -> t -> t -> t

(* Operators *)

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t
val ( / ) : t -> t -> t
val ( * ) : t -> t -> t

(* Rounding *)

(** [_mm256_cvtps_epi32] *)
val iround_current : t -> int32x8#

(** [_mm256_round_ps] *)
val round_nearest : t -> t

(** [_mm256_round_ps] *)
val round_current : t -> t

(** [_mm256_round_ps] *)
val round_down : t -> t

(** [_mm256_round_ps] *)
val round_up : t -> t

(** [_mm256_round_ps] *)
val round_toward_zero : t -> t

(* Casts *)

(** Identity; leaves upper 224 bits unspecified. *)
val unsafe_of_float32 : float32# -> t

(** Identity; leaves upper 128 bits unspecified. *)
val unsafe_of_float32x4 : float32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float16x16_bits : float16x16# -> t

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

(** [_mm256_cvtph_ps] *)
val of_float16x8 : float16x8# -> t

(** [_mm256_cvtepi32_ps]. Performs numeric conversion from int32# to float32# *)
val of_int32x8 : int32x8# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

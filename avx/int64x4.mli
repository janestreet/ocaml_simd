@@ portable

type t = int64x4#
type mask = int64x4#

val box : t -> int64x4
val unbox : int64x4 @ local -> t

(* Creation *)

(** Equivalent to [const1 #0L]. *)
val zero : unit -> t

(** Equivalent to [const1 #1L]. *)
val one : unit -> t

(** [_mm256_set1_epi64x] *)
val set1 : int64# -> t

(** [_mm256_set_epi64x] *)
val set : int64# -> int64# -> int64# -> int64# -> t

(** [_mm256_set_m128] Operates on two int64x2 lanes. *)
val set_lanes : int64x2# -> int64x2# -> t

(** Argument must be a literal or an unboxing function applied to a literal. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const1 : int64# -> t = "ocaml_simd_avx_unreachable" "caml_int64x4_const1"
[@@noalloc] [@@builtin]

(** Arguments must be literals or unboxing functions applied to literals. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const
  :  int64#
  -> int64#
  -> int64#
  -> int64#
  -> t
  = "ocaml_simd_avx_unreachable" "caml_int64x4_const4"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int64x4
module String = Load_store.String_Int64x4
module Bytes = Load_store.Bytes_Int64x4
module Bigstring = Load_store.Bigstring_Int64x4
module Unsafe_immediate_array = Load_store.Unsafe_immediate_array
module Unsafe_immediate_iarray = Load_store.Unsafe_immediate_iarray
module Int64_u_array = Load_store.Int64_u_array
module Nativeint_u_array = Load_store.Nativeint_u_array

(* Control Flow *)

module Test : Test.S with type t := t

(** Compiles to cmpgt,cmpeq,orpd. *)
val ( >= ) : t -> t -> mask

(** Compiles to cmpgt,cmpeq,orpd. *)
val ( <= ) : t -> t -> mask

(** [_mm256_cmpeq_epi64] *)
val ( = ) : t -> t -> mask

(** [_mm256_cmpgt_epi64] *)
val ( > ) : t -> t -> mask

(** [_mm256_cmpgt_epi64] with flipped arguments. *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd. *)
val ( <> ) : t -> t -> mask

(** [_mm256_cmpeq_epi64] *)
val equal : t -> t -> mask

(** [_mm256_movemask_pd] *)
val movemask : mask -> int64#

(** [_mm256_blendv_pd] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail]. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,3]. *)
val insert : idx:int64# -> t -> int64# -> t

(** [idx] must be in [0,3]. *)
val extract : idx:int64# -> t -> int64#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int64#

(** [idx] must be a literal in [0,1]. Operates on two int64x2 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external insert_lane
  :  idx:int64#
  -> t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

(** [idx] must be a literal in [0,1]. Operates on two int64x2 lanes. Exposed as an
    external so user code can compile without cross-library inlining. *)
external extract_lane
  :  idx:int64#
  -> t
  -> int64x2#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

(** Projection. Has no runtime cost. Operates on two int64x2 lanes. *)
val extract_lane0 : t -> int64x2#

(** Slow, intended for debugging / printing / etc. *)
val splat : t -> #(int64# * int64# * int64# * int64#)

(** [_mm256_unpackhi_epi64] Operates on two int64x2 lanes.
    {[
      interleave_upper_lanes ~even ~odd = (even.(1), odd.(1), even.(3), odd.(3))
    ]} *)
val interleave_upper_lanes : even:t -> odd:t -> t

(** [_mm256_unpacklo_epi64] Operates on two int64x2 lanes.
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
    each N is in [0,1]. Operates on two int64x2 lanes. Exposed as an external so user code
    can compile without cross-library inlining.
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

(** [_mm256_permutevar_pd] Operates on two int64x2 lanes. Each lane of [idx] is
    interpreted as an integer in [0,1] by taking its *second* lowest bit.
    {[
      permute_lanes_by x ~idx:(2, 0, 0, 2) = (x.(1), x.(0), x.(2), x.(3))
    ]} *)
val permute_lanes_by : t -> idx:t -> t

(* Math *)

(** [_mm256_add_epi64] *)
val add : t -> t -> t

(** [_mm256_sub_epi64] *)
val sub : t -> t -> t

(** Compiles to xorpd,padd. *)
val neg : t -> t

(** Compiles to andpd,xorpd,padd,blend. Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

(** [_mm256_sll_epi64] *)
val shift_left_logical : t -> int64# -> t

(** [_mm256_srl_epi64] *)
val shift_right_logical : t -> int64# -> t

(** [_mm256_sllv_epi64] *)
val shift_left_logical_by : t -> shift:t -> t

(** [_mm256_srlv_epi64] *)
val shift_right_logical_by : t -> shift:t -> t

(** [_mm256_bslli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int64x2 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_left_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_left_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_bsrli_epi128] First argument must be an unsigned integer literal in [0,15].
    Operates on two int64x2 lanes. Exposed as an external so user code can compile without
    cross-library inlining. *)
external shifti_right_bytes_lanes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_right_bytes"
[@@noalloc] [@@builtin]

(** [_mm256_slli_epi64] First argument must be an unsigned integer literal in [0,63].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_left_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_slli"
[@@noalloc] [@@builtin]

(** [_mm256_srli_epi64] First argument must be an unsigned integer literal in [0,63].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_right_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_srli"
[@@noalloc] [@@builtin]

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
val unsafe_of_int64x2 : int64x2# -> t

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
val of_int32x8_bits : int32x8# -> t

(** [_mm256_cvtepi8_epi64] *)
val of_int8x16 : int8x16# -> t

(** [_mm256_cvtepu8_epi64] *)
val of_int8x16_unsigned : int8x16# -> t

(** [_mm256_cvtepi16_epi64] *)
val of_int16x8 : int16x8# -> t

(** [_mm256_cvtepu16_epi64] *)
val of_int16x8_unsigned : int16x8# -> t

(** [_mm256_cvtepi32_epi64] *)
val of_int32x4 : int32x4# -> t

(** [_mm256_cvtepu32_epi64] *)
val of_int32x4_unsigned : int32x4# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

@@ portable

type t = int32x4#
type mask = int32x4#

val box : t -> int32x4
val unbox : int32x4 @ local -> t

(* Creation *)

(** Equivalent to [const1 #0l]. *)
val zero : unit -> t

(** Equivalent to [const1 #1l]. *)
val one : unit -> t

(** [_mm_set1_epi32] Compiles to mov,shufps. *)
val set1 : int32# -> t

(** [_mm_set_epi32] Compiles to 4x movd,2x unpcklps,punpckl. *)
val set : int32# -> int32# -> int32# -> int32# -> t

(** Argument must be a literal or an unboxing function applied to a literal. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const1 : int32# -> t = "ocaml_simd_sse_unreachable" "caml_int32x4_const1"
[@@noalloc] [@@builtin]

(** Arguments must be literals or unboxing functions applied to literals. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const
  :  int32#
  -> int32#
  -> int32#
  -> int32#
  -> t
  = "ocaml_simd_sse_unreachable" "caml_int32x4_const4"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int32x4
module String = Load_store.String_Int32x4
module Bytes = Load_store.Bytes_Int32x4
module Bigstring = Load_store.Bigstring_Int32x4
module Int32_u_array = Load_store.Int32_u_array

(* Control Flow *)

module Test : Test.S with type t := t

(** Compiles to cmpgt,cmpeq,orpd *)
val ( >= ) : t -> t -> mask

(** Compiles to cmpgt,cmpeq,orpd *)
val ( <= ) : t -> t -> mask

(** [_mm_cmpeq_epi32] *)
val ( = ) : t -> t -> mask

(** [_mm_cmpgt_epi32] *)
val ( > ) : t -> t -> mask

(** [_mm_cmplt_epi32] *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd *)
val ( <> ) : t -> t -> mask

(** [_mm_cmpeq_epi32] *)
val equal : t -> t -> mask

(** [_mm_movemask_ps] *)
val movemask : mask -> int64#

(** [_mm_blendv_ps] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail]. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,3]. *)
val insert : idx:int64# -> t -> int32# -> t

(** [idx] must be in [0,3]. *)
val extract : idx:int64# -> t -> int32#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int32#

(** Slow, intended for debugging / printing / etc. *)
val splat : t -> #(int32# * int32# * int32# * int32#)

(** [_mm_unpackhi_ps] *)
val interleave_upper : even:t -> odd:t -> t

(** [_mm_unpacklo_ps] *)
val interleave_lower : even:t -> odd:t -> t

(** [_mm_moveldup_ps] *)
val duplicate_even : t -> t

(** [_mm_movehdup_ps] *)
val duplicate_odd : t -> t

(** [_mm_blend_ps] Specify blend with ppx_simd: [%blend N, N, N, N], where each N is in
    [0,1]. Exposed as an external so user code can compile without cross-library inlining. *)
external blend
  :  (Ocaml_simd.Blend4.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_32"
[@@noalloc] [@@builtin]

(** [_mm_shuffle_ps] Specify shuffle with ppx_simd: [%shuffle N, N, N, N], where each N is
    in [0,3]. Exposed as an external so user code can compile without cross-library
    inlining. *)
external shuffle
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse_vec128_shuffle_32"
[@@noalloc] [@@builtin]

(* Math *)

(** [_mm_min_epi32] *)
val min : t -> t -> t

(** [_mm_max_epi32] *)
val max : t -> t -> t

(** [_mm_min_epu32] *)
val min_unsigned : t -> t -> t

(** [_mm_max_epu32] *)
val max_unsigned : t -> t -> t

(** [_mm_add_epi32] *)
val add : t -> t -> t

(** [_mm_sub_epi32] *)
val sub : t -> t -> t

(** [_mm_sign_epi32] with -1. *)
val neg : t -> t

(** [_mm_abs_epi32] Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

(** [_mm_sll_epi32] *)
val shift_left_logical : t -> int64# -> t

(** [_mm_srl_epi32] *)
val shift_right_logical : t -> int64# -> t

(** [_mm_sra_epi32] *)
val shift_right_arithmetic : t -> int64# -> t

(** [_mm_bslli_si128] First argument must be an unsigned integer literal in [0,15].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_left_bytes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

(** [_mm_bsrli_si128] First argument must be an unsigned integer literal in [0,15].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_right_bytes
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

(** [_mm_slli_epi32] First argument must be an unsigned integer literal in [0,31]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_left_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int32x4_slli"
[@@noalloc] [@@builtin]

(** [_mm_srli_epi32] First argument must be an unsigned integer literal in [0,31]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_right_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int32x4_srli"
[@@noalloc] [@@builtin]

(** [_mm_srai_epi32] First argument must be an unsigned integer literal in [0,31]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int32x4_srai"
[@@noalloc] [@@builtin]

(** [_mm_hadd_epi32] *)
val horizontal_add : t -> t -> t

(** [_mm_hsub_epi32] *)
val horizontal_sub : t -> t -> t

(** [_mm_sign_epi32] *)
val mul_sign : t -> t -> t

(** [_mm_mullo_epi32] *)
val mul_low_bits : t -> t -> t

(** [_mm_mul_epi32] *)
val mul_even : t -> t -> int64x2#

(** [_mm_mul_epu32] *)
val mul_even_unsigned : t -> t -> int64x2#

(* Operators *)

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t

(** Compiles to xor with a static constant. *)
val lnot : t -> t

(** [_mm_or_si128] *)
val ( lor ) : t -> t -> t

(** [_mm_and_si128] *)
val ( land ) : t -> t -> t

(** [_mm_andnot_si128] *)
val landnot : not:t -> t -> t

(** [_mm_xor_si128] *)
val ( lxor ) : t -> t -> t

(* Casts *)

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float16x8_bits : float16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x4_bits : float32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float64x2_bits : float64x2# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int8x16_bits : int8x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int16x8_bits : int16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x2_bits : int64x2# -> t

(** [_mm_cvtps_epi32] *)
val of_float32x4 : float32x4# -> t

(** [_mm_cvttps_epi32] *)
val of_float32x4_trunc : float32x4# -> t

(** [_mm_cvtepi8_epi32] *)
val of_int8x16 : int8x16# -> t

(** [_mm_cvtepu8_epi32] *)
val of_int8x16_unsigned : int8x16# -> t

(** [_mm_cvtepi16_epi32] *)
val of_int16x8 : int16x8# -> t

(** [_mm_cvtepu16_epi32] *)
val of_int16x8_unsigned : int16x8# -> t

(** [_mm_cvtpd_epi32] *)
val of_float64x2 : float64x2# -> t

(** [_mm_cvttpd_epi32] *)
val of_float64x2_trunc : float64x2# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

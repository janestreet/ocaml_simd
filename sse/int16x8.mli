@@ portable

type t = int16x8#
type mask = int16x8#

val box : t -> int16x8
val unbox : int16x8 @ local -> t

(* Creation *)

(** Equivalent to [const1 0]. *)
val zero : unit -> t

(** Equivalent to [const1 1]. *)
val one : unit -> t

(** [_mm_set1_epi16] Compiles to movd,pshufb. *)
val set1 : int16# -> t

(** [_mm_set_epi16] Compiles to 4x movd,4x pinsr,3x punpcklw. *)
val set
  :  int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> t

(** Argument must be an unsigned 16-bit int literal. Compiles to a static vector literal.
    Exposed as an external so user code can compile without cross-library inlining. *)
external const1 : int16# -> t = "ocaml_simd_sse_unreachable" "caml_int16x8_const1"
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
  -> t
  = "ocaml_simd_sse_unreachable" "caml_int16x8_const8"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int16x8
module String = Load_store.String_Int16x8
module Bytes = Load_store.Bytes_Int16x8
module Bigstring = Load_store.Bigstring_Int16x8

(* Control Flow *)

module Test : Test.S with type t := t

(** Compiles to cmpgt,cmpeq,orpd. *)
val ( >= ) : t -> t -> mask

(** Compiles to cmpgt,cmpeq,orpd. *)
val ( <= ) : t -> t -> mask

(** [_mm_cmpeq_epi16] *)
val ( = ) : t -> t -> mask

(** [_mm_cmpgt_epi16] *)
val ( > ) : t -> t -> mask

(** [_mm_cmplt_epi16] *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd. *)
val ( <> ) : t -> t -> mask

(** [_mm_cmpeq_epi16] *)
val equal : t -> t -> mask

(* Utility *)

(** [idx] must be in [0,7]. *)
val insert : idx:int64# -> t -> int16# -> t

(** [idx] must be in [0,7]. *)
val extract : idx:int64# -> t -> int16#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int16#

(** Slow, intended for debugging / printing / etc. *)
val splat : t -> #(int16# * int16# * int16# * int16# * int16# * int16# * int16# * int16#)

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

(* Math *)

(** [_mm_min_epi16] *)
val min : t -> t -> t

(** [_mm_max_epi16] *)
val max : t -> t -> t

(** [_mm_min_epu16] *)
val min_unsigned : t -> t -> t

(** [_mm_max_epu16] *)
val max_unsigned : t -> t -> t

(** [_mm_add_epi16] *)
val add : t -> t -> t

(** [_mm_adds_epi16] *)
val add_saturating : t -> t -> t

(** [_mm_adds_epu16] *)
val add_saturating_unsigned : t -> t -> t

(** [_mm_sub_epi16] *)
val sub : t -> t -> t

(** [_mm_subs_epi16] *)
val sub_saturating : t -> t -> t

(** [_mm_subs_epu16] *)
val sub_saturating_unsigned : t -> t -> t

(** [_mm_sign_epi16] with -1. *)
val neg : t -> t

(** [_mm_abs_epi16] Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

(** [_mm_sll_epi16] *)
val shift_left_logical : t -> int64# -> t

(** [_mm_srl_epi16] *)
val shift_right_logical : t -> int64# -> t

(** [_mm_sra_epi16] *)
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

(** [_mm_slli_epi16] First argument must be an unsigned integer literal in [0,15]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_left_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int16x8_slli"
[@@noalloc] [@@builtin]

(** [_mm_srli_epi16] First argument must be an unsigned integer literal in [0,15]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_right_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int16x8_srli"
[@@noalloc] [@@builtin]

(** [_mm_srai_epi16] First argument must be an unsigned integer literal in [0,15]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int16x8_srai"
[@@noalloc] [@@builtin]

(** [_mm_hadd_epi16] *)
val horizontal_add : t -> t -> t

(** [_mm_hadds_epi16] *)
val horizontal_add_saturating : t -> t -> t

(** [_mm_hsub_epi16] *)
val horizontal_sub : t -> t -> t

(** [_mm_hsubs_epi16] *)
val horizontal_sub_saturating : t -> t -> t

(** [_mm_sign_epi16] *)
val mul_sign : t -> t -> t

(** [_mm_avg_epu16] *)
val average_unsigned : t -> t -> t

(** [_mm_minpos_epu16] *)
val minpos_unsigned : t -> t

(** [_mm_mullo_epi16] *)
val mul_low_bits : t -> t -> t

(** [_mm_mulhi_epi16] *)
val mul_high_bits : t -> t -> t

(** [_mm_mulhi_epu16] *)
val mul_high_bits_unsigned : t -> t -> t

(** [_mm_madd_epi16] *)
val mul_horizontal_add : t -> t -> int32x4#

(** [_mm_mulhrs_epi16] *)
val mul_round : t -> t -> t

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
val of_int32x4_bits : int32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x2_bits : int64x2# -> t

(** [_mm_cvtepi8_epi16] *)
val of_int8x16 : int8x16# -> t

(** [_mm_cvtepu8_epi16] *)
val of_int8x16_unsigned : int8x16# -> t

(** [_mm_packs_epi32] *)
val of_int32x4_saturating : int32x4# -> int32x4# -> t

(** [_mm_packus_epi32] Clamps signed input to [0..0xffff]. *)
val of_int32x4_saturating_unsigned : int32x4# -> int32x4# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

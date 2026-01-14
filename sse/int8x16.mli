@@ portable

type t = int8x16#
type mask = int8x16#

val box : t -> int8x16
val unbox : int8x16 @ local -> t

(* Creation *)

(** Equivalent to [const1 0]. *)
val zero : unit -> t

(** Equivalent to [const1 1]. *)
val one : unit -> t

(** [_mm_set1_epi8] Compiles to mov,pshufb *)
val set1 : int8# -> t

(** [_mm_set_epi8] Compiles to 8x mov,8x pinsr,7x unpckl *)
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
  -> t

(** Argument must be an unsigned 8-bit int literal. Compiles to a static vector literal.
    Exposed as an external so user code can compile without cross-library inlining. *)
external const1 : int8# -> t = "ocaml_simd_sse_unreachable" "caml_int8x16_const1"
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
  -> t
  = "ocaml_simd_sse_unreachable" "caml_int8x16_const16"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int8x16
module String = Load_store.String_Int8x16
module Bytes = Load_store.Bytes_Int8x16
module Bigstring = Load_store.Bigstring_Int8x16

(* Control Flow *)

module Test : Test.S with type t := t

(** Compiles to cmpgt,cmpeq,orpd *)
val ( >= ) : t -> t -> mask

(** Compiles to cmpgt,cmpeq,orpd *)
val ( <= ) : t -> t -> mask

(** [_mm_cmpeq_epi8] *)
val ( = ) : t -> t -> mask

(** [_mm_cmpgt_epi8] *)
val ( > ) : t -> t -> mask

(** [_mm_cmplt_epi8] *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd *)
val ( <> ) : t -> t -> mask

(** [_mm_cmpeq_epi8] *)
val equal : t -> t -> mask

(** [_mm_movemask_epi8] *)
val movemask : mask -> int64#

(** [_mm_blendv_epi8] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail].

    There is no static blend; use this for all blend needs. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,16]. *)
val insert : idx:int64# -> t -> int8# -> t

(** [idx] must be in [0,16]. *)
val extract : idx:int64# -> t -> int8#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int8#

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
      * int8#)

(** [_mm_unpackhi_epi8] *)
val interleave_upper : even:t -> odd:t -> t

(** [_mm_unpacklo_epi8] *)
val interleave_lower : even:t -> odd:t -> t

(** [_mm_shuffle_epi8] *)
val shuffle : pattern:t -> t -> t

(** [_mm_alignr_epi8] First argument must be an 8-bit unsigned integer literal. Exposed as
    an external so user code can compile without cross-library inlining. *)
external concat_shift_right_bytes
  :  int64#
  -> t
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_ssse3_vec128_align_right_bytes"
[@@noalloc] [@@builtin]

(* Math *)

(** [_mm_min_epi8] *)
val min : t -> t -> t

(** [_mm_max_epi8] *)
val max : t -> t -> t

(** [_mm_min_epu8] *)
val min_unsigned : t -> t -> t

(** [_mm_max_epu8] *)
val max_unsigned : t -> t -> t

(** [_mm_add_epi8] *)
val add : t -> t -> t

(** [_mm_adds_epi8] *)
val add_saturating : t -> t -> t

(** [_mm_adds_epu8] *)
val add_saturating_unsigned : t -> t -> t

(** [_mm_sub_epi8] *)
val sub : t -> t -> t

(** [_mm_subs_epi8] *)
val sub_saturating : t -> t -> t

(** [_mm_subs_epu8] *)
val sub_saturating_unsigned : t -> t -> t

(** [_mm_sign_epi8] with -1. *)
val neg : t -> t

(** [_mm_abs_epi8] Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

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

(** [_mm_sign_epi8] *)
val mul_sign : t -> t -> t

(** [_mm_avg_epu8] *)
val average_unsigned : t -> t -> t

(** [_mm_sad_epu8] *)
val sum_absolute_differences_unsigned : t -> t -> int64x2#

(** [_mm_mpsadbw_epu8] First argument must be an unsigned 3-bit integer literal. Exposed
    as an external so user code can compile without cross-library inlining. *)
external multi_sum_absolute_differences_unsigned
  :  int64#
  -> t
  -> t
  -> int16x8#
  = "ocaml_simd_sse_unreachable" "caml_sse41_int8x16_multi_sad_unsigned"
[@@noalloc] [@@builtin]

(** [_mm_maddubs_epi16] *)
val mul_unsigned_by_signed_horizontal_add_saturating : t -> t -> int16x8#

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
val of_int16x8_bits : int16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int32x4_bits : int32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x2_bits : int64x2# -> t

(** [_mm_packs_epi16] *)
val of_int16x8_saturating : int16x8# -> int16x8# -> t

(** [_mm_packus_epi16] Clamps signed input to [0..0xff]. *)
val of_int16x8_saturating_unsigned : int16x8# -> int16x8# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

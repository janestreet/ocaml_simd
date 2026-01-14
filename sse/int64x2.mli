@@ portable

type t = int64x2#
type mask = int64x2#

val box : t -> int64x2
val unbox : int64x2 @ local -> t

(* Creation *)

(** Equivalent to [const1 #0L]. *)
val zero : unit -> t

(** Equivalent to [const1 #1L]. *)
val one : unit -> t

(** [_mm_set1_epi64x] Compiles to mov,shufpd. *)
val set1 : int64# -> t

(** [_mm_set_epi64x] Compiles to 2x movq,punpckl. *)
val set : int64# -> int64# -> t

(** Argument must be a literal or an unboxing function applied to a literal. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const1 : int64# -> t = "ocaml_simd_sse_unreachable" "caml_int64x2_const1"
[@@noalloc] [@@builtin]

(** Arguments must be literals or unboxing functions applied to literals. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const
  :  int64#
  -> int64#
  -> t
  = "ocaml_simd_sse_unreachable" "caml_int64x2_const2"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Int64x2
module String = Load_store.String_Int64x2
module Bytes = Load_store.Bytes_Int64x2
module Bigstring = Load_store.Bigstring_Int64x2
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

(** [_mm_cmpeq_epi64] *)
val ( = ) : t -> t -> mask

(** [_mm_cmpgt_epi64] *)
val ( > ) : t -> t -> mask

(** [_mm_cmplt_epi64] *)
val ( < ) : t -> t -> mask

(** Compiles to cmpeq,xorpd. *)
val ( <> ) : t -> t -> mask

(** [_mm_cmpeq_epi64] *)
val equal : t -> t -> mask

(** [_mm_movemask_pd] *)
val movemask : mask -> int64#

(** [_mm_blendv_pd] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail]. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,1]. *)
val insert : idx:int64# -> t -> int64# -> t

(** [idx] must be in [0,1]. *)
val extract : idx:int64# -> t -> int64#

(** Projection. More efficient than [extract ~idx:#0L]. *)
val extract0 : t -> int64#

(** Slow, intended for debugging / printing / etc. *)
val splat : t -> #(int64# * int64#)

(** [_mm_unpackhi_epi64] *)
val interleave_upper : even:t -> odd:t -> t

(** [_mm_unpacklo_epi64] *)
val interleave_lower : even:t -> odd:t -> t

(** [_mm_movehl_pd] *)
val upper_to_lower : from:t -> onto:t -> t

(** [_mm_movelh_pd] *)
val lower_to_upper : from:t -> onto:t -> t

(** [_mm_movedup_pd] *)
val duplicate_lower : t -> t

(** [_mm_blend_pd] Specify blend with ppx_simd: [%blend N, N], where each N is in [0,1].
    Exposed as an external so user code can compile without cross-library inlining. *)
external blend
  :  (Ocaml_simd.Blend2.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_64"
[@@noalloc] [@@builtin]

(** [_mm_shuffle_pd] Specify shuffle with ppx_simd: [%shuffle N, N], where each N is in
    [0,1]. Exposed as an external so user code can compile without cross-library inlining. *)
external shuffle
  :  (Ocaml_simd.Shuffle2.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_64"
[@@noalloc] [@@builtin]

(* Math *)

(** [_mm_add_epi64] *)
val add : t -> t -> t

(** [_mm_sub_epi64] *)
val sub : t -> t -> t

(** Compiles to xorpd,padd. *)
val neg : t -> t

(** Compiles to andpd,xorpd,padd,blend. Equivalent to (x < 0 ? -x : x). *)
val abs : t -> t

(** [_mm_sll_epi64] *)
val shift_left_logical : t -> int64# -> t

(** [_mm_srl_epi64] *)
val shift_right_logical : t -> int64# -> t

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

(** [_mm_slli_epi64] First argument must be an unsigned integer literal in [0,63]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_left_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int64x2_slli"
[@@noalloc] [@@builtin]

(** [_mm_srli_epi64] First argument must be an unsigned integer literal in [0,63]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_right_logical
  :  int64#
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_sse2_int64x2_srli"
[@@noalloc] [@@builtin]

(* [_mm_clmulepi64_si128] First argument must be an unsigned integer literal in [0,31].
   Exposed as an external so user code can compile without cross-library inlining. *)
external mul_without_carry
  :  int64#
  -> t
  -> t
  -> t
  = "ocaml_simd_sse_unreachable" "caml_clmul_int64x2"
[@@noalloc] [@@builtin]

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
val of_int32x4_bits : int32x4# -> t

(** [_mm_cvtepi8_epi64] *)
val of_int8x16 : int8x16# -> t

(** [_mm_cvtepu8_epi64] *)
val of_int8x16_unsigned : int8x16# -> t

(** [_mm_cvtepi16_epi64] *)
val of_int16x8 : int16x8# -> t

(** [_mm_cvtepu16_epi64] *)
val of_int16x8_unsigned : int16x8# -> t

(** [_mm_cvtepi16_epi64] *)
val of_int32x4 : int32x4# -> t

(** [_mm_cvtepu16_epi64] *)
val of_int32x4_unsigned : int32x4# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

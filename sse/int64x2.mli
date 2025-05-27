type t = int64x2#
type mask = int64x2#

val box : t -> int64x2
val unbox : int64x2 -> t

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
external const1 : int64# -> (t[@unboxed]) = "ocaml_simd_unreachable" "caml_int64x2_const1"
[@@noalloc] [@@builtin]

(** Arguments must be literals or unboxing functions applied to literals. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const
  :  int64#
  -> int64#
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_int64x2_const2"
[@@noalloc] [@@builtin]

(* Load/Store *)

module String : Load_store.String with type t := t
module Bytes : Load_store.Bytes with type t := t
module Bigstring : Load_store.Bigstring with type t := t
module Immediate_array = Load_store.Immediate_array
module Immediate_iarray = Load_store.Immediate_iarray
module Int64_u_array = Load_store.Int64_u_array
module Nativeint_u_array = Load_store.Nativeint_u_array

(* Control Flow *)

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
val movemask : mask -> int

(** [_mm_blendv_pd] *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [_mm_insert_epi64]: [idx] must be in [0,1]. Exposed as an external so user code can
    compile without cross-library inlining. *)
external insert
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> int64#
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse41_int64x2_insert"
[@@noalloc] [@@builtin]

(** [_mm_extract_epi64]: [idx] must be in [0,1]. Exposed as an external so user code can
    compile without cross-library inlining. *)
external extract
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> int64#
  = "ocaml_simd_unreachable" "caml_sse41_int64x2_extract"
[@@noalloc] [@@builtin]

(** Compiles to movq. *)
val extract0 : t -> int64#

type splat =
  { a : int64#
  ; b : int64#
  }

(** Compiles to movq,pextr. Only use this for debugging / printing / etc. *)
val splat : t -> splat

(** [_mm_unpackhi_epi64] *)
val interleave_upper : lower:t -> upper:t -> t

(** [_mm_unpacklo_epi64] *)
val interleave_lower : lower:t -> upper:t -> t

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
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blend_64"
[@@noalloc] [@@builtin]

(** [_mm_shuffle_pd] Specify shuffle with ppx_simd: [%shuffle N, N], where each N is in
    [0,1]. Exposed as an external so user code can compile without cross-library inlining. *)
external shuffle
  :  (Ocaml_simd.Shuffle2.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shuffle_64"
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

(** Compiles to movq,psll. *)
val shift_left_logical : t -> int -> t

(** Compiles to movq,psrl. *)
val shift_right_logical : t -> int -> t

(** [_mm_bslli_si128] First argument must be an unsigned integer literal in [0,16].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_left_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

(** [_mm_bsrli_si128] First argument must be an unsigned integer literal in [0,16].
    Exposed as an external so user code can compile without cross-library inlining. *)
external shifti_right_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

(** [_mm_slli_epi64] First argument must be an unsigned integer literal in [0,31]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_left_logical
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_int64x2_slli"
[@@noalloc] [@@builtin]

(** [_mm_srli_epi64] First argument must be an unsigned integer literal in [0,31]. Exposed
    as an external so user code can compile without cross-library inlining. *)
external shifti_right_logical
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_int64x2_srli"
[@@noalloc] [@@builtin]

(* [_mm_clmulepi64_si128] First argument must be an unsigned integer literal in [0,31].
   Exposed as an external so user code can compile without cross-library inlining. *)
external mul_without_carry
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_clmul_int64x2"
[@@noalloc] [@@builtin]

(* Operators *)

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t

(** Compiles to xorpd with a static constant. *)
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

(** Identity *)
val of_float32x4_bits : float32x4# -> t

(** Identity *)
val of_float64x2_bits : float64x2# -> t

(** Identity *)
val of_int8x16_bits : int8x16# -> t

(** Identity *)
val of_int16x8_bits : int16x8# -> t

(** Identity *)
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

(** Compiles to sscanf, set. *)
val of_string : string -> t

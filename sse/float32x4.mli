@@ portable

type t = float32x4#
type mask = int32x4#

val box : t -> float32x4
val unbox : float32x4 -> t

(* Creation *)

(** Equivalent to [const1 #0.0s]. *)
val zero : unit -> t

(** Equivalent to [const1 #1.0s]. *)
val one : unit -> t

(** [_mm_set1_ps] Compiles to shufps. *)
val set1 : float32# -> t

(** [_mm_set_ps] Compiles to 2x unpcklps,punpckl. *)
val set : float32# -> float32# -> float32# -> float32# -> t

(** Argument must be a float literal. Compiles to a static vector literal. Exposed as an
    external so user code can compile without cross-library inlining. *)
external const1 : float32# -> t = "ocaml_simd_unreachable" "caml_float32x4_const1"
[@@noalloc] [@@builtin]

(** Arguments must be float literals. Compiles to a static vector literal. Exposed as an
    external so user code can compile without cross-library inlining. *)
external const
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  -> t
  = "ocaml_simd_unreachable" "caml_float32x4_const4"
[@@noalloc] [@@builtin]

(* Load/Store *)

module String : Load_store.String with type t := t
module Bytes : Load_store.Bytes with type t := t
module Bigstring : Load_store.Bigstring with type t := t
module Float32_u_array = Load_store.Float32_u_array

(* Control Flow *)

(** [_mm_cmpge_ps] *)
val ( >= ) : t -> t -> mask

(** [_mm_cmple_ps] *)
val ( <= ) : t -> t -> mask

(** [_mm_cmpeq_ps] *)
val ( = ) : t -> t -> mask

(** [_mm_cmpgt_ps] *)
val ( > ) : t -> t -> mask

(** [_mm_cmplt_ps] *)
val ( < ) : t -> t -> mask

(** [_mm_cmpneq_ps] *)
val ( <> ) : t -> t -> mask

(** [_mm_cmpeq_ps] *)
val equal : t -> t -> mask

(** [_mm_cmpunord_ps] *)
val is_nan : t -> mask

(** [_mm_cmpord_ps] *)
val is_not_nan : t -> mask

(** [_mm_movemask_ps] *)
val movemask : mask -> int64#

(** Identity. *)
val bitmask : mask -> int32x4#

(** [_mm_blendv_ps] *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,3]. Compiles to shufps,branch,blendps. Only use this if you need a
    dynamic index. *)
val insert : idx:int64# -> t -> float32# -> t

(** [idx] must be in [0,3]. Compiles to branch,shufps. Only use this if you need a dynamic
    index. *)
val extract : idx:int64# -> t -> float32#

(** Identity *)
val extract0 : t -> float32#

(** Compiles to 3x shufps, 4x cvt, builds record. Only use this for debugging / printing /
    etc. *)
val splat : t -> #(float32# * float32# * float32# * float32#)

(** [_mm_unpackhi_ps] *)
val interleave_upper : lower:t -> upper:t -> t

(** [_mm_unpacklo_ps] *)
val interleave_lower : lower:t -> upper:t -> t

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
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blend_32"
[@@noalloc] [@@builtin]

(** [_mm_shuffle_ps] Specify shuffle with ppx_simd: [%shuffle N, N, N, N], where each N is
    in [0,3]. Exposed as an external so user code can compile without cross-library
    inlining. *)
external shuffle
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  -> t
  = "ocaml_simd_unreachable" "caml_sse_vec128_shuffle_32"
[@@noalloc] [@@builtin]

(* Math *)

(** [_mm_min_ps] Equivalent to (x < y ? x : y). If either lane is NaN, the second lane is
    returned. *)
val min : t -> t -> t

(** [_mm_max_ps] Equivalent to (x > y ? x : y). If either lane is NaN, the second lane is
    returned. *)
val max : t -> t -> t

(** [_mm_add_ps] *)
val add : t -> t -> t

(** [_mm_sub_ps] *)
val sub : t -> t -> t

(** [_mm_mul_ps] *)
val mul : t -> t -> t

(** [_mm_div_ps] *)
val div : t -> t -> t

(** Compiles to xorpd with a static constant. *)
val neg : t -> t

(** Compiles to andpd with a static constant. *)
val abs : t -> t

(** [_mm_rcp_ps] WARNING: result has relative error up to 1.5*2^-12, and may differ
    between CPU vendors. *)
val rcp : t -> t

(** [_mm_rsqrt_ps] WARNING: result has relative error up to 1.5*2^-12, and may differ
    between CPU vendors. *)
val rsqrt : t -> t

(** [_mm_sqrt_ps] *)
val sqrt : t -> t

(** [_mm_addsub_ps] *)
val add_sub : t -> t -> t

(** [_mm_hadd_ps] *)
val horizontal_add : t -> t -> t

(** [_mm_hsub_ps] *)
val horizontal_sub : t -> t -> t

(** [_mm_dp_ps] *)
val dot : t -> t -> float32#

(* Operators *)

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t
val ( / ) : t -> t -> t
val ( * ) : t -> t -> t

(* Rounding *)

(** [_mm_cvtps_epi32] *)
val iround_current : t -> int32x4#

(** [_mm_round_ps] *)
val round_nearest : t -> t

(** [_mm_round_ps] *)
val round_current : t -> t

(** [_mm_round_ps] *)
val round_down : t -> t

(** [_mm_round_ps] *)
val round_up : t -> t

(** [_mm_round_ps] *)
val round_toward_zero : t -> t

(* Casts *)

(** Identity *)
val of_float64x2_bits : float64x2# -> t

(** Identity *)
val of_int8x16_bits : int8x16# -> t

(** Identity *)
val of_int16x8_bits : int16x8# -> t

(** Identity *)
val of_int32x4_bits : int32x4# -> t

(** Identity *)
val of_int64x2_bits : int64x2# -> t

(** [_mm_cvtepi32_ps] *)
val of_int32x4 : int32x4# -> t

(** [_mm_cvtpd_ps] *)
val of_float64x2 : float64x2# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. *)
val of_string : string -> t

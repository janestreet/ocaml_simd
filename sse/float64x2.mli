@@ portable

type t = float64x2#
type mask = int64x2#

val box : t -> float64x2
val unbox : float64x2 @ local -> t

(* Creation *)

(** Equivalent to [const1 #0.0]. *)
val zero : unit -> t

(** Equivalent to [const1 #1.0]. *)
val one : unit -> t

(** [_mm_set1_pd] Compiles to shufpd. *)
val set1 : float# -> t

(** [_mm_set_pd] Compiles to unpckl. *)
val set : float# -> float# -> t

(** Argument must be a literal or an unboxing function applied to a literal. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const1 : float# -> t = "ocaml_simd_sse_unreachable" "caml_float64x2_const1"
[@@noalloc] [@@builtin]

(** Arguments must be literals or unboxing functions applied to literals. Compiles to a
    static vector literal. Exposed as an external so user code can compile without
    cross-library inlining. *)
external const
  :  float#
  -> float#
  -> t
  = "ocaml_simd_sse_unreachable" "caml_float64x2_const2"
[@@noalloc] [@@builtin]

(* Load/Store *)

module Raw = Load_store.Raw_Float64x2
module String = Load_store.String_Float64x2
module Bytes = Load_store.Bytes_Float64x2
module Bigstring = Load_store.Bigstring_Float64x2
module Float_array = Load_store.Float_array
module Float_iarray = Load_store.Float_iarray
module Floatarray = Load_store.Floatarray
module Float_u_array = Load_store.Float_u_array

(* Control Flow *)

(** [_mm_cmpge_pd] *)
val ( >= ) : t -> t -> mask

(** [_mm_cmple_pd] *)
val ( <= ) : t -> t -> mask

(** [_mm_cmpeq_pd] *)
val ( = ) : t -> t -> mask

(** [_mm_cmpgt_pd] *)
val ( > ) : t -> t -> mask

(** [_mm_cmplt_pd] *)
val ( < ) : t -> t -> mask

(** [_mm_cmpneq_pd] *)
val ( <> ) : t -> t -> mask

(** [_mm_cmpeq_pd] *)
val equal : t -> t -> mask

(** [_mm_cmpunord_pd] *)
val is_nan : t -> mask

(** [_mm_cmpord_pd] *)
val is_not_nan : t -> mask

(** [_mm_movemask_pd] *)
val movemask : mask -> int64#

(** Identity. *)
val bitmask : mask -> int64x2#

(** [_mm_blendv_pd] Only reads the sign bit of each mask lane. Selects the element from
    [pass] if the sign bit is 1, otherwise [fail]. *)
val select : mask -> fail:t -> pass:t -> t

(* Utility *)

(** [idx] must be in [0,1]. Compiles to shufpd,branch,blendpd. *)
val insert : idx:int64# -> t -> float# -> t

(** [idx] must be in [0,1]. Compiles to branch,shufpd. *)
val extract : idx:int64# -> t -> float#

(** Projection. Has no runtime cost. *)
val extract0 : t -> float#

(** Slow, intended for debugging / printing / etc. *)
val splat : t -> #(float# * float#)

(** [_mm_unpackhi_pd] *)
val interleave_upper : even:t -> odd:t -> t

(** [_mm_unpacklo_pd] *)
val interleave_lower : even:t -> odd:t -> t

(** [_mm_movehl_ps] *)
val lower_to_upper : from:t -> onto:t -> t

(** [_mm_movelh_ps] *)
val upper_to_lower : from:t -> onto:t -> t

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

(** [_mm_min_pd] Equivalent to pointwise (x < y ? x : y). If either lane is NaN, the
    second lane is returned. *)
val min : t -> t -> t

(** [_mm_max_pd] Equivalent to pointwise (x > y ? x : y). If either lane is NaN, the
    second lane is returned. *)
val max : t -> t -> t

(** [_mm_add_pd] *)
val add : t -> t -> t

(** [_mm_sub_pd] *)
val sub : t -> t -> t

(** [_mm_mul_pd] *)
val mul : t -> t -> t

(** [_mm_div_pd] *)
val div : t -> t -> t

(** Compiles to xor with a static constant. *)
val neg : t -> t

(** Compiles to and with a static constant. *)
val abs : t -> t

(** [_mm_sqrt_pd] *)
val sqrt : t -> t

(** [_mm_addsub_pd] *)
val add_sub : t -> t -> t

(** [_mm_hadd_pd] *)
val horizontal_add : t -> t -> t

(** [_mm_hsub_pd] *)
val horizontal_sub : t -> t -> t

(** [_mm_dp_pd] *)
val dot : t -> t -> float#

(* Operators *)

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t
val ( / ) : t -> t -> t
val ( * ) : t -> t -> t

(* Rounding *)

(** [_mm_cvtpd_epi32] *)
val iround_current : t -> int32x4#

(** [_mm_round_pd] *)
val round_nearest : t -> t

(** [_mm_round_pd] *)
val round_current : t -> t

(** [_mm_round_pd] *)
val round_down : t -> t

(** [_mm_round_pd] *)
val round_up : t -> t

(** [_mm_round_pd] *)
val round_toward_zero : t -> t

(* Casts *)

(** Identity; leaves upper 64 bits unspecified. *)
val unsafe_of_float : float# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float16x8_bits : float16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_float32x4_bits : float32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int8x16_bits : int8x16# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int16x8_bits : int16x8# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int32x4_bits : int32x4# -> t

(** Identity in the bit representation. Different numeric interpretation. *)
val of_int64x2_bits : int64x2# -> t

(** [_mm_cvtepi32_pd] *)
val of_int32x4 : int32x4# -> t

(** [_mm_cvtps_pd] *)
val of_float32x4 : float32x4# -> t

(* Strings (Slow) *)

(** Compiles to splat, sprintf. *)
val to_string : t -> string

(** Compiles to sscanf, set. Expects a string in the output format of [to_string]. *)
val of_string : string -> t

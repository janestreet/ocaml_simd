@@ portable

include module type of struct
  include Ocaml_simd_sse.Int64 (** @inline *)
end

(** [_lzcnt_u64]. *)
val count_leading_zeros : int64# -> int64#

(** [_tzcnt_u64]. *)
val count_trailing_zeros : int64# -> int64#

(** [_andn_u64]. Computes [~x & y]. *)
val and_not : int64# -> int64# -> int64#

(** [_bextr_u64]. Extracts [len] contiguous bits from [x] starting at bit [pos]. [len] and
    [pos] must be in the range [0,255]. *)
val extract_bits : int64# -> pos:int64# -> len:int64# -> int64#

(** [_blsi_u64]. Computes [x & (-x)]. *)
val extract_lowest_set_bit : int64# -> int64#

(** [_blsmsk_u64]. Computes [x ^ (x - 1)]. *)
val mask_up_to_lowest_set_bit : int64# -> int64#

(** [_blsr_u64]. Computes [x & (x - 1)]. *)
val clear_lowest_set_bit : int64# -> int64#

(** [_bzhi_u64]. Clears bits at and above index [idx]. *)
val zero_high_bits : int64# -> idx:int64# -> int64#

(** [_mulx_u64]. Performs an unsigned 64-bit multiply of [x] and [y], returning the full
    128-bit result as an unboxed pair of 64-bit values. Does not set flags. *)
val mul_unsigned : int64# -> int64# -> #(low:int64# * high:int64#)

(** [_pext_u64]. Uses [mask] to select which bits to extract from [x]. Selected bits are
    compacted into the contiguous low bits of the result. *)
val gather_bits : int64# -> mask:int64# -> int64#

(** [_pdep_u64]. Uses [mask] to select which bits to deposit onto the result. Selected
    bits are pulled from the contiguous low bits of [x]. *)
val scatter_bits : int64# -> mask:int64# -> int64#

(** Rotates [x] right by a constant number of bits in [0,31]. Does not set flags. Exposed
    as an external so user code can compile without cross-library inlining. *)
external rotate_right
  :  bits:int64#
  -> int64#
  -> int64#
  = "ocaml_simd_avx_unreachable" "caml_bmi2_rorx_int64"
[@@noalloc] [@@builtin amd64]

(** Does not set flags. *)
val shift_right : int64# -> int64# -> int64#

(** Does not set flags. *)
val shift_right_logical : int64# -> int64# -> int64#

(** Does not set flags. *)
val shift_left : int64# -> int64# -> int64#

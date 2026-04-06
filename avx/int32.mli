@@ portable

include module type of struct
  include Ocaml_simd_sse.Int32 (** @inline *)
end

(** [_lzcnt_u32]. *)
val count_leading_zeros : int32# -> int32#

(** [_tzcnt_u32]. *)
val count_trailing_zeros : int32# -> int32#

(** [_andn_u32]. Computes [~x & y]. *)
val and_not : int32# -> int32# -> int32#

(** [_bextr_u32]. Extracts [len] contiguous bits from [x] starting at bit [pos]. [len] and
    [pos] must be in the range [0,255]. *)
val extract_bits : int32# -> pos:int32# -> len:int32# -> int32#

(** [_blsi_u32]. Computes [x & (-x)]. *)
val extract_lowest_set_bit : int32# -> int32#

(** [_blsmsk_u32]. Computes [x ^ (x - 1)]. *)
val mask_up_to_lowest_set_bit : int32# -> int32#

(** [_blsr_u32]. Computes [x & (x - 1)]. *)
val clear_lowest_set_bit : int32# -> int32#

(** [_bzhi_u32]. Clears bits at and above index [idx]. *)
val zero_high_bits : int32# -> idx:int32# -> int32#

(** [_mulx_u32]. Performs an unsigned 32-bit multiply of [x] and [y], returning the full
    64-bit result as an unboxed pair of 32-bit values. Does not set flags. *)
val mul_unsigned : int32# -> int32# -> #(low:int32# * high:int32#)

(** [_pext_u32]. Uses [mask] to select which bits to extract from [x]. Selected bits are
    compacted into the contiguous low bits of the result. *)
val gather_bits : int32# -> mask:int32# -> int32#

(** [_pdep_u32]. Uses [mask] to select which bits to deposit onto the result. Selected
    bits are pulled from the contiguous low bits of [x]. *)
val scatter_bits : int32# -> mask:int32# -> int32#

(** Rotates [x] right by a constant number of bits in [0,31]. Does not set flags. Exposed
    as an external so user code can compile without cross-library inlining. *)
external rotate_right
  :  bits:int64#
  -> int32#
  -> int32#
  = "ocaml_simd_avx_unreachable" "caml_bmi2_rorx_int32"
[@@noalloc] [@@builtin amd64]

(** Does not set flags. *)
val shift_right : int32# -> int32# -> int32#

(** Does not set flags. *)
val shift_right_logical : int32# -> int32# -> int32#

(** Does not set flags. *)
val shift_left : int32# -> int32# -> int32#

(** [_mm_fmadd_sd]. Computes [x * y + z] without intermediate rounding. *)
val mul_add : float# -> float# -> float# -> float#

(** [_mm_fmsub_sd]. Computes [x * y - z] without intermediate rounding. *)
val mul_sub : float# -> float# -> float# -> float#

(** [_mm_fnmadd_sd]. Computes [-(x * y) + z] without intermediate rounding. *)
val neg_mul_add : float# -> float# -> float# -> float#

(** [_mm_fnmsub_sd]. Computes [-(x * y) - z] without intermediate rounding. *)
val neg_mul_sub : float# -> float# -> float# -> float#

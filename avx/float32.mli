(** [_mm_fmadd_ss]. Computes [x * y + z] without intermediate rounding. *)
val mul_add : float32# -> float32# -> float32# -> float32#

(** [_mm_fmsub_ss]. Computes [x * y - z] without intermediate rounding. *)
val mul_sub : float32# -> float32# -> float32# -> float32#

(** [_mm_fnmadd_ss]. Computes [-(x * y) + z] without intermediate rounding. *)
val neg_mul_add : float32# -> float32# -> float32# -> float32#

(** [_mm_fnmsub_ss]. Computes [-(x * y) - z] without intermediate rounding. *)
val neg_mul_sub : float32# -> float32# -> float32# -> float32#

@@ portable

include module type of struct
  include Ocaml_simd_sse.Float16x8 (** @inline *)
end

(** Identity. *)
val of_float16x16 : float16x16# -> t

(** [_mm_cvtps_ph]. The upper four lanes are zeroed. *)
val of_float32x4_nearest : float32x4# -> t

(** [_mm_cvtps_ph]. The upper four lanes are zeroed. *)
val of_float32x4_current : float32x4# -> t

(** [_mm_cvtps_ph]. The upper four lanes are zeroed. *)
val of_float32x4_down : float32x4# -> t

(** [_mm_cvtps_ph]. The upper four lanes are zeroed. *)
val of_float32x4_up : float32x4# -> t

(** [_mm_cvtps_ph]. The upper four lanes are zeroed. *)
val of_float32x4_toward_zero : float32x4# -> t

(** [_mm256_cvtps_ph] *)
val of_float32x8_nearest : float32x8# -> t

(** [_mm256_cvtps_ph] *)
val of_float32x8_current : float32x8# -> t

(** [_mm256_cvtps_ph] *)
val of_float32x8_down : float32x8# -> t

(** [_mm256_cvtps_ph] *)
val of_float32x8_up : float32x8# -> t

(** [_mm256_cvtps_ph] *)
val of_float32x8_toward_zero : float32x8# -> t

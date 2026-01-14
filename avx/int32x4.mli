@@ portable

include module type of struct
  include Ocaml_simd_sse.Int32x4 (** @inline *)
end

module Raw = Load_store.Vec128.Raw_Int32x4

(** [_mm_permute_ps] Specify permute with ppx_simd: [%permute N, N, N, N], where each N is
    in [0,3]. Exposed as an external so user code can compile without cross-library
    inlining.
    {[
      permute [%permute 3, 2, 1, 0] x = (x.(3), x.(2), x.(1), x.(0))
    ]} *)
external permute
  :  (Ocaml_simd.Permute4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permute_32"
[@@noalloc] [@@builtin]

(** [_mm_permutevar_ps] Each entry of [idx] is interpreted as an integer in [0,3] by
    taking its bottom two bits.
    {[
      permute_by x ~idx:(1, 0, 3, 2) = (x.(1), x.(0), x.(3), x.(2))
    ]} *)
val permute_by : t -> idx:t -> t

(** [_mm_sllv_epi32] *)
val shift_left_logical_by : t -> shift:t -> t

(** [_mm_srlv_epi32] *)
val shift_right_logical_by : t -> shift:t -> t

(** [_mm_srav_epi32] *)
val shift_right_arithmetic_by : t -> shift:t -> t

(** [_mm256_cvtpd_epi32] *)
val of_float64x4 : float64x4# -> t

(** [_mm256_cvttpd_epi32] *)
val of_float64x4_trunc : float64x4# -> t

(** Projection. Truncates to lower 128 bits. *)
val of_int32x8 : int32x8# -> t

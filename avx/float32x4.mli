@@ portable

include module type of struct
  include Ocaml_simd_sse.Float32x4 (** @inline *)
end

module Raw = Load_store.Vec128.Raw_Float32x4

(** [_mm_permute_ps] Specify permute with ppx_simd: [%permute N, N, N, N], where each N is
    in [0,3]. Exposed as an external so user code can compile without cross-library
    inlining. *)
external permute
  :  (Ocaml_simd.Permute4.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permute_32"
[@@noalloc] [@@builtin]

(** [_mm_permutevar_ps] *)
val permute_by : t -> idx:int32x4# -> t

(** [_mm_fmadd_ps]. Computes [x * y + z] without intermediate rounding. *)
val mul_add : t -> t -> t -> t

(** [_mm_fmsub_ps]. Computes [x * y - z] without intermediate rounding. *)
val mul_sub : t -> t -> t -> t

(** [_mm_fnmadd_ps]. Computes [-(x * y) + z] without intermediate rounding. *)
val neg_mul_add : t -> t -> t -> t

(** [_mm_fnmsub_ps]. Computes [-(x * y) - z] without intermediate rounding. *)
val neg_mul_sub : t -> t -> t -> t

(** [_mm_fmaddsub_ps]. Computes the following expression without intermediate rounding.
    {[
      mul_add_sub x y z
      = ( (x.(0) * y.(0)) - z.(0)
        , (x.(1) * y.(1)) + z.(1)
        , (x.(2) * y.(2)) - z.(2)
        , (x.(3) * y.(3)) + z.(3) )
    ]} *)
val mul_add_sub : t -> t -> t -> t

(** [_mm_fmsubadd_ps]. Computes the following expression without intermediate rounding.
    {[
      mul_sub_add x y z
      = ( (x.(0) * y.(0)) + z.(0)
        , (x.(1) * y.(1)) - z.(1)
        , (x.(2) * y.(2)) + z.(2)
        , (x.(3) * y.(3)) - z.(3) )
    ]} *)
val mul_sub_add : t -> t -> t -> t

(** Identity. *)
val of_float32x8 : float32x8# -> t

(** [_mm256_cvtpd_ps] *)
val of_float64x4 : float64x4# -> t

(** [_mm_cvtph_ps] *)
val of_float16x8 : float16x8# -> t

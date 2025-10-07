@@ portable

(** @inline *)
include module type of struct
  include Ocaml_simd_sse.Float32x4 (** @inline *)
end

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

(** [_mm256_cvtpd_ps] *)
val of_float64x4 : float64x4# -> t

(** Identity. *)
val of_float32x8 : float32x8# -> t

@@ portable

include module type of struct
  include Ocaml_simd_sse.Float64x2 (** @inline *)
end

module Raw = Load_store.Vec128.Raw_Float64x2

(** [_mm_permute_pd] Specify permute with ppx_simd: [%permute N, N], where each N is in
    [0,1]. Permutes elements within the vector.

    Example: [%permute 1, 0] swaps the two elements. Exposed as an external so user code
    can compile without cross-library inlining. *)
external permute
  :  (Ocaml_simd.Permute2.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permute_64"
[@@noalloc] [@@builtin]

(** [_mm_permutevar_pd] Variable permute using runtime indices. Each index value controls
    which element to select (only low bit used: 0 or 1).

    Example: if [idx = [1, 0]] and input is [[a, b]], result is [[b, a]]. *)
val permute_by : t -> idx:int64x2# -> t

(** [_mm_fmadd_pd]. Computes [x * y + z] without intermediate rounding. *)
val mul_add : t -> t -> t -> t

(** [_mm_fmsub_pd]. Computes [x * y - z] without intermediate rounding. *)
val mul_sub : t -> t -> t -> t

(** [_mm_fnmadd_pd]. Computes [-(x * y) + z] without intermediate rounding. *)
val neg_mul_add : t -> t -> t -> t

(** [_mm_fnmsub_pd]. Computes [-(x * y) - z] without intermediate rounding. *)
val neg_mul_sub : t -> t -> t -> t

(** [_mm_fmaddsub_pd]. Computes the following expression without intermediate rounding.
    {[
      mul_add_sub x y z = ((x.(0) * y.(0)) - z.(0), (x.(1) * y.(1)) + z.(1))
    ]} *)
val mul_add_sub : t -> t -> t -> t

(** [_mm_fmsubadd_pd]. Computes the following expression without intermediate rounding.
    {[
      mul_sub_add x y z = ((x.(0) * y.(0)) + z.(0), (x.(1) * y.(1)) - z.(1))
    ]} *)
val mul_sub_add : t -> t -> t -> t

(** Identity. Extracts the low 128 bits from a 256-bit float64x4 vector.

    Example: if input is [[a, b, c, d]], result is [[a, b]]. *)
val of_float64x4 : float64x4# -> t

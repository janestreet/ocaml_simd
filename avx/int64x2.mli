@@ portable

include module type of struct
  include Ocaml_simd_sse.Int64x2 (** @inline *)
end

module Raw = Load_store.Vec128.Raw_Int64x2

(** [_mm_permute_pd] Specify permute with ppx_simd: [%permute N, N], where each N is in
    [0,1]. Exposed as an external so user code can compile without cross-library inlining.
    {[
      permute [%permute 1, 0] x = (x.(1), x.(0))
    ]} *)
external permute
  :  (Ocaml_simd.Permute2.t[@untagged])
  -> t
  -> t
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128_permute_64"
[@@noalloc] [@@builtin]

(** [_mm_permutevar_pd] Each lane of [idx] is interpreted as an integer in [0,1] by taking
    its bottom bit.
    {[
      permute_by x ~idx:(1, 0) = (x.(1), x.(0))
    ]} *)
val permute_by : t -> idx:t -> t

(** [_mm_sllv_epi64] *)
val shift_left_logical_by : t -> shift:t -> t

(** [_mm_srlv_epi64] *)
val shift_right_logical_by : t -> shift:t -> t

(** Projection. Truncates to lower 128 bits. *)
val of_int64x4 : int64x4# -> t

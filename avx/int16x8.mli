@@ portable

include module type of struct
  include Ocaml_simd_sse.Int16x8 (** @inline *)
end

(** Identity. *)
val of_int16x16 : int16x16# -> t

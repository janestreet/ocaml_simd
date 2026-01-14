@@ portable

include module type of struct
  include Ocaml_simd_sse.Int8x16 (** @inline *)
end

(** Identity. *)
val of_int8x32 : int8x32# -> t

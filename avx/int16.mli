@@ portable

include module type of struct
  include Ocaml_simd_sse.Int16 (** @inline *)
end

(** Leading zeroes. *)
val count_leading_zeros : int16# -> int16#

(** Trailing zeroes. *)
val count_trailing_zeros : int16# -> int16#

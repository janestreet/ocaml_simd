(* Specified here (instead of Ocaml_simd) so this library can use the constants
   without ppx_simd or x-lib-inlining. *)

module Compare : sig
  type t = private int

  val equal : t
  val less : t
  val less_or_equal : t
  val unordered : t
  val not_equal : t
  val not_less : t
  val not_less_or_equal : t
  val ordered : t
end

module Round : sig
  type t = private int

  (* These also imply _MM_FROUND_NO_EXC *)
  val nearest : t
  val negative_infinity : t
  val positive_infinity : t
  val zero : t
  val current : t
end

@@ portable

open Core

exception Error of string

(** These functions exhibit exactly the same behavior as their [Sexplib] counterparts.

    They raise an [Error] given any input that [Sexplib] would raise a
    [Sexplib.Pre_sexp.Parse_error] on, but the error messages may differ. *)

val of_string : string -> Sexp.t
val of_string_many : string -> Sexp.t list

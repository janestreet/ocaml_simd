@@ portable

open Core

exception Error of string

(** These functions exhibit exactly the same behavior as their [Sexplib] counterparts.

    They raise an [Error] given any input that [Sexplib] would raise a
    [Sexplib.Pre_sexp.Parse_error] on, but the error messages may differ. *)

val of_string : string -> Sexp.t
val of_string_many : string -> Sexp.t list

module Position : sig
  type t = Parsexp.Positions.pos =
    { line : int (** Line number. The first line is [1]. *)
    ; col : int
    (** Column number (bytes from the start of the line). The first column is [0]. *)
    ; offset : int (** Byte offset from the start of the input. The first byte is [0]. *)
    }
  [@@deriving sexp_of]
end

module Range : sig
  type t = Parsexp.Positions.range =
    { start_pos : Position.t (** First character of the sexp. *)
    ; end_pos : Position.t (** One past the last character of the sexp. *)
    }
  [@@deriving sexp_of]
end

(** Like [of_string_many] but also returns the position range of each top-level sexp in
    the input string. *)
val of_string_many_with_positions : string -> (Sexp.t * Range.t) list

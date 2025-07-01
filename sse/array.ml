type ('a : vec128) t = 'a array

external length : 'a t @ local -> int @@ portable = "%array_length"
external get : 'a t @ local -> int -> 'a @@ portable = "%array_safe_get"
external set : 'a t @ local -> int -> 'a -> unit @@ portable = "%array_safe_set"
external unsafe_get : 'a t @ local -> int -> 'a @@ portable = "%array_unsafe_get"
external unsafe_set : 'a t @ local -> int -> 'a -> unit @@ portable = "%array_unsafe_set"

(** The contents of the created array are unspecified. *)
external create_uninitialized
  : ('a : vec128).
  len:int -> 'a t
  @@ portable
  = "ocaml_simd_unreachable" "caml_make_unboxed_vec128_vect"

external unsafe_blit
  : ('a : vec128).
  src:'a t @ local -> src_pos:int -> dst:'a t @ local -> dst_pos:int -> len:int -> unit
  @@ portable
  = "ocaml_simd_unreachable" "caml_unboxed_vec128_vect_blit"

let init ~n ~f =
  if n = 0
  then [||]
  else if n < 0
  then invalid_arg "Array.init"
  else (
    let a = create_uninitialized ~len:n in
    for i = 0 to n - 1 do
      unsafe_set a i (f i)
    done;
    a)
;;

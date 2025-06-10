type ('a : vec128) t = 'a array

external length : local_ 'a t -> int @@ portable = "%array_length"
external get : local_ 'a t -> int -> 'a @@ portable = "%array_safe_get"
external set : local_ 'a t -> int -> 'a -> unit @@ portable = "%array_safe_set"
external unsafe_get : local_ 'a t -> int -> 'a @@ portable = "%array_unsafe_get"
external unsafe_set : local_ 'a t -> int -> 'a -> unit @@ portable = "%array_unsafe_set"

(** The contents of the created array are unspecified. *)
external create_uninitialized
  : ('a : vec128).
  len:int -> 'a t
  @@ portable
  = "ocaml_simd_unreachable" "caml_make_unboxed_vec128_vect"

external unsafe_blit
  : ('a : vec128).
  src:local_ 'a t -> src_pos:int -> dst:local_ 'a t -> dst_pos:int -> len:int -> unit
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

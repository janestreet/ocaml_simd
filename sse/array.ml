open Base

type ('a : vec128) t = 'a array

(** The contents of the created array are unspecified. *)
external unsafe_create_uninitialized
  : ('a : vec128).
  len:int -> 'a t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_make_unboxed_vec128_vect"

external%template unsafe_create_uninitialized
  : ('a : vec128).
  len:int -> 'a t @ local
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_make_local_unboxed_vec128_vect"
[@@noalloc] [@@alloc stack]

let%template[@inline] unsafe_create_uninitialized ~len = exclave_
  (unsafe_create_uninitialized [@alloc stack]) ~len
[@@alloc stack]
;;

external unsafe_blit
  : ('a : vec128).
  src:'a t @ local -> src_pos:int -> dst:'a t @ local -> dst_pos:int -> len:int -> unit
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_unboxed_vec128_vect_blit"

let%template init ~n ~f =
  if n = 0
  then [||]
  else if n < 0
  then invalid_arg "Array.init"
  else (
    (let a = (unsafe_create_uninitialized [@alloc a]) ~len:n in
     for i = 0 to n - 1 do
       Array.unsafe_set a i (f i)
     done;
     a)
    [@exclave_if_stack a])
[@@alloc a = (heap, stack)]
;;

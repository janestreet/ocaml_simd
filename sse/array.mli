@@ portable

(** Basic operations are supported by [Base.Array]. *)
type ('a : vec128) t = 'a array

[%%template:
[@@@alloc.default a @ m = (heap_global, stack_local)]

val init : ('a : vec128). n:int -> f:(int -> 'a) @ local -> 'a t @ m

(** The contents of the created array are unspecified. *)
val unsafe_create_uninitialized : ('a : vec128). len:int -> 'a t @ m
[@@zero_alloc_if_stack a]]

external unsafe_blit
  : ('a : vec128).
  src:'a t @ local -> src_pos:int -> dst:'a t @ local -> dst_pos:int -> len:int -> unit
  = "ocaml_simd_sse_unreachable" "caml_unboxed_vec128_vect_blit"

@@ portable

type ('a : vec128) t = 'a array

val init : ('a : vec128). n:int -> f:(int -> 'a) @ local -> 'a t
external length : 'a t @ local -> int = "%array_length"

(** To index by unboxed integers, use [{Int32,Int64,Nativeint}_u.Array_index.get]. *)
external get : 'a t @ local -> int -> 'a = "%array_safe_get"

(** To index by unboxed integers, use [{Int32,Int64,Nativeint}_u.Array_index.set]. *)
external set : 'a t @ local -> int -> 'a -> unit = "%array_safe_set"

(** To index by unboxed integers, use [{Int32,Int64,Nativeint}_u.Array_index.unsafe_get]. *)
external unsafe_get : 'a t @ local -> int -> 'a = "%array_unsafe_get"

(** To index by unboxed integers, use [{Int32,Int64,Nativeint}_u.Array_index.unsafe_set]. *)
external unsafe_set : 'a t @ local -> int -> 'a -> unit = "%array_unsafe_set"

(** The contents of the created array are unspecified. *)
external create_uninitialized
  : ('a : vec128).
  len:int -> 'a t
  = "ocaml_simd_unreachable" "caml_make_unboxed_vec128_vect"

external unsafe_blit
  : ('a : vec128).
  src:'a t @ local -> src_pos:int -> dst:'a t @ local -> dst_pos:int -> len:int -> unit
  = "ocaml_simd_unreachable" "caml_unboxed_vec128_vect_blit"

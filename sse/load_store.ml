open Stdlib

type bigstring = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

module type String = sig @@ portable
  type t : vec128

  val get : local_ string -> byte:int -> t
  val unsafe_get : local_ string -> byte:int -> t
end

module type Bytes = sig @@ portable
  type t : vec128

  val get : local_ bytes -> byte:int -> t
  val unsafe_get : local_ bytes -> byte:int -> t
  val set : local_ bytes -> byte:int -> t -> unit
  val unsafe_set : local_ bytes -> byte:int -> t -> unit
end

module type Bigstring = sig @@ portable
  type t : vec128

  val unaligned_get : local_ bigstring -> byte:int -> t
  val aligned_get : local_ bigstring -> byte:int -> t
  val unsafe_unaligned_get : local_ bigstring -> byte:int -> t
  val unsafe_aligned_get : local_ bigstring -> byte:int -> t
  val unaligned_set : local_ bigstring -> byte:int -> t -> unit
  val aligned_set : local_ bigstring -> byte:int -> t -> unit
  val unsafe_unaligned_set : local_ bigstring -> byte:int -> t -> unit
  val unsafe_aligned_set : local_ bigstring -> byte:int -> t -> unit
end

(* We can functorize instead of duplicating all the intrinsics because
   the externals are not [@@unboxed]. *)

module String (T : sig
    (** Must be one of [int8x16,int16x8,int32x4,int64x2,float32x4,float64x2]. *)
    type t : vec128
  end) =
struct
  external get
    :  (string[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_string_getu128#"

  external unsafe_get
    :  (string[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_string_getu128u#"
end

module Bytes (T : sig
    (** Must be one of [int8x16,int16x8,int32x4,int64x2,float32x4,float64x2]. *)
    type t : vec128
  end) =
struct
  external get
    :  (bytes[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bytes_getu128#"

  external unsafe_get
    :  (bytes[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bytes_getu128u#"

  external set
    :  (bytes[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bytes_setu128#"

  external unsafe_set
    :  (bytes[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bytes_setu128u#"
end

module Bigstring (T : sig
    (** Must be one of [int8x16,int16x8,int32x4,int64x2,float32x4,float64x2]. *)
    type t : vec128
  end) =
struct
  external unaligned_get
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_getu128#"

  external unsafe_unaligned_get
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_getu128u#"

  external aligned_get
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_geta128#"

  external unsafe_aligned_get
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_geta128u#"

  external unaligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_setu128#"

  external unsafe_unaligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_setu128u#"

  external aligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_seta128#"

  external unsafe_aligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_seta128u#"
end

module Float_array = struct
  type t = float64x2#

  external get : float array -> idx:int -> t @@ portable = "%caml_float_array_get128#"

  external unsafe_get
    :  float array
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get128u#"

  external set
    :  float array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_float_array_set128#"

  external unsafe_set
    :  float array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_float_array_set128u#"
end

module Floatarray = struct
  type t = float64x2#

  external get : floatarray -> idx:int -> t @@ portable = "%caml_floatarray_get128#"

  external unsafe_get
    :  floatarray
    -> idx:int
    -> t
    @@ portable
    = "%caml_floatarray_get128u#"

  external set
    :  floatarray
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_floatarray_set128#"

  external unsafe_set
    :  floatarray
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_floatarray_set128u#"
end

module Float_iarray = struct
  type t = float64x2#

  external get
    :  (float iarray[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get128#"

  external unsafe_get
    :  (float iarray[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get128u#"
end

module Immediate_array = struct
  module I = Int64x2_internal

  type t = int64x2#

  let one () = I.const1 #1L

  external get_tagged
    : ('a : immediate64).
    'a array -> idx:int -> t
    @@ portable
    = "%caml_int_array_get128#"

  external unsafe_get_tagged
    : ('a : immediate64).
    'a array -> idx:int -> t
    @@ portable
    = "%caml_int_array_get128u#"

  let get_and_untag arr ~idx =
    let v = get_tagged arr ~idx in
    I.srli 1 v
  ;;

  let unsafe_get_and_untag arr ~idx =
    let v = unsafe_get_tagged arr ~idx in
    I.srli 1 v
  ;;

  external set_raw
    : ('a : immediate64).
    'a array -> idx:int -> t -> unit
    @@ portable
    = "%caml_int_array_set128#"

  external unsafe_set_raw
    : ('a : immediate64).
    'a array -> idx:int -> t -> unit
    @@ portable
    = "%caml_int_array_set128u#"

  let set_tagged arr ~idx v =
    if I.(slli 63 v |> movemask_64) <> 0b11
    then raise (Invalid_argument "Int64x2 contained an untagged value.");
    set_raw arr ~idx v
  ;;

  let unsafe_set_tagged arr ~idx v = unsafe_set_raw arr ~idx v

  let tag_and_set arr ~idx v =
    if I.movemask_64 v <> 0
    then raise (Invalid_argument "Int64x2 contained an untaggable value.");
    let v = I.slli 1 v in
    let v = I.or_ v (one ()) in
    set_raw arr ~idx v
  ;;

  let unsafe_tag_and_set arr ~idx v =
    let v = I.slli 1 v in
    let v = I.or_ v (one ()) in
    unsafe_set_tagged arr ~idx v
  ;;
end

module Immediate_iarray = struct
  module I = Int64x2_internal

  type t = int64x2#

  external get_tagged
    : ('a : immediate64).
    ('a iarray[@local_opt]) -> idx:int -> t
    @@ portable
    = "%caml_int_array_get128#"

  external unsafe_get_tagged
    : ('a : immediate64).
    ('a iarray[@local_opt]) -> idx:int -> t
    @@ portable
    = "%caml_int_array_get128u#"

  let get_and_untag (local_ arr) ~idx =
    let v = get_tagged arr ~idx in
    I.srli 1 v
  ;;

  let unsafe_get_and_untag (local_ arr) ~idx =
    let v = unsafe_get_tagged arr ~idx in
    I.srli 1 v
  ;;
end

module Float_u_array = struct
  type t = float64x2#

  external get
    :  float# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float_array_get128#"

  external unsafe_get
    :  float# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float_array_get128u#"

  external set
    :  float# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float_array_set128#"

  external unsafe_set
    :  float# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float_array_set128u#"
end

module Float32_u_array = struct
  type t = float32x4#

  external get
    :  float32# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float32_array_get128#"

  external unsafe_get
    :  float32# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float32_array_get128u#"

  external set
    :  float32# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float32_array_set128#"

  external unsafe_set
    :  float32# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float32_array_set128u#"
end

module Int64_u_array = struct
  type t = int64x2#

  external get
    :  int64# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int64_array_get128#"

  external unsafe_get
    :  int64# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int64_array_get128u#"

  external set
    :  int64# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int64_array_set128#"

  external unsafe_set
    :  int64# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int64_array_set128u#"
end

module Nativeint_u_array = struct
  type t = int64x2#

  external get
    :  nativeint# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_nativeint_array_get128#"

  external unsafe_get
    :  nativeint# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_nativeint_array_get128u#"

  external set
    :  nativeint# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_nativeint_array_set128#"

  external unsafe_set
    :  nativeint# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_nativeint_array_set128u#"
end

module Int32_u_array = struct
  type t = int32x4#

  external get
    :  int32# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int32_array_get128#"

  external unsafe_get
    :  int32# array
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int32_array_get128u#"

  external set
    :  int32# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int32_array_set128#"

  external unsafe_set
    :  int32# array
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int32_array_set128u#"
end

module String_Int8x16 = String (struct
    type nonrec t = int8x16#
  end)

module String_Int16x8 = String (struct
    type nonrec t = int16x8#
  end)

module String_Int32x4 = String (struct
    type nonrec t = int32x4#
  end)

module String_Int64x2 = String (struct
    type nonrec t = int64x2#
  end)

module String_Float32x4 = String (struct
    type nonrec t = float32x4#
  end)

module String_Float64x2 = String (struct
    type nonrec t = float64x2#
  end)

module Bytes_Int8x16 = Bytes (struct
    type nonrec t = int8x16#
  end)

module Bytes_Int16x8 = Bytes (struct
    type nonrec t = int16x8#
  end)

module Bytes_Int32x4 = Bytes (struct
    type nonrec t = int32x4#
  end)

module Bytes_Int64x2 = Bytes (struct
    type nonrec t = int64x2#
  end)

module Bytes_Float32x4 = Bytes (struct
    type nonrec t = float32x4#
  end)

module Bytes_Float64x2 = Bytes (struct
    type nonrec t = float64x2#
  end)

module Bigstring_Int8x16 = Bigstring (struct
    type nonrec t = int8x16#
  end)

module Bigstring_Int16x8 = Bigstring (struct
    type nonrec t = int16x8#
  end)

module Bigstring_Int32x4 = Bigstring (struct
    type nonrec t = int32x4#
  end)

module Bigstring_Int64x2 = Bigstring (struct
    type nonrec t = int64x2#
  end)

module Bigstring_Float32x4 = Bigstring (struct
    type nonrec t = float32x4#
  end)

module Bigstring_Float64x2 = Bigstring (struct
    type nonrec t = float64x2#
  end)

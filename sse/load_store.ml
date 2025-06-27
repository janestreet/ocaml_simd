open Stdlib
include Load_store_intf

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

  module Int32_u = struct
    external get
      :  (string[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_string_getu128#_indexed_by_int32#"

    external unsafe_get
      :  (string[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_string_getu128u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (string[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_string_getu128#_indexed_by_int64#"

    external unsafe_get
      :  (string[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_string_getu128u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (string[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_string_getu128#_indexed_by_nativeint#"

    external unsafe_get
      :  (string[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_string_getu128u#_indexed_by_nativeint#"
  end
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

  module Int32_u = struct
    external get
      :  (bytes[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bytes_getu128#_indexed_by_int32#"

    external unsafe_get
      :  (bytes[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bytes_getu128u#_indexed_by_int32#"

    external set
      :  (bytes[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu128#_indexed_by_int32#"

    external unsafe_set
      :  (bytes[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu128u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (bytes[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bytes_getu128#_indexed_by_int64#"

    external unsafe_get
      :  (bytes[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bytes_getu128u#_indexed_by_int64#"

    external set
      :  (bytes[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu128#_indexed_by_int64#"

    external unsafe_set
      :  (bytes[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu128u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (bytes[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bytes_getu128#_indexed_by_nativeint#"

    external unsafe_get
      :  (bytes[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bytes_getu128u#_indexed_by_nativeint#"

    external set
      :  (bytes[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu128#_indexed_by_nativeint#"

    external unsafe_set
      :  (bytes[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu128u#_indexed_by_nativeint#"
  end
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

  module Int32_u = struct
    external unaligned_get
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu128#_indexed_by_int32#"

    external unsafe_unaligned_get
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu128u#_indexed_by_int32#"

    external aligned_get
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta128#_indexed_by_int32#"

    external unsafe_aligned_get
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta128u#_indexed_by_int32#"

    external unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu128#_indexed_by_int32#"

    external unsafe_unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu128u#_indexed_by_int32#"

    external aligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta128#_indexed_by_int32#"

    external unsafe_aligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta128u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external unaligned_get
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu128#_indexed_by_int64#"

    external unsafe_unaligned_get
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu128u#_indexed_by_int64#"

    external aligned_get
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta128#_indexed_by_int64#"

    external unsafe_aligned_get
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta128u#_indexed_by_int64#"

    external unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu128#_indexed_by_int64#"

    external unsafe_unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu128u#_indexed_by_int64#"

    external aligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta128#_indexed_by_int64#"

    external unsafe_aligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta128u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external unaligned_get
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu128#_indexed_by_nativeint#"

    external unsafe_unaligned_get
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu128u#_indexed_by_nativeint#"

    external aligned_get
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta128#_indexed_by_nativeint#"

    external unsafe_aligned_get
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta128u#_indexed_by_nativeint#"

    external unaligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu128#_indexed_by_nativeint#"

    external unsafe_unaligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu128u#_indexed_by_nativeint#"

    external aligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta128#_indexed_by_nativeint#"

    external unsafe_aligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta128u#_indexed_by_nativeint#"
  end
end

module Float_array = struct
  type t = float64x2#

  external get
    :  (float array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get128#"

  external unsafe_get
    :  (float array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get128u#"

  external set
    :  (float array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_float_array_set128#"

  external unsafe_set
    :  (float array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_float_array_set128u#"
end

module Floatarray = struct
  type t = float64x2#

  external get
    :  (floatarray[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_floatarray_get128#"

  external unsafe_get
    :  (floatarray[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_floatarray_get128u#"

  external set
    :  (floatarray[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_floatarray_set128#"

  external unsafe_set
    :  (floatarray[@local_opt])
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
    ('a array[@local_opt]) -> idx:int -> t
    @@ portable
    = "%caml_int_array_get128#"

  external unsafe_get_tagged
    : ('a : immediate64).
    ('a array[@local_opt]) -> idx:int -> t
    @@ portable
    = "%caml_int_array_get128u#"

  let get_and_untag arr ~idx =
    let v = get_tagged arr ~idx in
    I.srli #1L v
  ;;

  let unsafe_get_and_untag arr ~idx =
    let v = unsafe_get_tagged arr ~idx in
    I.srli #1L v
  ;;

  external set_raw
    : ('a : immediate64).
    ('a array[@local_opt]) -> idx:int -> t -> unit
    @@ portable
    = "%caml_int_array_set128#"

  external unsafe_set_raw
    : ('a : immediate64).
    ('a array[@local_opt]) -> idx:int -> t -> unit
    @@ portable
    = "%caml_int_array_set128u#"

  let set_tagged arr ~idx v =
    if not (Int64_u.equal I.(slli #63L v |> movemask_64) #0b11L)
    then raise (Invalid_argument "Int64x2 contained an untagged value.");
    set_raw arr ~idx v
  ;;

  let unsafe_set_tagged arr ~idx v = unsafe_set_raw arr ~idx v

  let tag_and_set arr ~idx v =
    if not (Int64_u.equal (I.movemask_64 v) #0L)
    then raise (Invalid_argument "Int64x2 contained an untaggable value.");
    let v = I.slli #1L v in
    let v = I.or_ v (one ()) in
    set_raw arr ~idx v
  ;;

  let unsafe_tag_and_set arr ~idx v =
    let v = I.slli #1L v in
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
    I.srli #1L v
  ;;

  let unsafe_get_and_untag (local_ arr) ~idx =
    let v = unsafe_get_tagged arr ~idx in
    I.srli #1L v
  ;;
end

module Float_u_array = struct
  type t = float64x2#

  external get
    :  (float# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float_array_get128#"

  external unsafe_get
    :  (float# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float_array_get128u#"

  external set
    :  (float# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float_array_set128#"

  external unsafe_set
    :  (float# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float_array_set128u#"
end

module Float32_u_array = struct
  type t = float32x4#

  external get
    :  (float32# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float32_array_get128#"

  external unsafe_get
    :  (float32# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float32_array_get128u#"

  external set
    :  (float32# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float32_array_set128#"

  external unsafe_set
    :  (float32# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float32_array_set128u#"
end

module Int64_u_array = struct
  type t = int64x2#

  external get
    :  (int64# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int64_array_get128#"

  external unsafe_get
    :  (int64# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int64_array_get128u#"

  external set
    :  (int64# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int64_array_set128#"

  external unsafe_set
    :  (int64# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int64_array_set128u#"
end

module Nativeint_u_array = struct
  type t = int64x2#

  external get
    :  (nativeint# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_nativeint_array_get128#"

  external unsafe_get
    :  (nativeint# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_nativeint_array_get128u#"

  external set
    :  (nativeint# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_nativeint_array_set128#"

  external unsafe_set
    :  (nativeint# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_nativeint_array_set128u#"
end

module Int32_u_array = struct
  type t = int32x4#

  external get
    :  (int32# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int32_array_get128#"

  external unsafe_get
    :  (int32# array[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int32_array_get128u#"

  external set
    :  (int32# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int32_array_set128#"

  external unsafe_set
    :  (int32# array[@local_opt])
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

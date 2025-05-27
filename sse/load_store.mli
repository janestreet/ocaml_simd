open Stdlib

type bigstring = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

module type String = sig
  (** [t] is one of the 16-byte vector types. *)
  type t : vec128

  (** Load 16 bytes from a [string] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val get : local_ string -> byte:int -> t

  (** Load 16 bytes from a [string] at an arbitrary byte offset. Does not validate safety. *)
  val unsafe_get : local_ string -> byte:int -> t
end

module type Bytes = sig
  (** [t] is one of the 16-byte vector types. *)
  type t : vec128

  (** Load 16 bytes from a [bytes] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val get : local_ bytes -> byte:int -> t

  (** Load 16 bytes from a [bytes] at an arbitrary byte offset. Does not validate safety. *)
  val unsafe_get : local_ bytes -> byte:int -> t

  (** Write 16 bytes to a [bytes] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val set : local_ bytes -> byte:int -> t -> unit

  (** Write 16 bytes to a [bytes] at an arbitrary byte offset. Does not validate safety. *)
  val unsafe_set : local_ bytes -> byte:int -> t -> unit
end

module type Bigstring = sig
  (** [t] is one of the 16-byte vector types. *)
  type t : vec128

  (** Note that the backing array of a bigstring is allocated by `malloc`, so is always
      16-byte aligned. Therefore, it is valid to use aligned-load/store instructions at
      16-byte intervals in the bigstring. *)

  (** Load 16 bytes from a [bigstring] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val unaligned_get : local_ bigstring -> byte:int -> t

  (** Load 16 bytes from a [bigstring] at a 16-aligned byte offset.

      @raise Invalid_argument if the computed address is not 16-byte aligned.
      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val aligned_get : local_ bigstring -> byte:int -> t

  (** Load 16 bytes from a [bigstring] at an arbitrary byte offset. Does not validate
      safety. *)
  val unsafe_unaligned_get : local_ bigstring -> byte:int -> t

  (** Load 16 bytes from a [bigstring] at a 16-aligned byte offset. Does not validate
      safety. *)
  val unsafe_aligned_get : local_ bigstring -> byte:int -> t

  (** Write 16 bytes to a [bigstring] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val unaligned_set : local_ bigstring -> byte:int -> t -> unit

  (** Write 16 bytes to a [bigstring] at a 16-aligned byte offset.

      @raise Invalid_argument if the computed address is not 16-byte aligned.
      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val aligned_set : local_ bigstring -> byte:int -> t -> unit

  (** Write 16 bytes to a [bigstring] at an arbitrary byte offset. Does not validate
      safety. *)
  val unsafe_unaligned_set : local_ bigstring -> byte:int -> t -> unit

  (** Write 16 bytes to a [bigstring] at a 16-aligned byte offset. Does not validate
      safety. *)
  val unsafe_aligned_set : local_ bigstring -> byte:int -> t -> unit
end

module Float_array : sig
  type t = float64x2#

  (** Load two floats from a [float array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : float array -> idx:int -> t

  (** Load two floats from a [float array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_get : float array -> idx:int -> t

  (** Store two floats to a [float array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : float array -> idx:int -> t -> unit

  (** Store two floats to a [float array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_set : float array -> idx:int -> t -> unit
end

module Floatarray : sig
  type t = float64x2#

  (** Load two floats from a [floatarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : floatarray -> idx:int -> t

  (** Load two floats from a [floatarray] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_get : floatarray -> idx:int -> t

  (** Store two floats to a [floatarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : floatarray -> idx:int -> t -> unit

  (** Store two floats to a [floatarray] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_set : floatarray -> idx:int -> t -> unit
end

module Float_iarray : sig
  type t = float64x2#

  (** Load two floats from a [float iarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : local_ float iarray -> idx:int -> t

  (** Load two floats from a [float iarray] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_get : local_ float iarray -> idx:int -> t
end

module Immediate_array : sig
  type t = int64x2#

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_tagged : ('a : immediate64). 'a array -> idx:int -> t

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values. Does not validate safety. *)
  val unsafe_get_tagged : ('a : immediate64). 'a array -> idx:int -> t

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_and_untag : ('a : immediate64). 'a array -> idx:int -> t

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values. Does not validate safety. *)
  val unsafe_get_and_untag : ('a : immediate64). 'a array -> idx:int -> t

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking.
      @raise Invalid_argument if either int64's top bit is set. *)
  val tag_and_set : ('a : immediate64). 'a array -> idx:int -> t -> unit

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking.
      @raise Invalid_argument if either int64's bottom bit is not set. *)
  val set_tagged : ('a : immediate64). 'a array -> idx:int -> t -> unit

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _untagged_ 63-bit values. Does not validate safety. *)
  val unsafe_tag_and_set : ('a : immediate64). 'a array -> idx:int -> t -> unit

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _tagged_ 64-bit values. Does not validate safety. *)
  val unsafe_set_tagged : ('a : immediate64). 'a array -> idx:int -> t -> unit
end

module Immediate_iarray : sig
  type t = int64x2#

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_tagged : ('a : immediate64). local_ 'a iarray -> idx:int -> t

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values. Does not validate safety. *)
  val unsafe_get_tagged : ('a : immediate64). local_ 'a iarray -> idx:int -> t

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_and_untag : ('a : immediate64). local_ 'a iarray -> idx:int -> t

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values. Does not validate safety. *)
  val unsafe_get_and_untag : ('a : immediate64). local_ 'a iarray -> idx:int -> t
end

module Float_u_array : sig
  type t = float64x2#

  (** Load two floats from a [float# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : float# array -> idx:int -> t

  (** Load two floats from a [float# array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_get : float# array -> idx:int -> t

  (** Store two floats to a [float# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : float# array -> idx:int -> t -> unit

  (** Store two floats to a [float# array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_set : float# array -> idx:int -> t -> unit
end

module Float32_u_array : sig
  type t = float32x4#

  (** Load four float32s from a [float32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : float32# array -> idx:int -> t

  (** Load four float32s from a [float32# array] at an arbitrary (unaligned) index. Does
      not validate safety. *)
  val unsafe_get : float32# array -> idx:int -> t

  (** Store four float32s to a [float32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : float32# array -> idx:int -> t -> unit

  (** Store four float32s to a [float32# array] at an arbitrary (unaligned) index. Does
      not validate safety. *)
  val unsafe_set : float32# array -> idx:int -> t -> unit
end

module Int64_u_array : sig
  type t = int64x2#

  (** Load two int64s from a [int64# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : int64# array -> idx:int -> t

  (** Load two int64s from a [int64# array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_get : int64# array -> idx:int -> t

  (** Store two int64s to a [int64# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : int64# array -> idx:int -> t -> unit

  (** Store two int64s to a [int64# array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_set : int64# array -> idx:int -> t -> unit
end

module Nativeint_u_array : sig
  (** SIMD is only available in 64-bit native builds, so nativeint is 64 bits. *)
  type t = int64x2#

  (** Load two int64s from a [nativeint# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : nativeint# array -> idx:int -> t

  (** Load two int64s from a [nativeint# array] at an arbitrary (unaligned) index. Does
      not validate safety. *)
  val unsafe_get : nativeint# array -> idx:int -> t

  (** Store two int64s to a [nativeint# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : nativeint# array -> idx:int -> t -> unit

  (** Store two int64s to a [nativeint# array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_set : nativeint# array -> idx:int -> t -> unit
end

module Int32_u_array : sig
  type t = int32x4#

  (** Load four int32s from a [int32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : int32# array -> idx:int -> t

  (** Load four int32s from a [int32# array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_get : int32# array -> idx:int -> t

  (** Store four int32s to a [int32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : int32# array -> idx:int -> t -> unit

  (** Store four int32s to a [int32# array] at an arbitrary (unaligned) index. Does not
      validate safety. *)
  val unsafe_set : int32# array -> idx:int -> t -> unit
end

module String_Int8x16 : String with type t := int8x16#
module String_Int16x8 : String with type t := int16x8#
module String_Int32x4 : String with type t := int32x4#
module String_Int64x2 : String with type t := int64x2#
module String_Float32x4 : String with type t := float32x4#
module String_Float64x2 : String with type t := float64x2#
module Bytes_Int8x16 : Bytes with type t := int8x16#
module Bytes_Int16x8 : Bytes with type t := int16x8#
module Bytes_Int32x4 : Bytes with type t := int32x4#
module Bytes_Int64x2 : Bytes with type t := int64x2#
module Bytes_Float32x4 : Bytes with type t := float32x4#
module Bytes_Float64x2 : Bytes with type t := float64x2#
module Bigstring_Int8x16 : Bigstring with type t := int8x16#
module Bigstring_Int16x8 : Bigstring with type t := int16x8#
module Bigstring_Int32x4 : Bigstring with type t := int32x4#
module Bigstring_Int64x2 : Bigstring with type t := int64x2#
module Bigstring_Float32x4 : Bigstring with type t := float32x4#
module Bigstring_Float64x2 : Bigstring with type t := float64x2#

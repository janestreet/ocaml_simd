open Stdlib

module type Raw = sig @@ portable
  type t : vec128

  (** Load 16 bytes from an arbitrary address encoded as a [nativeint#]. *)
  val unaligned_load : nativeint# -> t

  (** Store 16 bytes to an arbitrary address encoded as a [nativeint#]. *)
  val unaligned_store : nativeint# -> t -> unit

  (** Load 16 bytes from a 16-byte-aligned address encoded as a [nativeint#]. Does not
      validate alignment. *)
  val aligned_load : nativeint# -> t

  (** Store 16 bytes to a 16-byte-aligned address encoded as a [nativeint#]. Does not
      validate alignment. *)
  val aligned_store : nativeint# -> t -> unit

  (** Non-temporally load 16 bytes from a 16-byte-aligned address encoded as a
      [nativeint#]. Does not validate alignment. The address will not be cached. *)
  val aligned_load_uncached : nativeint# -> t

  (** Non-temporally store 16 bytes to a 16-byte-aligned address encoded as a
      [nativeint#]. Does not validate alignment. The address will not be cached. *)
  val aligned_store_uncached : nativeint# -> t -> unit
end

module type Raw64 = sig @@ portable
  type t : vec128

  (** Load the lower 8-byte lane from an arbitrary address encoded as a [nativeint#]. \
      The upper 8-byte lane is undefined. *)
  val load_low : nativeint# -> t

  (** Load the lower 8-byte lane from an arbitrary address encoded as a [nativeint#]. \
      The upper 8-byte lane is zeroed. *)
  val load_low_zero_high : nativeint# -> t

  (** Load the lower 8-byte lane from an arbitrary address encoded as a [nativeint#]. \
      The upper 8-byte lane is copied from the input vector. *)
  val load_low_copy_high : nativeint# -> t -> t

  (** Load the upper 8-byte lane from an arbitrary address encoded as a [nativeint#]. \
      The lower 8-byte lane is copied from the input vector. *)
  val load_high_copy_low : nativeint# -> t -> t

  (** Load 8 bytes from an arbitrary address encoded as a [nativeint#] into both lanes. *)
  val broadcast : nativeint# -> t

  (** Store the lower 8-byte lane to an arbitrary address encoded as a [nativeint#]. *)
  val store_low : nativeint# -> t -> unit
end

module type Raw32 = sig @@ portable
  type t : vec128

  (** Load the lower 4-byte lane from an arbitrary address encoded as a [nativeint#]. \
      The upper lanes are undefined. *)
  val load_low : nativeint# -> t

  (** Load the lower 4-byte lane from an arbitrary address encoded as a [nativeint#]. \
      The upper lanes are zeroed. *)
  val load_low_zero_high : nativeint# -> t

  (** Store the lower 4-byte lane to an arbitrary address encoded as a [nativeint#]. *)
  val store_low : nativeint# -> t -> unit
end

module type Raw8 = sig @@ portable
  type t : vec128

  (** Store 16 bytes to an arbitrary address encoded as a [nativeint#] subject to a mask.
      If the upper bit of each 1-byte mask lane is zero, the corresponding input lane will
      not be written to memory. However, page faults/memory exceptions may still be
      triggered as if the full 16 bytes were written. *)
  val store_masked : nativeint# -> t -> mask:int8x16# -> unit
end

module type String_accessors = sig @@ portable
  type t : vec128
  type index : any

  (** Load 16 bytes from a [string] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val get : string @ local -> byte:index -> t

  (** Load 16 bytes from a [string] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_get : string @ local -> byte:index -> t
end

module type Bytes_accessors = sig @@ portable
  type t : vec128
  type index : any

  (** Load 16 bytes from a [bytes] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val get : bytes @ local read -> byte:index -> t

  (** Load 16 bytes from a [bytes] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_get : bytes @ local read -> byte:index -> t

  (** Write 16 bytes to a [bytes] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val set : bytes @ local -> byte:index -> t -> unit

  (** Write 16 bytes to a [bytes] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_set : bytes @ local -> byte:index -> t -> unit
end

module type Bigstring_accessors = sig @@ portable
  type bigstring :=
    (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

  type t : vec128
  type index : any

  (** By default, the backing array of a bigstring is allocated by `malloc`, so is always
      16-byte aligned. Therefore, it is valid to use aligned-load/store instructions at
      16-byte intervals in the bigstring. *)

  (** Load 16 bytes from a [bigstring] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val unaligned_get : bigstring @ local read -> byte:index -> t

  (** Load 16 bytes from a [bigstring] at a 16-aligned byte offset.

      @raise Invalid_argument if the computed address is not 16-byte aligned.
      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val aligned_get : bigstring @ local read -> byte:index -> t

  (** Load 16 bytes from a [bigstring] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_unaligned_get : bigstring @ local read -> byte:index -> t

  (** Load 16 bytes from a [bigstring] at a 16-aligned byte offset. Does not check bounds
      or alignment. *)
  val unsafe_aligned_get : bigstring @ local read -> byte:index -> t

  (** Write 16 bytes to a [bigstring] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val unaligned_set : bigstring @ local -> byte:index -> t -> unit

  (** Write 16 bytes to a [bigstring] at a 16-aligned byte offset.

      @raise Invalid_argument if the computed address is not 16-byte aligned.
      @raise Invalid_argument if [byte..byte+16] fails bounds checking. *)
  val aligned_set : bigstring @ local -> byte:index -> t -> unit

  (** Write 16 bytes to a [bigstring] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_unaligned_set : bigstring @ local -> byte:index -> t -> unit

  (** Write 16 bytes to a [bigstring] at a 16-aligned byte offset. Does not check bounds
      or alignment. *)
  val unsafe_aligned_set : bigstring @ local -> byte:index -> t -> unit
end

module type Float_array_accessors = sig @@ portable
  type index : any

  (** Load two floats from a [float array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : float array @ local read -> idx:index -> float64x2#

  (** Load two floats from a [float array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : float array @ local read -> idx:index -> float64x2#

  (** Store two floats to a [float array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : float array @ local -> idx:index -> float64x2# -> unit

  (** Store two floats to a [float array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : float array @ local -> idx:index -> float64x2# -> unit
end

module type Floatarray_accessors = sig @@ portable
  type index : any

  (** Load two floats from a [floatarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : floatarray @ local read -> idx:index -> float64x2#

  (** Load two floats from a [floatarray] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : floatarray @ local read -> idx:index -> float64x2#

  (** Store two floats to a [floatarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : floatarray @ local -> idx:index -> float64x2# -> unit

  (** Store two floats to a [floatarray] at an arbitrary (unaligned) index. Does not check
      bounds. *)
  val unsafe_set : floatarray @ local -> idx:index -> float64x2# -> unit
end

module type Float_iarray_accessors = sig @@ portable
  type index : any

  (** Load two floats from a [float iarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : float iarray @ local -> idx:index -> float64x2#

  (** Load two floats from a [float iarray] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : float iarray @ local -> idx:index -> float64x2#
end

module type Unsafe_immediate_array_accessors = sig @@ portable
  type index : any

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_tagged : ('a : immediate64). 'a array @ local read -> idx:index -> int64x2#

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values. Does not check bounds. *)
  val unsafe_get_tagged
    : ('a : immediate64).
    'a array @ local read -> idx:index -> int64x2#

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_and_untag : ('a : immediate64). 'a array @ local read -> idx:index -> int64x2#

  (** Load two immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values. Does not check bounds. *)
  val unsafe_get_and_untag
    : ('a : immediate64).
    'a array @ local read -> idx:index -> int64x2#

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking.
      @raise Invalid_argument if either int64's top bit is set. *)
  val tag_and_set : ('a : immediate64). 'a array @ local -> idx:index -> int64x2# -> unit

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking.
      @raise Invalid_argument if either int64's bottom bit is not set. *)
  val set_tagged : ('a : immediate64). 'a array @ local -> idx:index -> int64x2# -> unit

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _untagged_ 63-bit values. Does not check bounds or ranges. *)
  val unsafe_tag_and_set
    : ('a : immediate64).
    'a array @ local -> idx:index -> int64x2# -> unit

  (** Store two immediates to an array at an arbitrary (unaligned) index. The given vector
      must contain two _tagged_ 64-bit values. Does not check bounds or tags. *)
  val unsafe_set_tagged
    : ('a : immediate64).
    'a array @ local -> idx:index -> int64x2# -> unit
end

module type Unsafe_immediate_iarray_accessors = sig @@ portable
  type index : any

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_tagged : ('a : immediate64). 'a iarray @ local -> idx:index -> int64x2#

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _tagged_ 64-bit values. Does not check bounds. *)
  val unsafe_get_tagged : ('a : immediate64). 'a iarray @ local -> idx:index -> int64x2#

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get_and_untag : ('a : immediate64). 'a iarray @ local -> idx:index -> int64x2#

  (** Load two immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains two _untagged_ 63-bit values. Does not check bounds. *)
  val unsafe_get_and_untag
    : ('a : immediate64).
    'a iarray @ local -> idx:index -> int64x2#
end

module type Float_u_array_accessors = sig @@ portable
  type index : any

  (** Load two floats from a [float# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : float# array @ local read -> idx:index -> float64x2#

  (** Load two floats from a [float# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : float# array @ local -> idx:index -> float64x2#

  (** Store two floats to a [float# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : float# array @ local -> idx:index -> float64x2# -> unit

  (** Store two floats to a [float# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : float# array @ local -> idx:index -> float64x2# -> unit
end

module type Float32_u_array_accessors = sig @@ portable
  type index : any

  (** Load four float32s from a [float32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : float32# array @ local read -> idx:index -> float32x4#

  (** Load four float32s from a [float32# array] at an arbitrary (unaligned) index. Does
      not check bounds. *)
  val unsafe_get : float32# array @ local read -> idx:index -> float32x4#

  (** Store four float32s to a [float32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : float32# array @ local -> idx:index -> float32x4# -> unit

  (** Store four float32s to a [float32# array] at an arbitrary (unaligned) index. Does
      not check bounds. *)
  val unsafe_set : float32# array @ local -> idx:index -> float32x4# -> unit
end

module type Int64_u_array_accessors = sig @@ portable
  type index : any

  (** Load two int64s from a [int64# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : int64# array @ local read -> idx:index -> int64x2#

  (** Load two int64s from a [int64# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : int64# array @ local read -> idx:index -> int64x2#

  (** Store two int64s to a [int64# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : int64# array @ local -> idx:index -> int64x2# -> unit

  (** Store two int64s to a [int64# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : int64# array @ local -> idx:index -> int64x2# -> unit
end

(** SIMD is only available in 64-bit native builds, so nativeint is 64 bits. *)
module type Nativeint_u_array_accessors = sig @@ portable
  type index : any

  (** Load two int64s from a [nativeint# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val get : nativeint# array @ local read -> idx:index -> int64x2#

  (** Load two int64s from a [nativeint# array] at an arbitrary (unaligned) index. Does
      not check bounds. *)
  val unsafe_get : nativeint# array @ local read -> idx:index -> int64x2#

  (** Store two int64s to a [nativeint# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+1] fails bounds checking. *)
  val set : nativeint# array @ local -> idx:index -> int64x2# -> unit

  (** Store two int64s to a [nativeint# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : nativeint# array @ local -> idx:index -> int64x2# -> unit
end

module type Int32_u_array_accessors = sig @@ portable
  type index : any

  (** Load four int32s from a [int32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : int32# array @ local read -> idx:index -> int32x4#

  (** Load four int32s from a [int32# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : int32# array @ local read -> idx:index -> int32x4#

  (** Store four int32s to a [int32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : int32# array @ local -> idx:index -> int32x4# -> unit

  (** Store four int32s to a [int32# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : int32# array @ local -> idx:index -> int32x4# -> unit
end

module type String = sig @@ portable
  (** [t] is one of the 16-byte vector types. *)
  type t : vec128

  (** @inline *)
  include String_accessors with type t := t and type index := int

  module Int32_u : String_accessors with type t := t and type index := int32#
  module Int64_u : String_accessors with type t := t and type index := int64#
  module Nativeint_u : String_accessors with type t := t and type index := nativeint#
end

module type Bytes = sig @@ portable
  (** [t] is one of the 16-byte vector types. *)
  type t : vec128

  (** @inline *)
  include Bytes_accessors with type t := t and type index := int

  module Int32_u : Bytes_accessors with type t := t and type index := int32#
  module Int64_u : Bytes_accessors with type t := t and type index := int64#
  module Nativeint_u : Bytes_accessors with type t := t and type index := nativeint#
end

module type Bigstring = sig @@ portable
  (** [t] is one of the 16-byte vector types. *)
  type t : vec128

  (** @inline *)
  include Bigstring_accessors with type t := t and type index := int

  module Int32_u : Bigstring_accessors with type t := t and type index := int32#
  module Int64_u : Bigstring_accessors with type t := t and type index := int64#
  module Nativeint_u : Bigstring_accessors with type t := t and type index := nativeint#
end

module type Load_store = sig @@ portable
  module type Raw8 = Raw8
  module type Raw32 = Raw32
  module type Raw64 = Raw64
  module type Raw = Raw
  module type String = String
  module type Bytes = Bytes
  module type Bigstring = Bigstring
  module type String_accessors = String_accessors
  module type Bytes_accessors = Bytes_accessors
  module type Bigstring_accessors = Bigstring_accessors
  module type Float_array_accessors = Float_array_accessors
  module type Floatarray_accessors = Floatarray_accessors
  module type Float_iarray_accessors = Float_iarray_accessors
  module type Unsafe_immediate_array_accessors = Unsafe_immediate_array_accessors
  module type Unsafe_immediate_iarray_accessors = Unsafe_immediate_iarray_accessors
  module type Float_u_array_accessors = Float_u_array_accessors
  module type Float32_u_array_accessors = Float32_u_array_accessors
  module type Int64_u_array_accessors = Int64_u_array_accessors
  module type Nativeint_u_array_accessors = Nativeint_u_array_accessors
  module type Int32_u_array_accessors = Int32_u_array_accessors

  module Int32 : sig
    (** Non-temporally store 4 bytes to an address encoded as a [nativeint#]. The address
        will not be cached. *)
    val store_uncached : nativeint# -> int32# -> unit
  end

  module Int64 : sig
    (** Non-temporally store 8 bytes to an address encoded as a [nativeint#]. The address
        will not be cached. *)
    val store_uncached : nativeint# -> int64# -> unit
  end

  module Float_array : sig
    include Float_array_accessors with type index := int (** @inline *)

    module Int32_u : Float_array_accessors with type index := int32#
    module Int64_u : Float_array_accessors with type index := int64#
    module Nativeint_u : Float_array_accessors with type index := nativeint#
  end

  module Floatarray : sig
    include Floatarray_accessors with type index := int (** @inline *)

    module Int32_u : Floatarray_accessors with type index := int32#
    module Int64_u : Floatarray_accessors with type index := int64#
    module Nativeint_u : Floatarray_accessors with type index := nativeint#
  end

  module Float_iarray : sig
    include Float_iarray_accessors with type index := int (** @inline *)

    module Int32_u : Float_iarray_accessors with type index := int32#
    module Int64_u : Float_iarray_accessors with type index := int64#
    module Nativeint_u : Float_iarray_accessors with type index := nativeint#
  end

  module Unsafe_immediate_array : sig
    include Unsafe_immediate_array_accessors with type index := int (** @inline *)

    module Int32_u : Unsafe_immediate_array_accessors with type index := int32#
    module Int64_u : Unsafe_immediate_array_accessors with type index := int64#
    module Nativeint_u : Unsafe_immediate_array_accessors with type index := nativeint#
  end

  module Unsafe_immediate_iarray : sig
    include Unsafe_immediate_iarray_accessors with type index := int (** @inline *)

    module Int32_u : Unsafe_immediate_iarray_accessors with type index := int32#
    module Int64_u : Unsafe_immediate_iarray_accessors with type index := int64#
    module Nativeint_u : Unsafe_immediate_iarray_accessors with type index := nativeint#
  end

  module Float_u_array : sig
    include Float_u_array_accessors with type index := int (** @inline *)

    module Int32_u : Float_u_array_accessors with type index := int32#
    module Int64_u : Float_u_array_accessors with type index := int64#
    module Nativeint_u : Float_u_array_accessors with type index := nativeint#
  end

  module Float32_u_array : sig
    include Float32_u_array_accessors with type index := int (** @inline *)

    module Int32_u : Float32_u_array_accessors with type index := int32#
    module Int64_u : Float32_u_array_accessors with type index := int64#
    module Nativeint_u : Float32_u_array_accessors with type index := nativeint#
  end

  module Int64_u_array : sig
    include Int64_u_array_accessors with type index := int (** @inline *)

    module Int32_u : Int64_u_array_accessors with type index := int32#
    module Int64_u : Int64_u_array_accessors with type index := int64#
    module Nativeint_u : Int64_u_array_accessors with type index := nativeint#
  end

  module Nativeint_u_array : sig
    include Nativeint_u_array_accessors with type index := int (** @inline *)

    module Int32_u : Nativeint_u_array_accessors with type index := int32#
    module Int64_u : Nativeint_u_array_accessors with type index := int64#
    module Nativeint_u : Nativeint_u_array_accessors with type index := nativeint#
  end

  module Int32_u_array : sig
    include Int32_u_array_accessors with type index := int (** @inline *)

    module Int32_u : Int32_u_array_accessors with type index := int32#
    module Int64_u : Int32_u_array_accessors with type index := int64#
    module Nativeint_u : Int32_u_array_accessors with type index := nativeint#
  end

  module Raw_Int8x16 : sig
    include Raw8 with type t := int8x16# (** @inline *)

    include Raw with type t := int8x16# (** @inline *)
  end

  module Raw_Int16x8 : Raw with type t := int16x8#

  module Raw_Int32x4 : sig
    include Raw32 with type t := int32x4# (** @inline *)

    include Raw with type t := int32x4# (** @inline *)
  end

  module Raw_Int64x2 : sig
    include Raw64 with type t := int64x2# (** @inline *)

    include Raw with type t := int64x2# (** @inline *)
  end

  module Raw_Float16x8 : Raw with type t := float16x8#

  module Raw_Float32x4 : sig
    include Raw32 with type t := float32x4# (** @inline *)

    include Raw with type t := float32x4# (** @inline *)
  end

  module Raw_Float64x2 : sig
    include Raw64 with type t := float64x2# (** @inline *)

    include Raw with type t := float64x2# (** @inline *)
  end

  module String_Int8x16 : String with type t := int8x16#
  module String_Int16x8 : String with type t := int16x8#
  module String_Int32x4 : String with type t := int32x4#
  module String_Int64x2 : String with type t := int64x2#
  module String_Float16x8 : String with type t := float16x8#
  module String_Float32x4 : String with type t := float32x4#
  module String_Float64x2 : String with type t := float64x2#
  module Bytes_Int8x16 : Bytes with type t := int8x16#
  module Bytes_Int16x8 : Bytes with type t := int16x8#
  module Bytes_Int32x4 : Bytes with type t := int32x4#
  module Bytes_Int64x2 : Bytes with type t := int64x2#
  module Bytes_Float16x8 : Bytes with type t := float16x8#
  module Bytes_Float32x4 : Bytes with type t := float32x4#
  module Bytes_Float64x2 : Bytes with type t := float64x2#
  module Bigstring_Int8x16 : Bigstring with type t := int8x16#
  module Bigstring_Int16x8 : Bigstring with type t := int16x8#
  module Bigstring_Int32x4 : Bigstring with type t := int32x4#
  module Bigstring_Int64x2 : Bigstring with type t := int64x2#
  module Bigstring_Float16x8 : Bigstring with type t := float16x8#
  module Bigstring_Float32x4 : Bigstring with type t := float32x4#
  module Bigstring_Float64x2 : Bigstring with type t := float64x2#
end

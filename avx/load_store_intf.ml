open Stdlib

module type Raw = sig @@ portable
  type t : vec256

  (** Load 32 bytes from an arbitrary address encoded as a [nativeint#]. *)
  val unaligned_load : nativeint# -> t

  (** Store 32 bytes to an arbitrary address encoded as a [nativeint#]. *)
  val unaligned_store : nativeint# -> t -> unit

  (** Load 32 bytes from a 32-byte-aligned address encoded as a [nativeint#]. Does not
      validate alignment. *)
  val aligned_load : nativeint# -> t

  (** Store 32 bytes to a 32-byte-aligned address encoded as a [nativeint#]. Does not
      validate alignment. *)
  val aligned_store : nativeint# -> t -> unit

  (** Non-temporally load 32 bytes from a 32-byte-aligned address encoded as a
      [nativeint#]. Does not validate alignment. The address will not be cached. *)
  val aligned_load_uncached : nativeint# -> t

  (** Non-temporally store 32 bytes to a 32-byte-aligned address encoded as a
      [nativeint#]. Does not validate alignment. The address will not be cached. *)
  val aligned_store_uncached : nativeint# -> t -> unit

  (** Load 16 bytes from an arbitrary address encoded as a [nativeint#] into both lanes. *)
  val broadcast_lanes : nativeint# -> t
end

module type Raw64 = sig @@ portable
  type t : vec256

  (** Load 8 bytes from an arbitrary address encoded as a [nativeint#] into all lanes. *)
  val broadcast : nativeint# -> t

  (** Load 32 bytes from an arbitrary address encoded as a [nativeint#] subject to a mask.
      If the upper bit of each 8-byte mask lane is zero, the corresponding output lane
      will be zeroed, and page faults/memory exceptions will not be generated. *)
  val load_masked : nativeint# -> mask:int64x4# -> t

  (** Store 32 bytes to an arbitrary address encoded as a [nativeint#] subject to a mask.
      If the upper bit of each 8-byte mask lane is zero, the corresponding input lane will
      not be written to memory, and page faults/memory exceptions will not be generated. *)
  val store_masked : nativeint# -> t -> mask:int64x4# -> unit
end

module type Raw32 = sig @@ portable
  type t : vec256

  (** Load 4 bytes from an arbitrary address encoded as a [nativeint#] into all lanes. *)
  val broadcast : nativeint# -> t

  (** Load 32 bytes from an arbitrary address encoded as a [nativeint#] subject to a mask.
      If the upper bit of each 4-byte mask lane is zero, the corresponding output lane
      will be zeroed, and page faults/memory exceptions will not be generated. *)
  val load_masked : nativeint# -> mask:int32x8# -> t

  (** Store 32 bytes to an arbitrary address encoded as a [nativeint#] subject to a mask.
      If the upper bit of each 4-byte mask lane is zero, the corresponding input lane will
      not be written to memory, and page faults/memory exceptions will not be generated. *)
  val store_masked : nativeint# -> t -> mask:int32x8# -> unit
end

module Vec128 = struct
  module type Raw64 = sig @@ portable
    type t : vec128

    (** Load 16 bytes from an arbitrary address encoded as a [nativeint#] subject to a
        mask. If the upper bit of each 8-byte mask lane is zero, the corresponding output
        lane will be zeroed, and page faults/memory exceptions will not be generated. *)
    val load_masked : nativeint# -> mask:int64x2# -> t

    (** Store 16 bytes to an arbitrary address encoded as a [nativeint#] subject to a
        mask. If the upper bit of each 8-byte mask lane is zero, the corresponding input
        lane will not be written to memory, and page faults/memory exceptions will not be
        generated. *)
    val store_masked : nativeint# -> t -> mask:int64x2# -> unit
  end

  module type Raw32 = sig @@ portable
    type t : vec128

    (** Load 4 bytes from an arbitrary address encoded as a [nativeint#] into all lanes. *)
    val broadcast : nativeint# -> t

    (** Load 16 bytes from an arbitrary address encoded as a [nativeint#] subject to a
        mask. If the upper bit of each 4-byte mask lane is zero, the corresponding output
        lane will be zeroed, and page faults/memory exceptions will not be generated. *)
    val load_masked : nativeint# -> mask:int32x4# -> t

    (** Store 16 bytes to an arbitrary address encoded as a [nativeint#] subject to a
        mask. If the upper bit of each 4-byte mask lane is zero, the corresponding input
        lane will not be written to memory, and page faults/memory exceptions will not be
        generated. *)
    val store_masked : nativeint# -> t -> mask:int32x4# -> unit
  end
end

module type String_accessors = sig @@ portable
  type t : vec256
  type index : any

  (** Load 32 bytes from a [string] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+32] fails bounds checking. *)
  val get : string @ local -> byte:index -> t

  (** Load 32 bytes from a [string] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_get : string @ local -> byte:index -> t
end

module type Bytes_accessors = sig @@ portable
  type t : vec256
  type index : any

  (** Load 32 bytes from a [bytes] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+32] fails bounds checking. *)
  val get : bytes @ local read -> byte:index -> t

  (** Load 32 bytes from a [bytes] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_get : bytes @ local read -> byte:index -> t

  (** Write 32 bytes to a [bytes] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+32] fails bounds checking. *)
  val set : bytes @ local -> byte:index -> t -> unit

  (** Write 32 bytes to a [bytes] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_set : bytes @ local -> byte:index -> t -> unit
end

module type Bigstring_accessors = sig @@ portable
  type bigstring :=
    (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

  type t : vec256
  type index : any

  (** WARNING: by default, the backing array of a bigstring is allocated by `malloc`, so
      is only 16-byte aligned. The aligned operations below require 32-byte alignment.

      Note the safe aligned operations can be used to determine the offset at which a
      bigstring becomes 32-aligned. *)

  (** Load 32 bytes from a [bigstring] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+32] fails bounds checking. *)
  val unaligned_get : bigstring @ local read -> byte:index -> t

  (** Load 32 bytes from a [bigstring] at a 32-aligned byte offset.

      @raise Invalid_argument if the computed address is not 32-byte aligned.
      @raise Invalid_argument if [byte..byte+32] fails bounds checking. *)
  val aligned_get : bigstring @ local read -> byte:index -> t

  (** Load 32 bytes from a [bigstring] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_unaligned_get : bigstring @ local read -> byte:index -> t

  (** Load 32 bytes from a [bigstring] at a 32-aligned byte offset. Does not check bounds
      or alignment. *)
  val unsafe_aligned_get : bigstring @ local read -> byte:index -> t

  (** Write 32 bytes to a [bigstring] at an arbitrary byte offset.

      @raise Invalid_argument if [byte..byte+32] fails bounds checking. *)
  val unaligned_set : bigstring @ local -> byte:index -> t -> unit

  (** Write 32 bytes to a [bigstring] at a 32-aligned byte offset.

      @raise Invalid_argument if the computed address is not 32-byte aligned.
      @raise Invalid_argument if [byte..byte+32] fails bounds checking. *)
  val aligned_set : bigstring @ local -> byte:index -> t -> unit

  (** Write 32 bytes to a [bigstring] at an arbitrary byte offset. Does not check bounds. *)
  val unsafe_unaligned_set : bigstring @ local -> byte:index -> t -> unit

  (** Write 32 bytes to a [bigstring] at a 32-aligned byte offset. Does not check bounds
      or alignment. *)
  val unsafe_aligned_set : bigstring @ local -> byte:index -> t -> unit
end

module type Float_array_accessors = sig @@ portable
  type index : any

  (** Load four floats from a [float array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : float array @ local read -> idx:index -> float64x4#

  (** Load four floats from a [float array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : float array @ local read -> idx:index -> float64x4#

  (** Store four floats to a [float array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : float array @ local -> idx:index -> float64x4# -> unit

  (** Store four floats to a [float array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : float array @ local -> idx:index -> float64x4# -> unit
end

module type Floatarray_accessors = sig @@ portable
  type index : any

  (** Load four floats from a [floatarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : floatarray @ local read -> idx:index -> float64x4#

  (** Load four floats from a [floatarray] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : floatarray @ local read -> idx:index -> float64x4#

  (** Store four floats to a [floatarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : floatarray @ local -> idx:index -> float64x4# -> unit

  (** Store four floats to a [floatarray] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : floatarray @ local -> idx:index -> float64x4# -> unit
end

module type Float_iarray_accessors = sig @@ portable
  type index : any

  (** Load four floats from a [float iarray] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : float iarray @ local -> idx:index -> float64x4#

  (** Load four floats from a [float iarray] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : float iarray @ local -> idx:index -> float64x4#
end

module type Unsafe_immediate_array_accessors = sig @@ portable
  type index : any

  (** Load four immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains four _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get_tagged : ('a : immediate64). 'a array @ local read -> idx:index -> int64x4#

  (** Load four immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains four _tagged_ 64-bit values. Does not check bounds. *)
  val unsafe_get_tagged
    : ('a : immediate64).
    'a array @ local read -> idx:index -> int64x4#

  (** Load four immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains four _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get_and_untag : ('a : immediate64). 'a array @ local read -> idx:index -> int64x4#

  (** Load four immediates from an array at an arbitrary (unaligned) index. The returned
      vector contains four _untagged_ 63-bit values. Does not check bounds. *)
  val unsafe_get_and_untag
    : ('a : immediate64).
    'a array @ local read -> idx:index -> int64x4#

  (** Store four immediates to an array at an arbitrary (unaligned) index. The given
      vector must contain four _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking.
      @raise Invalid_argument if any int64's top bit is set. *)
  val tag_and_set : ('a : immediate64). 'a array @ local -> idx:index -> int64x4# -> unit

  (** Store four immediates to an array at an arbitrary (unaligned) index. The given
      vector must contain four _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking.
      @raise Invalid_argument if any int64's bottom bit is not set. *)
  val set_tagged : ('a : immediate64). 'a array @ local -> idx:index -> int64x4# -> unit

  (** Store four immediates to an array at an arbitrary (unaligned) index. The given
      vector must contain four _untagged_ 63-bit values. Does not check bounds or ranges. *)
  val unsafe_tag_and_set
    : ('a : immediate64).
    'a array @ local -> idx:index -> int64x4# -> unit

  (** Store four immediates to an array at an arbitrary (unaligned) index. The given
      vector must contain four _tagged_ 64-bit values. Does not check bounds or tags. *)
  val unsafe_set_tagged
    : ('a : immediate64).
    'a array @ local -> idx:index -> int64x4# -> unit
end

module type Unsafe_immediate_iarray_accessors = sig @@ portable
  type index : any

  (** Load four immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains four _tagged_ 64-bit values.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get_tagged : ('a : immediate64). 'a iarray @ local -> idx:index -> int64x4#

  (** Load four immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains four _tagged_ 64-bit values. Does not check bounds. *)
  val unsafe_get_tagged : ('a : immediate64). 'a iarray @ local -> idx:index -> int64x4#

  (** Load four immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains four _untagged_ 63-bit values.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get_and_untag : ('a : immediate64). 'a iarray @ local -> idx:index -> int64x4#

  (** Load four immediates from an iarray at an arbitrary (unaligned) index. The returned
      vector contains four _untagged_ 63-bit values. Does not check bounds. *)
  val unsafe_get_and_untag
    : ('a : immediate64).
    'a iarray @ local -> idx:index -> int64x4#
end

module type Float_u_array_accessors = sig @@ portable
  type index : any

  (** Load four floats from a [float# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : float# array @ local read -> idx:index -> float64x4#

  (** Load four floats from a [float# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : float# array @ local read -> idx:index -> float64x4#

  (** Store four floats to a [float# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : float# array @ local -> idx:index -> float64x4# -> unit

  (** Store four floats to a [float# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : float# array @ local -> idx:index -> float64x4# -> unit
end

module type Float32_u_array_accessors = sig @@ portable
  type index : any

  (** Load eight float32s from a [float32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+7] fails bounds checking. *)
  val get : float32# array @ local read -> idx:index -> float32x8#

  (** Load eight float32s from a [float32# array] at an arbitrary (unaligned) index. Does
      not check bounds. *)
  val unsafe_get : float32# array @ local read -> idx:index -> float32x8#

  (** Store eight float32s to a [float32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+7] fails bounds checking. *)
  val set : float32# array @ local -> idx:index -> float32x8# -> unit

  (** Store eight float32s to a [float32# array] at an arbitrary (unaligned) index. Does
      not check bounds. *)
  val unsafe_set : float32# array @ local -> idx:index -> float32x8# -> unit
end

module type Int64_u_array_accessors = sig @@ portable
  type index : any

  (** Load four int64s from a [int64# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : int64# array @ local read -> idx:index -> int64x4#

  (** Load four int64s from a [int64# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : int64# array @ local read -> idx:index -> int64x4#

  (** Store four int64s to a [int64# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : int64# array @ local -> idx:index -> int64x4# -> unit

  (** Store four int64s to a [int64# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : int64# array @ local -> idx:index -> int64x4# -> unit
end

(** SIMD is only available in 64-bit native builds, so nativeint is 64 bits. *)
module type Nativeint_u_array_accessors = sig @@ portable
  type index : any

  (** Load four int64s from a [nativeint# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val get : nativeint# array @ local read -> idx:index -> int64x4#

  (** Load four int64s from a [nativeint# array] at an arbitrary (unaligned) index. Does
      not check bounds. *)
  val unsafe_get : nativeint# array @ local read -> idx:index -> int64x4#

  (** Store four int64s to a [nativeint# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+3] fails bounds checking. *)
  val set : nativeint# array @ local -> idx:index -> int64x4# -> unit

  (** Store four int64s to a [nativeint# array] at an arbitrary (unaligned) index. Does
      not check bounds. *)
  val unsafe_set : nativeint# array @ local -> idx:index -> int64x4# -> unit
end

module type Int32_u_array_accessors = sig @@ portable
  type index : any

  (** Load eight int32s from a [int32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+7] fails bounds checking. *)
  val get : int32# array @ local read -> idx:index -> int32x8#

  (** Load eight int32s from a [int32# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_get : int32# array @ local read -> idx:index -> int32x8#

  (** Store eight int32s to a [int32# array] at an arbitrary (unaligned) index.

      @raise Invalid_argument if [idx..idx+7] fails bounds checking. *)
  val set : int32# array @ local -> idx:index -> int32x8# -> unit

  (** Store eight int32s to a [int32# array] at an arbitrary (unaligned) index. Does not
      check bounds. *)
  val unsafe_set : int32# array @ local -> idx:index -> int32x8# -> unit
end

module type String = sig @@ portable
  (** [t] is one of the 32-byte vector types. *)
  type t : vec256

  (** @inline *)
  include String_accessors with type t := t and type index := int

  module Int32_u : String_accessors with type t := t and type index := int32#
  module Int64_u : String_accessors with type t := t and type index := int64#
  module Nativeint_u : String_accessors with type t := t and type index := nativeint#
end

module type Bytes = sig @@ portable
  (** [t] is one of the 32-byte vector types. *)
  type t : vec256

  (** @inline *)
  include Bytes_accessors with type t := t and type index := int

  module Int32_u : Bytes_accessors with type t := t and type index := int32#
  module Int64_u : Bytes_accessors with type t := t and type index := int64#
  module Nativeint_u : Bytes_accessors with type t := t and type index := nativeint#
end

module type Bigstring = sig @@ portable
  (** [t] is one of the 32-byte vector types. *)
  type t : vec256

  (** @inline *)
  include Bigstring_accessors with type t := t and type index := int

  module Int32_u : Bigstring_accessors with type t := t and type index := int32#
  module Int64_u : Bigstring_accessors with type t := t and type index := int64#
  module Nativeint_u : Bigstring_accessors with type t := t and type index := nativeint#
end

module type Load_store = sig @@ portable
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

  module Raw_Int8x32 : Raw with type t := int8x32#
  module Raw_Int16x16 : Raw with type t := int16x16#

  module Raw_Int32x8 : sig
    include Raw32 with type t := int32x8# (** @inline *)

    include Raw with type t := int32x8# (** @inline *)
  end

  module Raw_Int64x4 : sig
    include Raw64 with type t := int64x4# (** @inline *)

    include Raw with type t := int64x4# (** @inline *)
  end

  module Raw_Float16x16 : Raw with type t := float16x16#

  module Raw_Float32x8 : sig
    include Raw32 with type t := float32x8# (** @inline *)

    include Raw with type t := float32x8# (** @inline *)
  end

  module Raw_Float64x4 : sig
    include Raw64 with type t := float64x4# (** @inline *)

    include Raw with type t := float64x4# (** @inline *)
  end

  module String_Int8x32 : String with type t := int8x32#
  module String_Int16x16 : String with type t := int16x16#
  module String_Int32x8 : String with type t := int32x8#
  module String_Int64x4 : String with type t := int64x4#
  module String_Float16x16 : String with type t := float16x16#
  module String_Float32x8 : String with type t := float32x8#
  module String_Float64x4 : String with type t := float64x4#
  module Bytes_Int8x32 : Bytes with type t := int8x32#
  module Bytes_Int16x16 : Bytes with type t := int16x16#
  module Bytes_Int32x8 : Bytes with type t := int32x8#
  module Bytes_Int64x4 : Bytes with type t := int64x4#
  module Bytes_Float16x16 : Bytes with type t := float16x16#
  module Bytes_Float32x8 : Bytes with type t := float32x8#
  module Bytes_Float64x4 : Bytes with type t := float64x4#
  module Bigstring_Int8x32 : Bigstring with type t := int8x32#
  module Bigstring_Int16x16 : Bigstring with type t := int16x16#
  module Bigstring_Int32x8 : Bigstring with type t := int32x8#
  module Bigstring_Int64x4 : Bigstring with type t := int64x4#
  module Bigstring_Float16x16 : Bigstring with type t := float16x16#
  module Bigstring_Float32x8 : Bigstring with type t := float32x8#
  module Bigstring_Float64x4 : Bigstring with type t := float64x4#

  module Vec128 : sig
    include module type of struct
      include Ocaml_simd_sse.Load_store (** @inline *)
    end

    module Raw_Int32x4 : sig
      include module type of struct
        include Raw_Int32x4 (** @inline *)
      end

      include Vec128.Raw32 with type t := int32x4# (** @inline *)
    end

    module Raw_Int64x2 : sig
      include module type of struct
        include Raw_Int64x2 (** @inline *)
      end

      include Vec128.Raw64 with type t := int64x2# (** @inline *)
    end

    module Raw_Float32x4 : sig
      include module type of struct
        include Raw_Float32x4 (** @inline *)
      end

      include Vec128.Raw32 with type t := float32x4# (** @inline *)
    end

    module Raw_Float64x2 : sig
      include module type of struct
        include Raw_Float64x2 (** @inline *)
      end

      include Vec128.Raw64 with type t := float64x2# (** @inline *)
    end
  end
end

(* For detailed descriptions of all operations, refer to the corresponding intrinsic in
   the Intel Intrinsics Guide:
   https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html *)

(** Scalars *)

module Int16 = Int16
module Int32 = Int32
module Int64 = Int64

(** 128-bit vectors *)

module Float16x8 = Float16x8
module Float32x4 = Float32x4
module Float64x2 = Float64x2
module Int8x16 = Int8x16
module Int16x8 = Int16x8
module Int32x4 = Int32x4
module Int64x2 = Int64x2

(** Utility *)

module String = String

module Vec128 = struct
  module Ref = Ref
  module Test = Test
  module Array = Array
  module Load_store = Load_store
end

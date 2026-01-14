(* For detailed descriptions of all operations, refer to the corresponding intrinsic in
   the Intel Intrinsics Guide:
   https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html *)

(** Scalars *)

module Float32 = Float32
module Float64 = Float64

(** 256-bit vectors *)

module Vec256 = struct
  module Ref = Ref
  module Test = Test
  module Array = Array
  module Load_store = Load_store
end

module Float16x16 = Float16x16
module Float32x8 = Float32x8
module Float64x4 = Float64x4
module Int8x32 = Int8x32
module Int16x16 = Int16x16
module Int32x8 = Int32x8
module Int64x4 = Int64x4

(** 128-bit vectors *)

module Vec128 = struct
  module Ref = Ocaml_simd_sse.Ref
  module Test = Ocaml_simd_sse.Test
  module Array = Ocaml_simd_sse.Array
  module Load_store = Load_store.Vec128
end

module Float16x8 = Float16x8
module Float32x4 = Float32x4
module Float64x2 = Float64x2
module Int8x16 = Int8x16
module Int16x8 = Int16x8
module Int32x4 = Int32x4
module Int64x2 = Int64x2

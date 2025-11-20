(* For detailed descriptions of all operations, refer to the corresponding intrinsic in
   the Intel Intrinsics Guide:
   https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html *)

module Ref256 = Ref
module Ref128 = Ocaml_simd_sse.Ref
module Array256 = Array
module Array128 = Ocaml_simd_sse.Array
module Test256 = Test
module Test128 = Ocaml_simd_sse.Test
module Load_store128 = Ocaml_simd_sse.Load_store
module Load_store256 = Load_store

(** 256-bit vectors *)

module Float32x8 = Float32x8
module Float64x4 = Float64x4
module Int8x32 = Int8x32
module Int16x16 = Int16x16
module Int32x8 = Int32x8
module Int64x4 = Int64x4

(** 128-bit vectors *)

module Float32x4 = Float32x4
module Float64x2 = Float64x2
module Int8x16 = Int8x16
module Int16x8 = Int16x8
module Int32x4 = Int32x4
module Int64x2 = Int64x2

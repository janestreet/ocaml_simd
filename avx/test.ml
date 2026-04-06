include Test_intf

module Test (T : sig
  @@ portable
    (** Must be one of [int8x32,int16x16,int32x8,int64x4]. Using [float32x8,float64x4] is
        also safe, but we always emit the integer [vptest] instruction, and bitwise
        operations don't make much sense on floats. *)
    type t : vec256 mod contended

    val ones : t
  end) =
struct
  external disjoint
    :  (T.t[@unboxed])
    -> (T.t[@unboxed])
    -> (bool[@untagged])
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_testz"
  [@@noalloc] [@@builtin amd64]

  external subset
    :  (T.t[@unboxed])
    -> (T.t[@unboxed])
    -> (bool[@untagged])
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_testc"
  [@@noalloc] [@@builtin amd64]

  external intersect
    :  (T.t[@unboxed])
    -> (T.t[@unboxed])
    -> (bool[@untagged])
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_testnzc"
  [@@noalloc] [@@builtin amd64]

  let[@inline] is_zeros t = disjoint t t
  let[@inline] is_ones t = subset t T.ones
  let[@inline] is_mixed t = intersect t T.ones
end

module Int8x32 = Test (struct
    type t = int8x32#

    let ones = Int8x32_internal.const1 (-#1s)
  end)

module Int16x16 = Test (struct
    type t = int16x16#

    let ones = Int16x16_internal.const1 (-#1S)
  end)

module Int32x8 = Test (struct
    type t = int32x8#

    let ones = Int32x8_internal.const1 (-#1l)
  end)

module Int64x4 = Test (struct
    type t = int64x4#

    let ones = Int64x4_internal.const1 (-#1L)
  end)

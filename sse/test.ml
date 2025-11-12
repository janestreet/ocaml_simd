include Test_intf

module Test (T : sig
  @@ portable
    (** Must be one of [int8x16,int16x8,int32x4,int64x2]. Using [float32x4,float64x2] is
        also safe, but we always emit the integer [vptest] instruction, and bitwise
        operations don't make much sense on floats. *)
    type t : vec128

    val ones : unit -> t
  end) =
struct
  external disjoint
    :  (T.t[@unboxed])
    -> (T.t[@unboxed])
    -> (bool[@untagged])
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_testz"
  [@@noalloc] [@@builtin]

  external subset
    :  (T.t[@unboxed])
    -> (T.t[@unboxed])
    -> (bool[@untagged])
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_testc"
  [@@noalloc] [@@builtin]

  external intersect
    :  (T.t[@unboxed])
    -> (T.t[@unboxed])
    -> (bool[@untagged])
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_testnzc"
  [@@noalloc] [@@builtin]

  let[@inline] is_zeros t = disjoint t t
  let[@inline] is_ones t = subset t (T.ones ())
  let[@inline] is_mixed t = intersect t (T.ones ())
end

module Int8x16 = Test (struct
    type t = int8x16#

    let[@inline] ones () = Int8x16_internal.const1 (-#1s)
  end)

module Int16x8 = Test (struct
    type t = int16x8#

    let[@inline] ones () = Int16x8_internal.const1 (-#1S)
  end)

module Int32x4 = Test (struct
    type t = int32x4#

    let[@inline] ones () = Int32x4_internal.const1 (-#1l)
  end)

module Int64x2 = Test (struct
    type t = int64x2#

    let[@inline] ones () = Int64x2_internal.const1 (-#1L)
  end)

module I = Int8x16_internal

type t = int8x16#
type mask = int8x16#

external box : t -> int8x16 @@ portable = "%box_vec128"
external unbox : int8x16 -> t @@ portable = "%unbox_vec128"

module String = Load_store.String_Int8x16
module Bytes = Load_store.Bytes_Int8x16
module Bigstring = Load_store.Bigstring_Int8x16

external const1
  :  (int[@untagged])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int8x16_const1"
[@@noalloc] [@@builtin]

external const
  :  (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_int8x16_const16"
[@@noalloc] [@@builtin]

external extract
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> (int[@untagged])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int8x16_extract"
[@@noalloc] [@@builtin]

external insert
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> (int[@untagged])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int8x16_insert"
[@@noalloc] [@@builtin]

let[@inline always] zero () = const1 0
let[@inline always] one () = const1 1
let[@inline always] all_ones () = const1 0xff
let[@inline always] zero_mask () = Int16x8_internal.const1 0
let[@inline always] shuffle ~pattern x = I.shuffle_8 x pattern
let[@inline always] set1 a = shuffle ~pattern:(zero ()) (I.low_of a)

let[@inline always] set a b c d e f g h i j k l m n o p =
  (* movd, + 15x insert -> 31 cycle latency
     this               -> 6 cycle latency (but a lot of registers) *)
  let a = I.low_of a in
  let c = I.low_of c in
  let e = I.low_of e in
  let g = I.low_of g in
  let i = I.low_of i in
  let k = I.low_of k in
  let m = I.low_of m in
  let o = I.low_of o in
  let ba = insert ~idx:1 a b in
  let dc = insert ~idx:1 c d in
  let fe = insert ~idx:1 e f in
  let hg = insert ~idx:1 g h in
  let ji = insert ~idx:1 i j in
  let lk = insert ~idx:1 k l in
  let nm = insert ~idx:1 m n in
  let po = insert ~idx:1 o p in
  let dcba = I.interleave_low_16 ba dc in
  let hgfe = I.interleave_low_16 fe hg in
  let lkji = I.interleave_low_16 ji lk in
  let ponm = I.interleave_low_16 nm po in
  let hgfedcba = I.interleave_low_32 dcba hgfe in
  let ponmlkji = I.interleave_low_32 lkji ponm in
  I.interleave_low_64 hgfedcba ponmlkji
;;

let[@inline always] select m ~fail ~pass = I.blendv_8 fail pass m
let[@inline always] extract0 x = I.low_to x
let[@inline always] movemask m = I.movemask_8 m

let[@inline always] splat x =
  (* 16x movd, 16x movzx, 15x shuffle -> 6 cycle latency
     this                             -> 5 cycle latency, fewer registers *)
  ( extract0 x
  , extract ~idx:1 x
  , extract ~idx:2 x
  , extract ~idx:3 x
  , extract ~idx:4 x
  , extract ~idx:5 x
  , extract ~idx:6 x
  , extract ~idx:7 x
  , extract ~idx:8 x
  , extract ~idx:9 x
  , extract ~idx:10 x
  , extract ~idx:11 x
  , extract ~idx:12 x
  , extract ~idx:13 x
  , extract ~idx:14 x
  , extract ~idx:15 x )
;;

(* Comparisons do not use [C.not_...], as they have different NaN behavior. *)
let[@inline always] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline always] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline always] ( = ) x y = I.cmpeq x y
let[@inline always] ( > ) x y = I.cmpgt x y
let[@inline always] ( < ) x y = I.cmpgt y x
let[@inline always] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline always] equal x y = I.cmpeq x y
let[@inline always] interleave_upper ~lower ~upper = I.interleave_high_8 lower upper
let[@inline always] interleave_lower ~lower ~upper = I.interleave_low_8 lower upper
let[@inline always] min x y = I.min x y
let[@inline always] max x y = I.max x y
let[@inline always] min_unsigned x y = I.min_unsigned x y
let[@inline always] max_unsigned x y = I.max_unsigned x y
let[@inline always] add x y = I.add x y
let[@inline always] add_saturating x y = I.add_saturating x y
let[@inline always] add_saturating_unsigned x y = I.add_saturating_unsigned x y
let[@inline always] sub x y = I.sub x y
let[@inline always] sub_saturating x y = I.sub_saturating x y
let[@inline always] sub_saturating_unsigned x y = I.sub_saturating_unsigned x y
let[@inline always] neg x = I.(mulsign x (all_ones ()))
let[@inline always] abs x = I.abs x

external shifti_left_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

external shifti_right_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

external concat_shift_right_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_ssse3_vec128_align_right_bytes"
[@@noalloc] [@@builtin]

let[@inline always] mulsign x y = I.mulsign x y
let[@inline always] average_unsigned x y = I.avg_unsigned x y
let[@inline always] ( + ) x y = I.add x y
let[@inline always] ( - ) x y = I.sub x y
let[@inline always] ( lor ) x y = I.or_ x y
let[@inline always] ( land ) x y = I.and_ x y
let[@inline always] ( lxor ) x y = I.xor x y
let[@inline always] lnot m = I.(xor (all_ones ()) m)
let[@inline always] landnot ~not y = I.andnot ~not y
let[@inline always] sum_absolute_differences_unsigned x y = I.sadu x y

let[@inline always] mul_unsigned_by_signed_horizontal_add_saturating x y =
  I.mul_horizontal_add_saturating x y
;;

external multi_sum_absolute_differences_unsigned
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (int16x8#[@unboxed])
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int8x16_multi_sad_unsigned"
[@@noalloc] [@@builtin]

let[@inline always] of_float32x4_bits x = I.of_float32x4 x
let[@inline always] of_float64x2_bits x = I.of_float64x2 x
let[@inline always] of_int16x8_bits x = I.of_int16x8 x
let[@inline always] of_int32x4_bits x = I.of_int32x4 x
let[@inline always] of_int64x2_bits x = I.of_int64x2 x
let[@inline always] of_int16x8_saturating x = Int16x8_internal.(cvt_si8 x (zero_mask ()))

let[@inline always] of_int16x8_saturating_unsigned x =
  Int16x8_internal.(cvt_su8 x (zero_mask ()))
;;

let[@inline always] to_string x =
  let a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p = splat x in
  Stdlib.Printf.sprintf
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d)"
    a
    b
    c
    d
    e
    f
    g
    h
    i
    j
    k
    l
    m
    n
    o
    p
;;

let[@inline always] of_string s =
  Stdlib.Scanf.sscanf
    s
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d)"
    (fun a b c d e f g h i j k l m n o p -> set a b c d e f g h i j k l m n o p |> box)
  |> unbox
;;

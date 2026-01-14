open Stdlib_stable
module I = Int8x16_internal

type t = int8x16#
type mask = int8x16#

external box : t -> int8x16 @@ portable = "%box_vec128"
external unbox : int8x16 @ local -> t @@ portable = "%unbox_vec128"

module Test = Test.Int8x16
module Raw = Load_store.Raw_Int8x16
module String = Load_store.String_Int8x16
module Bytes = Load_store.Bytes_Int8x16
module Bigstring = Load_store.Bigstring_Int8x16

external const1
  :  int8#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int8x16_const1"
[@@noalloc] [@@builtin]

external const
  :  int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> int8#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int8x16_const16"
[@@noalloc] [@@builtin]

let[@inline] insert ~idx t x =
  match idx with
  | #0L -> I.insert ~idx:#0L t x
  | #1L -> I.insert ~idx:#1L t x
  | #2L -> I.insert ~idx:#2L t x
  | #3L -> I.insert ~idx:#3L t x
  | #4L -> I.insert ~idx:#4L t x
  | #5L -> I.insert ~idx:#5L t x
  | #6L -> I.insert ~idx:#6L t x
  | #7L -> I.insert ~idx:#7L t x
  | #8L -> I.insert ~idx:#8L t x
  | #9L -> I.insert ~idx:#9L t x
  | #10L -> I.insert ~idx:#10L t x
  | #11L -> I.insert ~idx:#11L t x
  | #12L -> I.insert ~idx:#12L t x
  | #13L -> I.insert ~idx:#13L t x
  | #14L -> I.insert ~idx:#14L t x
  | #15L -> I.insert ~idx:#15L t x
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract ~idx t =
  match idx with
  | #0L -> I.extract ~idx:#0L t
  | #1L -> I.extract ~idx:#1L t
  | #2L -> I.extract ~idx:#2L t
  | #3L -> I.extract ~idx:#3L t
  | #4L -> I.extract ~idx:#4L t
  | #5L -> I.extract ~idx:#5L t
  | #6L -> I.extract ~idx:#6L t
  | #7L -> I.extract ~idx:#7L t
  | #8L -> I.extract ~idx:#8L t
  | #9L -> I.extract ~idx:#9L t
  | #10L -> I.extract ~idx:#10L t
  | #11L -> I.extract ~idx:#11L t
  | #12L -> I.extract ~idx:#12L t
  | #13L -> I.extract ~idx:#13L t
  | #14L -> I.extract ~idx:#14L t
  | #15L -> I.extract ~idx:#15L t
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] zero () = const1 #0s
let[@inline] one () = const1 #1s
let[@inline] all_ones () = const1 #0xffs
let[@inline] shuffle ~pattern x = I.shuffle_8 x pattern
let[@inline] set1 a = shuffle ~pattern:(zero ()) (I.low_of a)

let[@inline] set a b c d e f g h i j k l m n o p =
  (*=movd, + 15x insert -> 31 cycle latency
     this               -> 6 cycle latency (but a lot of registers) *)
  let a = I.low_of a in
  let c = I.low_of c in
  let e = I.low_of e in
  let g = I.low_of g in
  let i = I.low_of i in
  let k = I.low_of k in
  let m = I.low_of m in
  let o = I.low_of o in
  let ba = I.insert ~idx:#1L a b in
  let dc = I.insert ~idx:#1L c d in
  let fe = I.insert ~idx:#1L e f in
  let hg = I.insert ~idx:#1L g h in
  let ji = I.insert ~idx:#1L i j in
  let lk = I.insert ~idx:#1L k l in
  let nm = I.insert ~idx:#1L m n in
  let po = I.insert ~idx:#1L o p in
  let dcba = I.interleave_low_16 ba dc in
  let hgfe = I.interleave_low_16 fe hg in
  let lkji = I.interleave_low_16 ji lk in
  let ponm = I.interleave_low_16 nm po in
  let hgfedcba = I.interleave_low_32 dcba hgfe in
  let ponmlkji = I.interleave_low_32 lkji ponm in
  I.interleave_low_64 hgfedcba ponmlkji
;;

let[@inline] select m ~fail ~pass = I.blendv_8 fail pass m
let[@inline] extract0 x = I.low_to x
let[@inline] movemask m = I.movemask_8 m

let[@inline] splat x =
  (*=16x movd, 16x movzx, 15x shuffle -> 6 cycle latency
     this                             -> 5 cycle latency, fewer registers *)
  #( extract0 x
   , extract ~idx:#1L x
   , extract ~idx:#2L x
   , extract ~idx:#3L x
   , extract ~idx:#4L x
   , extract ~idx:#5L x
   , extract ~idx:#6L x
   , extract ~idx:#7L x
   , extract ~idx:#8L x
   , extract ~idx:#9L x
   , extract ~idx:#10L x
   , extract ~idx:#11L x
   , extract ~idx:#12L x
   , extract ~idx:#13L x
   , extract ~idx:#14L x
   , extract ~idx:#15L x )
;;

let[@inline] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline] ( = ) x y = I.cmpeq x y
let[@inline] ( > ) x y = I.cmpgt x y
let[@inline] ( < ) x y = I.cmpgt y x
let[@inline] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline] equal x y = I.cmpeq x y
let[@inline] interleave_upper ~even ~odd = I.interleave_high_8 even odd
let[@inline] interleave_lower ~even ~odd = I.interleave_low_8 even odd
let[@inline] min x y = I.min x y
let[@inline] max x y = I.max x y
let[@inline] min_unsigned x y = I.min_unsigned x y
let[@inline] max_unsigned x y = I.max_unsigned x y
let[@inline] add x y = I.add x y
let[@inline] add_saturating x y = I.add_saturating x y
let[@inline] add_saturating_unsigned x y = I.add_saturating_unsigned x y
let[@inline] sub x y = I.sub x y
let[@inline] sub_saturating x y = I.sub_saturating x y
let[@inline] sub_saturating_unsigned x y = I.sub_saturating_unsigned x y
let[@inline] neg x = I.(mul_sign x (all_ones ()))
let[@inline] abs x = I.abs x

external shifti_left_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

external shifti_right_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

external concat_shift_right_bytes
  :  int64#
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_ssse3_vec128_align_right_bytes"
[@@noalloc] [@@builtin]

let[@inline] mul_sign x y = I.mul_sign x y
let[@inline] average_unsigned x y = I.avg_unsigned x y
let[@inline] ( + ) x y = I.add x y
let[@inline] ( - ) x y = I.sub x y
let[@inline] ( lor ) x y = I.or_ x y
let[@inline] ( land ) x y = I.and_ x y
let[@inline] ( lxor ) x y = I.xor x y
let[@inline] lnot m = I.(xor (all_ones ()) m)
let[@inline] landnot ~not y = I.andnot ~not y
let[@inline] sum_absolute_differences_unsigned x y = I.sadu x y

let[@inline] mul_unsigned_by_signed_horizontal_add_saturating x y =
  I.mul_horizontal_add_saturating x y
;;

external multi_sum_absolute_differences_unsigned
  :  int64#
  -> t
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_int8x16_multi_sad_unsigned"
[@@noalloc] [@@builtin]

let[@inline] of_float16x8_bits x = I.of_float16x8 x
let[@inline] of_float32x4_bits x = I.of_float32x4 x
let[@inline] of_float64x2_bits x = I.of_float64x2 x
let[@inline] of_int16x8_bits x = I.of_int16x8 x
let[@inline] of_int32x4_bits x = I.of_int32x4 x
let[@inline] of_int64x2_bits x = I.of_int64x2 x
let[@inline] of_int16x8_saturating x y = Int16x8_internal.(cvt_si8 x y)
let[@inline] of_int16x8_saturating_unsigned x y = Int16x8_internal.(cvt_su8 x y)

let[@inline] to_string x =
  let bx = Int8_u.to_int in
  let #(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) = splat x in
  Stdlib.Printf.sprintf
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d)"
    (bx a)
    (bx b)
    (bx c)
    (bx d)
    (bx e)
    (bx f)
    (bx g)
    (bx h)
    (bx i)
    (bx j)
    (bx k)
    (bx l)
    (bx m)
    (bx n)
    (bx o)
    (bx p)
;;

let[@inline] of_string s =
  let ub = Int8_u.of_int in
  Stdlib.Scanf.sscanf
    s
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d)"
    (fun a b c d e f g h i j k l m n o p ->
       set
         (ub a)
         (ub b)
         (ub c)
         (ub d)
         (ub e)
         (ub f)
         (ub g)
         (ub h)
         (ub i)
         (ub j)
         (ub k)
         (ub l)
         (ub m)
         (ub n)
         (ub o)
         (ub p)
       |> box)
  |> unbox
;;

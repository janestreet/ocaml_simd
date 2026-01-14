open Stdlib_stable
module I = Int16x16_internal

type t = int16x16#
type mask = int16x16#

external box : t -> int16x16 @@ portable = "%box_vec256"
external unbox : int16x16 @ local -> t @@ portable = "%unbox_vec256"

module Test = Test.Int16x16
module Raw = Load_store.Raw_Int16x16
module String = Load_store.String_Int16x16
module Bytes = Load_store.Bytes_Int16x16
module Bigstring = Load_store.Bigstring_Int16x16

external const1
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_const1"
[@@noalloc] [@@builtin]

external const
  :  int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> int16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int16x16_const16"
[@@noalloc] [@@builtin]

external shuffle_upper_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shuffle_high_16"
[@@noalloc] [@@builtin]

external shuffle_lower_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shuffle_low_16"
[@@noalloc] [@@builtin]

external insert_lane
  :  idx:int64#
  -> t
  -> int16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

external extract_lane
  :  idx:int64#
  -> t
  -> int16x8#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0S
let[@inline] one () = const1 #1S
let[@inline] all_ones () = const1 (-#1S)
let[@inline] set1 x = I.broadcast_16 (I.I16x8.low_of x)

let[@inline] set x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 =
  let x0_7 = Int16x8.set x0 x1 x2 x3 x4 x5 x6 x7 in
  let x8_15 = Int16x8.set x8 x9 x10 x11 x12 x13 x14 x15 in
  insert_lane ~idx:#1L (I.low_of_i16x8 x0_7) x8_15
;;

let[@inline] extract ~idx x =
  match idx with
  | #0L -> Int16x8.extract ~idx:#0L (I.low_to_i16x8 x)
  | #1L -> Int16x8.extract ~idx:#1L (I.low_to_i16x8 x)
  | #2L -> Int16x8.extract ~idx:#2L (I.low_to_i16x8 x)
  | #3L -> Int16x8.extract ~idx:#3L (I.low_to_i16x8 x)
  | #4L -> Int16x8.extract ~idx:#4L (I.low_to_i16x8 x)
  | #5L -> Int16x8.extract ~idx:#5L (I.low_to_i16x8 x)
  | #6L -> Int16x8.extract ~idx:#6L (I.low_to_i16x8 x)
  | #7L -> Int16x8.extract ~idx:#7L (I.low_to_i16x8 x)
  | #8L -> Int16x8.extract ~idx:#0L (extract_lane ~idx:#1L x)
  | #9L -> Int16x8.extract ~idx:#1L (extract_lane ~idx:#1L x)
  | #10L -> Int16x8.extract ~idx:#2L (extract_lane ~idx:#1L x)
  | #11L -> Int16x8.extract ~idx:#3L (extract_lane ~idx:#1L x)
  | #12L -> Int16x8.extract ~idx:#4L (extract_lane ~idx:#1L x)
  | #13L -> Int16x8.extract ~idx:#5L (extract_lane ~idx:#1L x)
  | #14L -> Int16x8.extract ~idx:#6L (extract_lane ~idx:#1L x)
  | #15L -> Int16x8.extract ~idx:#7L (extract_lane ~idx:#1L x)
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] insert ~idx t x =
  match idx with
  | #0L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#0L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #1L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#1L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #2L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#2L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #3L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#3L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #4L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#4L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #5L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#5L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #6L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#6L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #7L ->
    let t' = I.low_of_i16x8 (Int16x8.insert ~idx:#7L (I.low_to_i16x8 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #8L ->
    let t' = Int16x8.insert ~idx:#0L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #9L ->
    let t' = Int16x8.insert ~idx:#1L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #10L ->
    let t' = Int16x8.insert ~idx:#2L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #11L ->
    let t' = Int16x8.insert ~idx:#3L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #12L ->
    let t' = Int16x8.insert ~idx:#4L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #13L ->
    let t' = Int16x8.insert ~idx:#5L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #14L ->
    let t' = Int16x8.insert ~idx:#6L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #15L ->
    let t' = Int16x8.insert ~idx:#7L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] set_lanes a b = insert_lane ~idx:#1L (I.low_of_i16x8 a) b
let[@inline] extract0 x = I.low_to x
let[@inline] extract_lane0 x = I.low_to_i16x8 x

let[@inline] splat x =
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
let[@inline] interleave_upper_lanes ~even ~odd = I.interleave_high_16 even odd
let[@inline] interleave_lower_lanes ~even ~odd = I.interleave_low_16 even odd

external blend_lanes
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_blend_16"
[@@noalloc] [@@builtin]

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

external shifti_left_bytes_lanes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_left_bytes"
[@@noalloc] [@@builtin]

external shifti_right_bytes_lanes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec128x2_shift_right_bytes"
[@@noalloc] [@@builtin]

external shifti_left_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_srli"
[@@noalloc] [@@builtin]

external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int16x16_srai"
[@@noalloc] [@@builtin]

let[@inline] horizontal_add_lanes x y = I.horizontal_add x y
let[@inline] horizontal_sub_lanes x y = I.horizontal_sub x y
let[@inline] horizontal_add_saturating_lanes x y = I.horizontal_add_saturating x y
let[@inline] horizontal_sub_saturating_lanes x y = I.horizontal_sub_saturating x y
let[@inline] mul_sign x y = I.mul_sign x y
let[@inline] average_unsigned x y = I.avg_unsigned x y
let[@inline] ( + ) x y = I.add x y
let[@inline] ( - ) x y = I.sub x y
let[@inline] ( lor ) x y = I.or_ x y
let[@inline] ( land ) x y = I.and_ x y
let[@inline] ( lxor ) x y = I.xor x y
let[@inline] lnot m = I.(xor (all_ones ()) m)
let[@inline] landnot ~not y = I.andnot ~not y
let[@inline] unsafe_of_int16x8 x = I.low_of_i16x8 x
let[@inline] of_float16x16_bits x = I.of_float16x16 x
let[@inline] of_float32x8_bits x = I.of_float32x8 x
let[@inline] of_float64x4_bits x = I.of_float64x4 x
let[@inline] of_int8x32_bits x = I.of_int8x32 x
let[@inline] of_int32x8_bits x = I.of_int32x8 x
let[@inline] of_int64x4_bits x = I.of_int64x4 x
let[@inline] of_int8x16 x = Int8x32_internal.I8x16.cvtsx_i16 x
let[@inline] of_int8x16_unsigned x = Int8x32_internal.I8x16.cvtzx_i16 x
let[@inline] mul_high_bits x y = I.mul_high x y
let[@inline] mul_low_bits x y = I.mul_low x y
let[@inline] mul_high_bits_unsigned x y = I.mul_high_unsigned x y
let[@inline] mul_horizontal_add x y = I.mul_horizontal_add x y
let[@inline] mul_round x y = I.mul_round x y
let[@inline] of_int32x8_saturating_lanes x y = Int32x8_internal.cvt_si16 x y
let[@inline] of_int32x8_saturating_unsigned_lanes x y = Int32x8_internal.cvt_su16 x y

let[@inline] shift_left_logical x i =
  let c = Int64x4_internal.I64x2.low_of i in
  I.(sll x c)
;;

let[@inline] shift_right_logical x i =
  let c = Int64x4_internal.I64x2.low_of i in
  I.(srl x c)
;;

let[@inline] shift_right_arithmetic x i =
  let c = Int64x4_internal.I64x2.low_of i in
  I.(sra x c)
;;

let[@inline] to_string x =
  let bx = Int16_u.to_int in
  let #(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15) = splat x in
  Stdlib.Printf.sprintf
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d)"
    (bx x0)
    (bx x1)
    (bx x2)
    (bx x3)
    (bx x4)
    (bx x5)
    (bx x6)
    (bx x7)
    (bx x8)
    (bx x9)
    (bx x10)
    (bx x11)
    (bx x12)
    (bx x13)
    (bx x14)
    (bx x15)
;;

let[@inline] of_string s =
  let ub = Int16_u.of_int in
  Stdlib.Scanf.sscanf
    s
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d)"
    (fun x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 ->
       set
         (ub x0)
         (ub x1)
         (ub x2)
         (ub x3)
         (ub x4)
         (ub x5)
         (ub x6)
         (ub x7)
         (ub x8)
         (ub x9)
         (ub x10)
         (ub x11)
         (ub x12)
         (ub x13)
         (ub x14)
         (ub x15)
       |> box)
  |> unbox
;;

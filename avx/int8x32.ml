open Stdlib_stable
module I = Int8x32_internal

type t = int8x32#
type mask = int8x32#

external box : t -> int8x32 @@ portable = "%box_vec256"
external unbox : int8x32 @ local -> t @@ portable = "%unbox_vec256"

module Test = Test.Int8x32
module Raw = Load_store.Raw_Int8x32
module String = Load_store.String_Int8x32
module Bytes = Load_store.Bytes_Int8x32
module Bigstring = Load_store.Bigstring_Int8x32

external const1
  :  int8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int8x32_const1"
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
  -> int8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int8x32_const32"
[@@noalloc] [@@builtin]

external insert_lane
  :  idx:int64#
  -> t
  -> int8x16#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

external extract_lane
  :  idx:int64#
  -> t
  -> int8x16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0s
let[@inline] one () = const1 #1s
let[@inline] all_ones () = const1 #0xffs
let[@inline] shuffle_lanes ~pattern x = I.shuffle_8 x pattern
let[@inline] set1 x = I.broadcast_8 (I.I8x16.low_of x)

let[@inline] set
  x0
  x1
  x2
  x3
  x4
  x5
  x6
  x7
  x8
  x9
  x10
  x11
  x12
  x13
  x14
  x15
  x16
  x17
  x18
  x19
  x20
  x21
  x22
  x23
  x24
  x25
  x26
  x27
  x28
  x29
  x30
  x31
  =
  let x0_15 = Int8x16.set x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 in
  let x16_31 =
    Int8x16.set x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31
  in
  insert_lane ~idx:#1L (I.low_of_i8x16 x0_15) x16_31
;;

let[@inline] extract ~idx x =
  match idx with
  | #0L -> Int8x16.extract ~idx:#0L (I.low_to_i8x16 x)
  | #1L -> Int8x16.extract ~idx:#1L (I.low_to_i8x16 x)
  | #2L -> Int8x16.extract ~idx:#2L (I.low_to_i8x16 x)
  | #3L -> Int8x16.extract ~idx:#3L (I.low_to_i8x16 x)
  | #4L -> Int8x16.extract ~idx:#4L (I.low_to_i8x16 x)
  | #5L -> Int8x16.extract ~idx:#5L (I.low_to_i8x16 x)
  | #6L -> Int8x16.extract ~idx:#6L (I.low_to_i8x16 x)
  | #7L -> Int8x16.extract ~idx:#7L (I.low_to_i8x16 x)
  | #8L -> Int8x16.extract ~idx:#8L (I.low_to_i8x16 x)
  | #9L -> Int8x16.extract ~idx:#9L (I.low_to_i8x16 x)
  | #10L -> Int8x16.extract ~idx:#10L (I.low_to_i8x16 x)
  | #11L -> Int8x16.extract ~idx:#11L (I.low_to_i8x16 x)
  | #12L -> Int8x16.extract ~idx:#12L (I.low_to_i8x16 x)
  | #13L -> Int8x16.extract ~idx:#13L (I.low_to_i8x16 x)
  | #14L -> Int8x16.extract ~idx:#14L (I.low_to_i8x16 x)
  | #15L -> Int8x16.extract ~idx:#15L (I.low_to_i8x16 x)
  | #16L -> Int8x16.extract ~idx:#0L (extract_lane ~idx:#1L x)
  | #17L -> Int8x16.extract ~idx:#1L (extract_lane ~idx:#1L x)
  | #18L -> Int8x16.extract ~idx:#2L (extract_lane ~idx:#1L x)
  | #19L -> Int8x16.extract ~idx:#3L (extract_lane ~idx:#1L x)
  | #20L -> Int8x16.extract ~idx:#4L (extract_lane ~idx:#1L x)
  | #21L -> Int8x16.extract ~idx:#5L (extract_lane ~idx:#1L x)
  | #22L -> Int8x16.extract ~idx:#6L (extract_lane ~idx:#1L x)
  | #23L -> Int8x16.extract ~idx:#7L (extract_lane ~idx:#1L x)
  | #24L -> Int8x16.extract ~idx:#8L (extract_lane ~idx:#1L x)
  | #25L -> Int8x16.extract ~idx:#9L (extract_lane ~idx:#1L x)
  | #26L -> Int8x16.extract ~idx:#10L (extract_lane ~idx:#1L x)
  | #27L -> Int8x16.extract ~idx:#11L (extract_lane ~idx:#1L x)
  | #28L -> Int8x16.extract ~idx:#12L (extract_lane ~idx:#1L x)
  | #29L -> Int8x16.extract ~idx:#13L (extract_lane ~idx:#1L x)
  | #30L -> Int8x16.extract ~idx:#14L (extract_lane ~idx:#1L x)
  | #31L -> Int8x16.extract ~idx:#15L (extract_lane ~idx:#1L x)
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] insert ~idx t x =
  match idx with
  | #0L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#0L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #1L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#1L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #2L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#2L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #3L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#3L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #4L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#4L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #5L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#5L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #6L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#6L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #7L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#7L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #8L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#8L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #9L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#9L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #10L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#10L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #11L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#11L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #12L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#12L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #13L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#13L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #14L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#14L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #15L ->
    let t' = I.low_of_i8x16 (Int8x16.insert ~idx:#15L (I.low_to_i8x16 t) x) in
    I.blend_32 [%blend 1, 1, 1, 1, 0, 0, 0, 0] t t'
  | #16L ->
    let t' = Int8x16.insert ~idx:#0L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #17L ->
    let t' = Int8x16.insert ~idx:#1L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #18L ->
    let t' = Int8x16.insert ~idx:#2L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #19L ->
    let t' = Int8x16.insert ~idx:#3L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #20L ->
    let t' = Int8x16.insert ~idx:#4L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #21L ->
    let t' = Int8x16.insert ~idx:#5L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #22L ->
    let t' = Int8x16.insert ~idx:#6L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #23L ->
    let t' = Int8x16.insert ~idx:#7L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #24L ->
    let t' = Int8x16.insert ~idx:#8L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #25L ->
    let t' = Int8x16.insert ~idx:#9L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #26L ->
    let t' = Int8x16.insert ~idx:#10L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #27L ->
    let t' = Int8x16.insert ~idx:#11L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #28L ->
    let t' = Int8x16.insert ~idx:#12L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #29L ->
    let t' = Int8x16.insert ~idx:#13L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #30L ->
    let t' = Int8x16.insert ~idx:#14L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | #31L ->
    let t' = Int8x16.insert ~idx:#15L (extract_lane ~idx:#1L t) x in
    insert_lane ~idx:#1L t t'
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] set_lanes a b = insert_lane ~idx:#1L (I.low_of_i8x16 a) b
let[@inline] select m ~fail ~pass = I.blendv_8 fail pass m
let[@inline] extract0 x = I.low_to x
let[@inline] extract_lane0 x = I.low_to_i8x16 x
let[@inline] movemask m = I.movemask_8 m

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
   , extract ~idx:#15L x
   , extract ~idx:#16L x
   , extract ~idx:#17L x
   , extract ~idx:#18L x
   , extract ~idx:#19L x
   , extract ~idx:#20L x
   , extract ~idx:#21L x
   , extract ~idx:#22L x
   , extract ~idx:#23L x
   , extract ~idx:#24L x
   , extract ~idx:#25L x
   , extract ~idx:#26L x
   , extract ~idx:#27L x
   , extract ~idx:#28L x
   , extract ~idx:#29L x
   , extract ~idx:#30L x
   , extract ~idx:#31L x )
;;

let[@inline] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline] ( = ) x y = I.cmpeq x y
let[@inline] ( > ) x y = I.cmpgt x y
let[@inline] ( < ) x y = I.cmpgt y x
let[@inline] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline] equal x y = I.cmpeq x y
let[@inline] interleave_upper_lanes ~even ~odd = I.interleave_high_8 even odd
let[@inline] interleave_lower_lanes ~even ~odd = I.interleave_low_8 even odd
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

external concat_shift_right_bytes_lanes
  :  int64#
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_align_right_bytes"
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

external multi_sum_absolute_differences_unsigned_lanes
  :  int64#
  -> t
  -> t
  -> int16x16#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int8x16x2_multi_sad_unsigned"
[@@noalloc] [@@builtin]

let[@inline] unsafe_of_int8x16 x = I.low_of_i8x16 x
let[@inline] of_float16x16_bits x = I.of_float16x16 x
let[@inline] of_float32x8_bits x = I.of_float32x8 x
let[@inline] of_float64x4_bits x = I.of_float64x4 x
let[@inline] of_int16x16_bits x = I.of_int16x16 x
let[@inline] of_int32x8_bits x = I.of_int32x8 x
let[@inline] of_int64x4_bits x = I.of_int64x4 x
let[@inline] of_int16x16_saturating_lanes x y = Int16x16_internal.(cvt_si8 x y)
let[@inline] of_int16x16_saturating_unsigned_lanes x y = Int16x16_internal.(cvt_su8 x y)

let[@inline] to_string x =
  let bx = Int8_u.to_int in
  let #( x0
       , x1
       , x2
       , x3
       , x4
       , x5
       , x6
       , x7
       , x8
       , x9
       , x10
       , x11
       , x12
       , x13
       , x14
       , x15
       , x16
       , x17
       , x18
       , x19
       , x20
       , x21
       , x22
       , x23
       , x24
       , x25
       , x26
       , x27
       , x28
       , x29
       , x30
       , x31 )
    =
    splat x
  in
  Stdlib.Printf.sprintf
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \
     %d %d %d %d %d)"
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
    (bx x16)
    (bx x17)
    (bx x18)
    (bx x19)
    (bx x20)
    (bx x21)
    (bx x22)
    (bx x23)
    (bx x24)
    (bx x25)
    (bx x26)
    (bx x27)
    (bx x28)
    (bx x29)
    (bx x30)
    (bx x31)
;;

let[@inline] of_string s =
  let ub = Int8_u.of_int in
  Stdlib.Scanf.sscanf
    s
    "(%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \
     %d %d %d %d %d)"
    (fun
        x0
        x1
        x2
        x3
        x4
        x5
        x6
        x7
        x8
        x9
        x10
        x11
        x12
        x13
        x14
        x15
        x16
        x17
        x18
        x19
        x20
        x21
        x22
        x23
        x24
        x25
        x26
        x27
        x28
        x29
        x30
        x31
      ->
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
         (ub x16)
         (ub x17)
         (ub x18)
         (ub x19)
         (ub x20)
         (ub x21)
         (ub x22)
         (ub x23)
         (ub x24)
         (ub x25)
         (ub x26)
         (ub x27)
         (ub x28)
         (ub x29)
         (ub x30)
         (ub x31)
       |> box)
  |> unbox
;;

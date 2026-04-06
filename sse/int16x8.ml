open Stdlib_stable
module I = Int16x8_internal

type t = int16x8#
type mask = int16x8#

external box : t -> int16x8 @@ portable = "%box_vec128"
external unbox : int16x8 @ local -> t @@ portable = "%unbox_vec128"

module Test = Test.Int16x8
module Raw = Load_store.Raw_Int16x8
module String = Load_store.String_Int16x8
module Bytes = Load_store.Bytes_Int16x8
module Bigstring = Load_store.Bigstring_Int16x8
module Int16_u_array = Load_store.Int16_u_array

external const1
  :  int16#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int16x8_const1"
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
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int16x8_const8"
[@@noalloc] [@@builtin]

external shuffle_upper
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_high_16"
[@@noalloc] [@@builtin amd64]

external shuffle_lower
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_low_16"
[@@noalloc] [@@builtin amd64]

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
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let zero = const1 #0S
let one = const1 #1S
let all_ones = const1 #0xffffS

let[@inline] set1 a =
  let a = I.low_of a in
  match Sys.arch with
  | Amd64 ->
    let pattern = const1 #0x01_00S in
    I.shuffle_8 a pattern
  | Arm64 -> I.Neon.broadcast a
;;

let[@inline] set a b c d e f g h =
  (*=movd, + 7x insert -> 15 cycle latency
     this              -> 5 cycle latency *)
  let a = I.low_of a in
  let c = I.low_of c in
  let e = I.low_of e in
  let g = I.low_of g in
  let ba = insert ~idx:#1L a b in
  let dc = insert ~idx:#1L c d in
  let fe = insert ~idx:#1L e f in
  let gh = insert ~idx:#1L g h in
  let dcba = I.interleave_low_32 ba dc in
  let ghfe = I.interleave_low_32 fe gh in
  I.interleave_low_64 dcba ghfe
;;

let[@inline] extract0 x = I.low_to x

let[@inline] splat x =
  (*=8x movd, 8x movzx, 6x shuffle_lower, shuffle_64 -> 6 cycle latency
     this                                            -> 5 cycle latency *)
  #( extract0 x
   , extract ~idx:#1L x
   , extract ~idx:#2L x
   , extract ~idx:#3L x
   , extract ~idx:#4L x
   , extract ~idx:#5L x
   , extract ~idx:#6L x
   , extract ~idx:#7L x )
;;

let[@inline] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline] ( = ) x y = I.cmpeq x y
let[@inline] ( > ) x y = I.cmpgt x y
let[@inline] ( < ) x y = I.cmpgt y x
let[@inline] ( <> ) x y = I.(xor all_ones (cmpeq x y))
let[@inline] equal x y = I.cmpeq x y
let[@inline] interleave_upper ~even ~odd = I.interleave_high_16 even odd
let[@inline] interleave_lower ~even ~odd = I.interleave_low_16 even odd

external blend
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_16"
[@@noalloc] [@@builtin amd64]

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
let[@inline] neg x = I.(mul_sign x all_ones)
let[@inline] abs x = I.abs x

external shifti_left_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_shift_left_bytes") (arm64, "caml_neon_vec128_shift_left_bytes")]

external shifti_right_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin
  (amd64, "caml_sse2_vec128_shift_right_bytes")
    (arm64, "caml_neon_vec128_shift_right_bytes")]

external shifti_left_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int16x8_slli") (arm64, "caml_neon_int16x8_slli")]

external shifti_right_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int16x8_srli") (arm64, "caml_neon_int16x8_srli")]

external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "ocaml_simd_sse_unreachable"
[@@noalloc]
[@@builtin (amd64, "caml_sse2_int16x8_srai") (arm64, "caml_neon_int16x8_srai")]

let[@inline] horizontal_add x y = I.horizontal_add x y
let[@inline] horizontal_sub x y = I.horizontal_sub x y
let[@inline] horizontal_add_saturating x y = I.horizontal_add_saturating x y
let[@inline] horizontal_sub_saturating x y = I.horizontal_sub_saturating x y
let[@inline] mul_sign x y = I.mul_sign x y
let[@inline] average_unsigned x y = I.avg_unsigned x y
let[@inline] minpos_unsigned x = I.minpos_unsigned x
let[@inline] ( + ) x y = I.add x y
let[@inline] ( - ) x y = I.sub x y
let[@inline] ( lor ) x y = I.or_ x y
let[@inline] ( land ) x y = I.and_ x y
let[@inline] ( lxor ) x y = I.xor x y
let[@inline] lnot m = I.(xor all_ones m)

let[@inline] landnot ~not y =
  match Sys.arch with
  | Amd64 -> I.Sse.andnot ~not y
  | Arm64 -> I.and_ (lnot not) y
;;

let[@inline] of_float16x8_bits x = I.of_float16x8 x
let[@inline] of_float32x4_bits x = I.of_float32x4 x
let[@inline] of_float64x2_bits x = I.of_float64x2 x
let[@inline] of_int8x16_bits x = I.of_int8x16 x
let[@inline] of_int32x4_bits x = I.of_int32x4 x
let[@inline] of_int64x2_bits x = I.of_int64x2 x
let[@inline] of_int8x16 x = Int8x16_internal.cvtsx_i16 x
let[@inline] of_int8x16_unsigned x = Int8x16_internal.cvtzx_i16 x
let[@inline] mul_low_bits x y = I.mul_low x y

let[@inline] mul_high_bits x y =
  match Sys.arch with
  | Amd64 -> I.Sse.mul_high x y
  | Arm64 ->
    let low = I.Neon.mul32_low x y |> Int32x4.shifti_right_arithmetic #16L in
    let high = I.Neon.mul32_high x y |> Int32x4.shifti_right_arithmetic #16L in
    let low = Int32x4_internal.Neon.cvt_i16_low low in
    Int32x4_internal.Neon.cvt_i16_high low high
;;

let[@inline] mul_high_bits_unsigned x y =
  match Sys.arch with
  | Amd64 -> I.Sse.mul_high_unsigned x y
  | Arm64 ->
    let low = I.Neon.mul32_low_unsigned x y |> Int32x4.shifti_right_arithmetic #16L in
    let high = I.Neon.mul32_high_unsigned x y |> Int32x4.shifti_right_arithmetic #16L in
    let low = Int32x4_internal.Neon.cvt_i16_low low in
    Int32x4_internal.Neon.cvt_i16_high low high
;;

let[@inline] mul_horizontal_add x y = I.mul_horizontal_add x y
let[@inline] mul_round x y = I.mul_round x y

let[@inline] of_int32x4_saturating x y =
  match Sys.arch with
  | Amd64 -> Int32x4_internal.Sse.cvt_si16 x y
  | Arm64 ->
    let low = Int32x4_internal.Neon.cvt_si16_low x in
    Int32x4_internal.Neon.cvt_si16_high low y
;;

let[@inline] of_int32x4_saturating_unsigned x y = Int32x4_internal.cvt_su16 x y

external i64_to_i16 : int64# -> int16# @@ portable = "%int16#_of_int64#"

let[@inline] shift_left_logical x i =
  match Sys.arch with
  | Amd64 ->
    let c = Int64x2_internal.low_of i in
    I.Sse.sll x c
  | Arm64 ->
    let c = I.low_of (i64_to_i16 i) in
    I.Neon.shift x (I.Neon.broadcast c)
;;

let[@inline] shift_right_logical x i =
  match Sys.arch with
  | Amd64 ->
    let c = Int64x2_internal.low_of i in
    I.Sse.srl x c
  | Arm64 ->
    let c = I.low_of (i64_to_i16 (Int64_u.neg i)) in
    I.Neon.shift_logical x (I.Neon.broadcast c)
;;

let[@inline] shift_right_arithmetic x i =
  match Sys.arch with
  | Amd64 ->
    let c = Int64x2_internal.low_of i in
    I.Sse.sra x c
  | Arm64 ->
    let c = I.low_of (i64_to_i16 (Int64_u.neg i)) in
    I.Neon.shift x (I.Neon.broadcast c)
;;

let[@inline] to_string x =
  let bx = Int16_u.to_int in
  let #(a, b, c, d, e, f, g, h) = splat x in
  Stdlib.Printf.sprintf
    "(%d %d %d %d %d %d %d %d)"
    (bx a)
    (bx b)
    (bx c)
    (bx d)
    (bx e)
    (bx f)
    (bx g)
    (bx h)
;;

let[@inline] of_string s =
  let ub = Int16_u.of_int in
  Stdlib.Scanf.sscanf s "(%d %d %d %d %d %d %d %d)" (fun a b c d e f g h ->
    set (ub a) (ub b) (ub c) (ub d) (ub e) (ub f) (ub g) (ub h) |> box)
  |> unbox
;;

module I = Int32x8_internal

type t = int32x8#
type mask = int32x8#

module Test = Test.Int32x8
module Raw = Load_store.Raw_Int32x8
module String = Load_store.String_Int32x8
module Bytes = Load_store.Bytes_Int32x8
module Bigstring = Load_store.Bigstring_Int32x8
module Int32_u_array = Load_store.Int32_u_array

external box : t -> int32x8 @@ portable = "%box_vec256"
external unbox : int32x8 @ local -> t @@ portable = "%unbox_vec256"

external const1
  :  int32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int32x8_const1"
[@@noalloc] [@@builtin]

external const
  :  int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> int32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int32x8_const8"
[@@noalloc] [@@builtin]

external shuffle_lanes
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_shuffle_32"
[@@noalloc] [@@builtin]

external permute_lanes
  :  (Ocaml_simd.Permute4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_permute_32"
[@@noalloc] [@@builtin]

external insert_lane
  :  idx:int64#
  -> t
  -> int32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

external extract_lane
  :  idx:int64#
  -> t
  -> int32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

external blend
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_32"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0l
let[@inline] one () = const1 #1l
let[@inline] all_ones () = const1 #0xffffffffl
let[@inline] set1 x = I.broadcast_32 (I.I32x4.low_of x)

let[@inline] set a b c d e f g h =
  let abcd = Int32x4.set a b c d in
  let efgh = Int32x4.set e f g h in
  insert_lane ~idx:#1L (I.low_of_i32x4 abcd) efgh
;;

let[@inline] insert ~idx t a =
  let a = set1 a in
  match idx with
  | #0L -> blend [%blend 1, 0, 0, 0, 0, 0, 0, 0] t a
  | #1L -> blend [%blend 0, 1, 0, 0, 0, 0, 0, 0] t a
  | #2L -> blend [%blend 0, 0, 1, 0, 0, 0, 0, 0] t a
  | #3L -> blend [%blend 0, 0, 0, 1, 0, 0, 0, 0] t a
  | #4L -> blend [%blend 0, 0, 0, 0, 1, 0, 0, 0] t a
  | #5L -> blend [%blend 0, 0, 0, 0, 0, 1, 0, 0] t a
  | #6L -> blend [%blend 0, 0, 0, 0, 0, 0, 1, 0] t a
  | #7L -> blend [%blend 0, 0, 0, 0, 0, 0, 0, 1] t a
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract ~idx x =
  match idx with
  | #0L -> I.low_to x
  | #1L ->
    let x = I.low_to_i32x4 x in
    Int32x4.extract ~idx:#1L x
  | #2L ->
    let x = I.low_to_i32x4 x in
    Int32x4.extract ~idx:#2L x
  | #3L ->
    let x = I.low_to_i32x4 x in
    Int32x4.extract ~idx:#3L x
  | #4L ->
    let x = extract_lane ~idx:#1L x in
    I.I32x4.low_to x
  | #5L ->
    let x = extract_lane ~idx:#1L x in
    Int32x4.extract ~idx:#1L x
  | #6L ->
    let x = extract_lane ~idx:#1L x in
    Int32x4.extract ~idx:#2L x
  | #7L ->
    let x = extract_lane ~idx:#1L x in
    Int32x4.extract ~idx:#3L x
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] set_lanes a b = insert_lane ~idx:#1L (I.low_of_i32x4 a) b
let[@inline] movemask m = I.movemask_32 m
let[@inline] select m ~fail ~pass = I.blendv_32 fail pass m
let[@inline] extract0 x = I.low_to x
let[@inline] extract_lane0 x = I.low_to_i32x4 x

let[@inline] splat x =
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
let[@inline] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline] equal x y = I.cmpeq x y
let[@inline] interleave_upper_lanes ~even ~odd = I.interleave_high_32 even odd
let[@inline] interleave_lower_lanes ~even ~odd = I.interleave_low_32 even odd
let[@inline] duplicate_even x = I.dup_even_32 x
let[@inline] duplicate_odd x = I.dup_odd_32 x
let[@inline] min x y = I.min x y
let[@inline] max x y = I.max x y
let[@inline] min_unsigned x y = I.min_unsigned x y
let[@inline] max_unsigned x y = I.max_unsigned x y
let[@inline] add x y = I.add x y
let[@inline] sub x y = I.sub x y
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
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_srli"
[@@noalloc] [@@builtin]

external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int32x8_srai"
[@@noalloc] [@@builtin]

let[@inline] horizontal_add_lanes x y = I.horizontal_add x y
let[@inline] horizontal_sub_lanes x y = I.horizontal_sub x y
let[@inline] mul_low_bits x y = I.mul_low x y
let[@inline] mul_even x y = I.mul_even x y
let[@inline] mul_even_unsigned x y = I.mul_even_unsigned x y
let[@inline] mul_sign x y = I.mul_sign x y
let[@inline] ( + ) x y = I.add x y
let[@inline] ( - ) x y = I.sub x y
let[@inline] ( lor ) x y = I.or_ x y
let[@inline] ( land ) x y = I.and_ x y
let[@inline] ( lxor ) x y = I.xor x y
let[@inline] lnot m = I.(xor (all_ones ()) m)
let[@inline] landnot ~not y = I.andnot ~not y
let[@inline] unsafe_of_int32x4 x = I.low_of_i32x4 x
let[@inline] of_float16x16_bits x = I.of_float16x16 x
let[@inline] of_float32x8_bits x = I.of_float32x8 x
let[@inline] of_float64x4_bits x = I.of_float64x4 x
let[@inline] of_int8x32_bits x = I.of_int8x32 x
let[@inline] of_int16x16_bits x = I.of_int16x16 x
let[@inline] of_int64x4_bits x = I.of_int64x4 x
let[@inline] of_float32x8 x = Float32x8_internal.cvt_i32 x
let[@inline] of_float32x8_trunc x = Float32x8_internal.cvtt_i32 x
let[@inline] of_int8x16 x = Int8x32_internal.I8x16.cvtsx_i32 x
let[@inline] of_int8x16_unsigned x = Int8x32_internal.I8x16.cvtzx_i32 x
let[@inline] of_int16x8 x = Int16x16_internal.I16x8.cvtsx_i32 x
let[@inline] of_int16x8_unsigned x = Int16x16_internal.I16x8.cvtzx_i32 x

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

let[@inline] shift_left_logical_by x ~shift = I.sllv x shift
let[@inline] shift_right_logical_by x ~shift = I.srlv x shift
let[@inline] shift_right_arithmetic_by x ~shift = I.srav x shift

let[@inline] to_string x =
  let bx = Int32_u.to_int32 in
  let #(x0, x1, x2, x3, x4, x5, x6, x7) = splat x in
  Stdlib.Printf.sprintf
    "(%ld %ld %ld %ld %ld %ld %ld %ld)"
    (bx x0)
    (bx x1)
    (bx x2)
    (bx x3)
    (bx x4)
    (bx x5)
    (bx x6)
    (bx x7)
;;

let[@inline] of_string s =
  let ub = Int32_u.of_int32 in
  Stdlib.Scanf.sscanf
    s
    "(%ld %ld %ld %ld %ld %ld %ld %ld)"
    (fun x0 x1 x2 x3 x4 x5 x6 x7 ->
       set (ub x0) (ub x1) (ub x2) (ub x3) (ub x4) (ub x5) (ub x6) (ub x7) |> box)
  |> unbox
;;

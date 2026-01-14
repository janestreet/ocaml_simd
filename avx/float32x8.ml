module I = Float32x8_internal

type t = float32x8#
type mask = int32x8#

external box : t -> float32x8 @@ portable = "%box_vec256"
external unbox : float32x8 @ local -> t @@ portable = "%unbox_vec256"

module Raw = Load_store.Raw_Float32x8
module String = Load_store.String_Float32x8
module Bytes = Load_store.Bytes_Float32x8
module Bigstring = Load_store.Bigstring_Float32x8
module Float32_u_array = Load_store.Float32_u_array

external const1
  :  float32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float32x8_const1"
[@@noalloc] [@@builtin]

external const
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> float32#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float32x8_const8"
[@@noalloc] [@@builtin]

external insert_lane
  :  idx:int64#
  -> t
  -> float32x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

external extract_lane
  :  idx:int64#
  -> t
  -> float32x4#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0.0s
let[@inline] one () = const1 #1.0s
let[@inline] sign32_mask () = Int32x8_internal.const1 #0x80000000l
let[@inline] absf32_mask () = Int32x8_internal.const1 #0x7fffffffl
let[@inline] set1 x = I.broadcast_32 (I.F32x4.low_of x)

let[@inline] set a b c d e f g h =
  let abcd = Float32x4.set a b c d in
  let efgh = Float32x4.set e f g h in
  insert_lane ~idx:#1L (I.low_of_f32x4 abcd) efgh
;;

let[@inline] set_lanes a b = insert_lane ~idx:#1L (I.low_of_f32x4 a) b

external blend
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_32"
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

external permute_lanes_by
  :  t
  -> idx:int32x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_permutev_32"
[@@noalloc] [@@builtin]

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
    let x = I.low_to_f32x4 x in
    I.F32x4.low_to (Float32x4.shuffle [%shuffle 1, 0, 0, 0] x x)
  | #2L ->
    let x = I.low_to_f32x4 x in
    I.F32x4.low_to (Float32x4.shuffle [%shuffle 2, 0, 0, 0] x x)
  | #3L ->
    let x = I.low_to_f32x4 x in
    I.F32x4.low_to (Float32x4.shuffle [%shuffle 3, 0, 0, 0] x x)
  | #4L ->
    let x = extract_lane ~idx:#1L x in
    I.F32x4.low_to x
  | #5L ->
    let x = extract_lane ~idx:#1L x in
    I.F32x4.low_to (Float32x4.shuffle [%shuffle 1, 0, 0, 0] x x)
  | #6L ->
    let x = extract_lane ~idx:#1L x in
    I.F32x4.low_to (Float32x4.shuffle [%shuffle 2, 0, 0, 0] x x)
  | #7L ->
    let x = extract_lane ~idx:#1L x in
    I.F32x4.low_to (Float32x4.shuffle [%shuffle 3, 0, 0, 0] x x)
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract0 x = I.low_to x
let[@inline] extract_lane0 x = I.low_to_f32x4 x
let[@inline] movemask m = Int32x8_internal.movemask_32 m
let[@inline] select m ~fail ~pass = I.blendv_32 fail pass m
let[@inline] bitmask m = m

let[@inline] splat x =
  let abcd = I.low_to_f32x4 x in
  let efgh = extract_lane ~idx:#1L x in
  let b = Float32x4.shuffle [%shuffle 1, 0, 0, 0] abcd abcd in
  let c = Float32x4.shuffle [%shuffle 2, 0, 0, 0] abcd abcd in
  let d = Float32x4.shuffle [%shuffle 3, 0, 0, 0] abcd abcd in
  let f = Float32x4.shuffle [%shuffle 1, 0, 0, 0] efgh efgh in
  let g = Float32x4.shuffle [%shuffle 2, 0, 0, 0] efgh efgh in
  let h = Float32x4.shuffle [%shuffle 3, 0, 0, 0] efgh efgh in
  #( I.low_to x
   , I.F32x4.low_to b
   , I.F32x4.low_to c
   , I.F32x4.low_to d
   , I.F32x4.low_to efgh
   , I.F32x4.low_to f
   , I.F32x4.low_to g
   , I.F32x4.low_to h )
;;

(* Comparisons do not use [C.not_...], as they have different NaN behavior. *)
let[@inline] ( >= ) x y = I.cmp [%float_compare Less_or_equal] y x
let[@inline] ( <= ) x y = I.cmp [%float_compare Less_or_equal] x y
let[@inline] ( = ) x y = I.cmp [%float_compare Equal] x y
let[@inline] ( > ) x y = I.cmp [%float_compare Less] y x
let[@inline] ( < ) x y = I.cmp [%float_compare Less] x y
let[@inline] ( <> ) x y = I.cmp [%float_compare Not_equal] x y
let[@inline] equal x y = I.cmp [%float_compare Equal] x y
let[@inline] is_nan x = I.cmp [%float_compare Unordered] x x
let[@inline] is_not_nan x = I.cmp [%float_compare Ordered] x x
let[@inline] interleave_upper_lanes ~even ~odd = I.interleave_high_32 even odd
let[@inline] interleave_lower_lanes ~even ~odd = I.interleave_low_32 even odd
let[@inline] duplicate_even x = I.dup_even_32 x
let[@inline] duplicate_odd x = I.dup_odd_32 x
let[@inline] min x y = I.min x y
let[@inline] max x y = I.max x y
let[@inline] add x y = I.add x y
let[@inline] sub x y = I.sub x y
let[@inline] mul x y = I.mul x y
let[@inline] div x y = I.div x y

let[@inline] neg x =
  Int32x8_internal.(xor (sign32_mask ()) (of_float32x8 x)) |> I.of_int32x8
;;

let[@inline] abs x =
  Int32x8_internal.(and_ (absf32_mask ()) (of_float32x8 x)) |> I.of_int32x8
;;

let[@inline] rcp x = I.rcp x
let[@inline] rsqrt x = I.rsqrt x
let[@inline] sqrt x = I.sqrt x
let[@inline] add_sub x y = I.addsub x y
let[@inline] horizontal_add_lanes x y = I.hadd x y
let[@inline] horizontal_sub_lanes x y = I.hsub x y

let[@inline] dot x y =
  (* Mask 0xf1:
     - High nibble 0xf = 1111: multiply and sum elements 0,1,2,3 in each 128-bit lane
     - Low nibble 0x1 = 0001: store result in position 0 of each lane *)
  let p = I.dp #0xf1L x y in
  (* [p] stores two partial dot products, one from each lane, at idx 0 *)
  let p0 = I.low_to p in
  let p1 = I.F32x4.low_to (extract_lane ~idx:#1L p) in
  Float32_u.(p0 + p1)
;;

let[@inline] mul_add x y z = I.mul_add x y z
let[@inline] mul_sub x y z = I.mul_sub x y z
let[@inline] neg_mul_add x y z = I.neg_mul_add x y z
let[@inline] neg_mul_sub x y z = I.neg_mul_sub x y z
let[@inline] mul_add_sub x y z = I.mul_add_sub x y z
let[@inline] mul_sub_add x y z = I.mul_sub_add x y z
let[@inline] ( + ) x y = I.add x y
let[@inline] ( - ) x y = I.sub x y
let[@inline] ( / ) x y = I.div x y
let[@inline] ( * ) x y = I.mul x y
let[@inline] iround_current x = I.cvt_i32 x
let[@inline] round_nearest x = I.round [%float_round Nearest] x
let[@inline] round_current x = I.round [%float_round Current] x
let[@inline] round_down x = I.round [%float_round Negative_infinity] x
let[@inline] round_up x = I.round [%float_round Positive_infinity] x
let[@inline] round_toward_zero x = I.round [%float_round Zero] x
let[@inline] unsafe_of_float32 x = I.low_of x
let[@inline] unsafe_of_float32x4 x = I.low_of_f32x4 x
let[@inline] of_float16x16_bits x = I.of_float16x16 x
let[@inline] of_float64x4_bits x = I.of_float64x4 x
let[@inline] of_int8x32_bits x = I.of_int8x32 x
let[@inline] of_int16x16_bits x = I.of_int16x16 x
let[@inline] of_int32x8_bits x = I.of_int32x8 x
let[@inline] of_int64x4_bits x = I.of_int64x4 x
let[@inline] of_int32x8 x = Int32x8_internal.cvt_f32 x

external of_float16x8
  :  float16x8#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_f16c_cvt_float16x8_float32x8"
[@@noalloc] [@@builtin]

let[@inline] to_string x =
  let bx x = Float32_u.to_float x in
  let #(a, b, c, d, e, f, g, h) = splat x in
  Stdlib.Printf.sprintf
    "(%.9g %.9g %.9g %.9g %.9g %.9g %.9g %.9g)"
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
  let ub x = Float32_u.of_float x in
  Stdlib.Scanf.sscanf s "(%g %g %g %g %g %g %g %g)" (fun a b c d e f g h ->
    set (ub a) (ub b) (ub c) (ub d) (ub e) (ub f) (ub g) (ub h) |> box)
  |> unbox
;;

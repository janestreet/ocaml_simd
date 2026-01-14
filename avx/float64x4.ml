module I = Float64x4_internal

type t = float64x4#
type mask = int64x4#

external box : t -> float64x4 @@ portable = "%box_vec256"
external unbox : float64x4 @ local -> t @@ portable = "%unbox_vec256"

module Raw = Load_store.Raw_Float64x4
module String = Load_store.String_Float64x4
module Bytes = Load_store.Bytes_Float64x4
module Bigstring = Load_store.Bigstring_Float64x4
module Float_array = Load_store.Float_array
module Float_iarray = Load_store.Float_iarray
module Floatarray = Load_store.Floatarray
module Float_u_array = Load_store.Float_u_array

external const1
  :  float#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float64x4_const1"
[@@noalloc] [@@builtin]

external const
  :  float#
  -> float#
  -> float#
  -> float#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_float64x4_const4"
[@@noalloc] [@@builtin]

external shuffle_lanes
  :  (Ocaml_simd.Shuffle2x2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_shuffle_64"
[@@noalloc] [@@builtin]

external blend
  :  (Ocaml_simd.Blend4.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_64"
[@@noalloc] [@@builtin]

external permute
  :  (Ocaml_simd.Permute4.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_vec256_permute_64"
[@@noalloc] [@@builtin]

external permute_lanes
  :  (Ocaml_simd.Permute2x2.t[@untagged])
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_permute_64"
[@@noalloc] [@@builtin]

external permute_lanes_by
  :  t
  -> idx:int64x4#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_permutev_64"
[@@noalloc] [@@builtin]

external insert_lane
  :  idx:int64#
  -> t
  -> float64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

external extract_lane
  :  idx:int64#
  -> t
  -> float64x2#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0.0
let[@inline] one () = const1 #1.0
let[@inline] sign64_mask () = Int64x4_internal.const1 #0x8000000000000000L
let[@inline] absf64_mask () = Int64x4_internal.const1 #0x7fffffffffffffffL
let[@inline] set1 x = I.broadcast_64 (I.F64x2.low_of x)

let[@inline] set a b c d =
  let ab = Float64x2.set a b in
  let cd = Float64x2.set c d in
  insert_lane ~idx:#1L (I.low_of_f64x2 ab) cd
;;

let[@inline] set_lanes a b = insert_lane ~idx:#1L (I.low_of_f64x2 a) b

let[@inline] insert ~idx t a =
  let a = set1 a in
  match idx with
  | #0L -> blend [%blend 1, 0, 0, 0] t a
  | #1L -> blend [%blend 0, 1, 0, 0] t a
  | #2L -> blend [%blend 0, 0, 1, 0] t a
  | #3L -> blend [%blend 0, 0, 0, 1] t a
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract ~idx x =
  match idx with
  | #0L -> I.low_to x
  | #1L ->
    let x = I.low_to_f64x2 x in
    I.F64x2.low_to (Float64x2.shuffle [%shuffle 1, 0] x x)
  | #2L ->
    let x = extract_lane ~idx:#1L x in
    I.F64x2.low_to x
  | #3L ->
    let x = extract_lane ~idx:#1L x in
    I.F64x2.low_to (Float64x2.shuffle [%shuffle 1, 0] x x)
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] splat x =
  let ab = I.low_to_f64x2 x in
  let b = I.F64x2.low_to (Float64x2.shuffle [%shuffle 1, 0] ab ab) in
  let cd = extract_lane ~idx:#1L x in
  let d = I.F64x2.low_to (Float64x2.shuffle [%shuffle 1, 0] cd cd) in
  #(I.low_to x, b, I.F64x2.low_to cd, d)
;;

let[@inline] movemask m = Int64x4_internal.movemask_64 m
let[@inline] select m ~fail ~pass = I.blendv_64 fail pass m
let[@inline] extract0 x = I.low_to x
let[@inline] extract_lane0 x = I.low_to_f64x2 x
let[@inline] bitmask m = m

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
let[@inline] interleave_upper_lanes ~even ~odd = I.interleave_high_64 even odd
let[@inline] interleave_lower_lanes ~even ~odd = I.interleave_low_64 even odd
let[@inline] duplicate_even x = I.dup_even_64 x
let[@inline] min x y = I.min x y
let[@inline] max x y = I.max x y
let[@inline] add x y = I.add x y
let[@inline] sub x y = I.sub x y
let[@inline] mul x y = I.mul x y
let[@inline] div x y = I.div x y

let[@inline] neg x =
  Int64x4_internal.(xor (sign64_mask ()) (of_float64x4 x)) |> I.of_int64x4
;;

let[@inline] abs x =
  Int64x4_internal.(and_ (absf64_mask ()) (of_float64x4 x)) |> I.of_int64x4
;;

let[@inline] sqrt x = I.sqrt x
let[@inline] add_sub x y = I.addsub x y
let[@inline] horizontal_add_lanes x y = I.hadd x y
let[@inline] horizontal_sub_lanes x y = I.hsub x y
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
let[@inline] iround_current x = Float64x4_internal.cvt_i32 x
let[@inline] round_nearest x = I.round [%float_round Nearest] x
let[@inline] round_current x = I.round [%float_round Current] x
let[@inline] round_down x = I.round [%float_round Negative_infinity] x
let[@inline] round_up x = I.round [%float_round Positive_infinity] x
let[@inline] round_toward_zero x = I.round [%float_round Zero] x
let[@inline] unsafe_of_float f = I.low_of f
let[@inline] unsafe_of_float64x2 f = I.low_of_f64x2 f
let[@inline] of_float16x16_bits x = I.of_float16x16 x
let[@inline] of_float32x8_bits x = I.of_float32x8 x
let[@inline] of_int8x32_bits x = I.of_int8x32 x
let[@inline] of_int16x16_bits x = I.of_int16x16 x
let[@inline] of_int32x8_bits x = I.of_int32x8 x
let[@inline] of_int64x4_bits x = I.of_int64x4 x
let[@inline] of_float32x4 x = Float32x8_internal.F32x4.cvt_f64 x
let[@inline] of_int32x4 x = Int32x8_internal.I32x4.cvt_f64 x

let[@inline] to_string x =
  let bx = Float_u.to_float in
  let #(a, b, c, d) = splat x in
  Stdlib.Printf.sprintf "(%.17g %.17g %.17g %.17g)" (bx a) (bx b) (bx c) (bx d)
;;

let[@inline] of_string s =
  let ub = Float_u.of_float in
  Stdlib.Scanf.sscanf s "(%g %g %g %g)" (fun a b c d ->
    set (ub a) (ub b) (ub c) (ub d) |> box)
  |> unbox
;;

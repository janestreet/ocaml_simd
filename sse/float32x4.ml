module I = Float32x4_internal

type t = float32x4#
type mask = int32x4#

external box : t -> float32x4 @@ portable = "%box_vec128"
external unbox : float32x4 @ local -> t @@ portable = "%unbox_vec128"

module Raw = Load_store.Raw_Float32x4
module String = Load_store.String_Float32x4
module Bytes = Load_store.Bytes_Float32x4
module Bigstring = Load_store.Bigstring_Float32x4
module Float32_u_array = Load_store.Float32_u_array

external const1
  :  float32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_float32x4_const1"
[@@noalloc] [@@builtin]

external const
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_float32x4_const4"
[@@noalloc] [@@builtin]

external shuffle
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse_vec128_shuffle_32"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0.0s
let[@inline] one () = const1 #1.0s
let[@inline] sign32_mask () = Int32x4_internal.const1 #0x80000000l
let[@inline] absf32_mask () = Int32x4_internal.const1 #0x7fffffffl

let[@inline] set1 a =
  let a = I.low_of a in
  shuffle [%shuffle 0, 0, 0, 0] a a
;;

let[@inline] set a b c d =
  (*=4x cvt,3x insertps -> 8 cycle latency
     this               -> 7 cycle latency *)
  let a = I.low_of a in
  let b = I.low_of b in
  let c = I.low_of c in
  let d = I.low_of d in
  let ab = I.interleave_low_32 a b in
  let cd = I.interleave_low_32 c d in
  I.interleave_low_64 ab cd
;;

external blend
  :  (Ocaml_simd.Blend4.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_32"
[@@noalloc] [@@builtin]

let[@inline] insert ~idx t a =
  let aaaa = set1 a in
  match idx with
  | #0L -> blend [%blend 1, 0, 0, 0] t aaaa
  | #1L -> blend [%blend 0, 1, 0, 0] t aaaa
  | #2L -> blend [%blend 0, 0, 1, 0] t aaaa
  | #3L -> blend [%blend 0, 0, 0, 1] t aaaa
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract ~idx x =
  (* extractps converts to an int register *)
  let x =
    match idx with
    | #0L -> x
    | #1L -> shuffle [%shuffle 1, 0, 0, 0] x x
    | #2L -> shuffle [%shuffle 2, 0, 0, 0] x x
    | #3L -> shuffle [%shuffle 3, 0, 0, 0] x x
    | _ ->
      (match failwith "Invalid index." with
       | (_ : Base.Nothing.t) -> .)
  in
  I.low_to x
;;

let[@inline] splat x =
  (* Can't use extractps (returns int register) *)
  let b = shuffle [%shuffle 1, 0, 0, 0] x x in
  let c = shuffle [%shuffle 2, 0, 0, 0] x x in
  let d = shuffle [%shuffle 3, 0, 0, 0] x x in
  #(I.low_to x, I.low_to b, I.low_to c, I.low_to d)
;;

let[@inline] movemask m = Int32x4_internal.movemask_32 m
let[@inline] select m ~fail ~pass = I.blendv_32 fail pass m
let[@inline] extract0 x = I.low_to x
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
let[@inline] interleave_upper ~even ~odd = I.interleave_high_32 even odd
let[@inline] interleave_lower ~even ~odd = I.interleave_low_32 even odd
let[@inline] duplicate_even x = I.dup_even_32 x
let[@inline] duplicate_odd x = I.dup_odd_32 x
let[@inline] min x y = I.min x y
let[@inline] max x y = I.max x y
let[@inline] add x y = I.add x y
let[@inline] sub x y = I.sub x y
let[@inline] mul x y = I.mul x y
let[@inline] div x y = I.div x y

let[@inline] neg x =
  Int32x4_internal.(xor (sign32_mask ()) (of_float32x4 x)) |> I.of_int32x4
;;

let[@inline] abs x =
  Int32x4_internal.(and_ (absf32_mask ()) (of_float32x4 x)) |> I.of_int32x4
;;

let[@inline] rcp x = I.rcp x
let[@inline] rsqrt x = I.rsqrt x
let[@inline] sqrt x = I.sqrt x
let[@inline] add_sub x y = I.addsub x y
let[@inline] horizontal_add x y = I.horizontal_add x y
let[@inline] horizontal_sub x y = I.horizontal_sub x y
let[@inline] dot x y = I.dp #0xf1L x y |> I.low_to
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
let[@inline] of_float16x8_bits x = I.of_float16x8 x
let[@inline] of_float64x2_bits x = I.of_float64x2 x
let[@inline] of_int8x16_bits x = I.of_int8x16 x
let[@inline] of_int16x8_bits x = I.of_int16x8 x
let[@inline] of_int32x4_bits x = I.of_int32x4 x
let[@inline] of_int64x2_bits x = I.of_int64x2 x
let[@inline] of_int32x4 x = Int32x4_internal.cvt_f32 x
let[@inline] of_float64x2 x = Float64x2_internal.cvt_f32 x

let[@inline] to_string x =
  let f x = Float32_u.to_float x in
  let #(a, b, c, d) = splat x in
  Stdlib.Printf.sprintf "(%.9g %.9g %.9g %.9g)" (f a) (f b) (f c) (f d)
;;

let[@inline] of_string s =
  let f x = Float32_u.of_float x in
  Stdlib.Scanf.sscanf s "(%g %g %g %g)" (fun a b c d ->
    set (f a) (f b) (f c) (f d) |> box)
  |> unbox
;;

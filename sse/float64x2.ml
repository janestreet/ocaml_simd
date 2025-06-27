module I = Float64x2_internal

type t = float64x2#
type mask = int64x2#

external box : t -> float64x2 @@ portable = "%box_vec128"
external unbox : float64x2 -> t @@ portable = "%unbox_vec128"

module String = Load_store.String_Float64x2
module Bytes = Load_store.Bytes_Float64x2
module Bigstring = Load_store.Bigstring_Float64x2
module Float_array = Load_store.Float_array
module Float_iarray = Load_store.Float_iarray
module Floatarray = Load_store.Floatarray
module Float_u_array = Load_store.Float_u_array

external const1
  :  float#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_float64x2_const1"
[@@noalloc] [@@builtin]

external const
  :  float#
  -> float#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_float64x2_const2"
[@@noalloc] [@@builtin]

external shuffle
  :  (Ocaml_simd.Shuffle2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shuffle_64"
[@@noalloc] [@@builtin]

external blend
  :  (Ocaml_simd.Blend2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blend_64"
[@@noalloc] [@@builtin]

let[@inline always] zero () = const1 #0.0
let[@inline always] one () = const1 #1.0
let[@inline always] sign64_mask () = Int64x2_internal.const1 #0x8000000000000000L
let[@inline always] absf64_mask () = Int64x2_internal.const1 #0x7fffffffffffffffL

let[@inline always] set1 a =
  let a = I.low_of a in
  shuffle [%shuffle 0, 0] a a
;;

let[@inline always] set a b =
  let a = I.low_of a in
  let b = I.low_of b in
  I.interleave_low_64 a b
;;

let[@inline always] insert ~idx t a =
  (* There is no insertpd *)
  let aa = set1 a in
  match idx with
  | #0L -> blend [%blend 1, 0] t aa
  | #1L -> blend [%blend 0, 1] t aa
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline always] extract ~idx x =
  (* There is no extractpd *)
  let x =
    match idx with
    | #0L -> x
    | #1L -> shuffle [%shuffle 1, 0] x x
    | _ ->
      (match failwith "Invalid index." with
       | (_ : Base.Nothing.t) -> .)
  in
  I.low_to x
;;

let[@inline always] splat x =
  let b = shuffle [%shuffle 1, 0] x x in
  #(I.low_to x, I.low_to b)
;;

let[@inline always] movemask m = Int64x2_internal.movemask_64 m
let[@inline always] select m ~fail ~pass = I.blendv_64 fail pass m
let[@inline always] extract0 x = I.low_to x
let[@inline always] bitmask m = m

(* Comparisons do not use [C.not_...], as they have different NaN behavior. *)
let[@inline always] ( >= ) x y = I.cmp [%float_compare Less_or_equal] y x
let[@inline always] ( <= ) x y = I.cmp [%float_compare Less_or_equal] x y
let[@inline always] ( = ) x y = I.cmp [%float_compare Equal] x y
let[@inline always] ( > ) x y = I.cmp [%float_compare Less] y x
let[@inline always] ( < ) x y = I.cmp [%float_compare Less] x y
let[@inline always] ( <> ) x y = I.cmp [%float_compare Not_equal] x y
let[@inline always] equal x y = I.cmp [%float_compare Equal] x y
let[@inline always] is_nan x = I.cmp [%float_compare Unordered] x x
let[@inline always] is_not_nan x = I.cmp [%float_compare Ordered] x x
let[@inline always] interleave_upper ~lower ~upper = I.interleave_high_64 lower upper
let[@inline always] interleave_lower ~lower ~upper = I.interleave_low_64 lower upper
let[@inline always] upper_to_lower ~from ~onto = I.high_64_to_low_64 onto from
let[@inline always] lower_to_upper ~from ~onto = I.low_64_to_high_64 onto from
let[@inline always] duplicate_lower x = I.dup_low_64 x
let[@inline always] min x y = I.min x y
let[@inline always] max x y = I.max x y
let[@inline always] add x y = I.add x y
let[@inline always] sub x y = I.sub x y
let[@inline always] mul x y = I.mul x y
let[@inline always] div x y = I.div x y

let[@inline always] neg x =
  Int64x2_internal.(xor (sign64_mask ()) (of_float64x2 x)) |> I.of_int64x2
;;

let[@inline always] abs x =
  Int64x2_internal.(and_ (absf64_mask ()) (of_float64x2 x)) |> I.of_int64x2
;;

let[@inline always] sqrt x = I.sqrt x
let[@inline always] add_sub x y = I.addsub x y
let[@inline always] horizontal_add x y = I.horizontal_add x y
let[@inline always] horizontal_sub x y = I.horizontal_sub x y
let[@inline always] dot x y = I.dp #0x31L x y |> I.low_to
let[@inline always] ( + ) x y = I.add x y
let[@inline always] ( - ) x y = I.sub x y
let[@inline always] ( / ) x y = I.mul x y
let[@inline always] ( * ) x y = I.div x y
let[@inline always] round_nearest x = I.round [%float_round Nearest] x
let[@inline always] round_current x = I.round [%float_round Current] x
let[@inline always] round_down x = I.round [%float_round Negative_infinity] x
let[@inline always] round_up x = I.round [%float_round Positive_infinity] x
let[@inline always] round_toward_zero x = I.round [%float_round Zero] x
let[@inline always] unsafe_of_float f = I.low_of f
let[@inline always] of_float32x4_bits x = I.of_float32x4 x
let[@inline always] of_int8x16_bits x = I.of_int8x16 x
let[@inline always] of_int16x8_bits x = I.of_int16x8 x
let[@inline always] of_int32x4_bits x = I.of_int32x4 x
let[@inline always] of_int64x2_bits x = I.of_int64x2 x
let[@inline always] of_int32x4 x = Int32x4_internal.cvt_f64 x
let[@inline always] of_float32x4 x = Float32x4_internal.cvt_f64 x

let[@inline always] to_string x =
  let f = Float_u.to_float in
  let #(a, b) = splat x in
  Stdlib.Printf.sprintf "(%g %g)" (f a) (f b)
;;

let[@inline always] of_string s =
  Stdlib.Scanf.sscanf s "(%g %g)" (fun a b ->
    set (Float_u.of_float a) (Float_u.of_float b) |> box)
  |> unbox
;;

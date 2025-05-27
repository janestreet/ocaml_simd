module I = Float32x4_internal
module C = Float_ctrl.Compare
module R = Float_ctrl.Round

type t = float32x4#
type mask = int32x4#

external box : t -> float32x4 = "%box_vec128"
external unbox : float32x4 -> t = "%unbox_vec128"

module String = Load_store.String_Float32x4
module Bytes = Load_store.Bytes_Float32x4
module Bigstring = Load_store.Bigstring_Float32x4
module Float32_u_array = Load_store.Float32_u_array

external const1
  :  float32#
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_float32x4_const1"
[@@noalloc] [@@builtin]

external const
  :  float32#
  -> float32#
  -> float32#
  -> float32#
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_float32x4_const4"
[@@noalloc] [@@builtin]

external shuffle
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse_vec128_shuffle_32"
[@@noalloc] [@@builtin]

let[@inline always] zero () = const1 #0.0s
let[@inline always] one () = const1 #1.0s
let[@inline always] sign32_mask () = Int32x4_internal.const1 #0x80000000l
let[@inline always] absf32_mask () = Int32x4_internal.const1 #0x7fffffffl

let[@inline always] set1 a =
  let a = I.low_of a in
  shuffle [%shuffle 0, 0, 0, 0] a a
;;

let[@inline always] set a b c d =
  (* 4x cvt,3x insertps -> 8 cycle latency
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
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blend_32"
[@@noalloc] [@@builtin]

let[@inline always] insert ~idx t a =
  let aaaa = set1 a in
  match idx with
  | 0 -> blend [%blend 1, 0, 0, 0] t aaaa
  | 1 -> blend [%blend 0, 1, 0, 0] t aaaa
  | 2 -> blend [%blend 0, 0, 1, 0] t aaaa
  | 3 -> blend [%blend 0, 0, 0, 1] t aaaa
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline always] extract ~idx x =
  (* extractps converts to an int register *)
  let x =
    match idx with
    | 0 -> x
    | 1 -> shuffle [%shuffle 1, 0, 0, 0] x x
    | 2 -> shuffle [%shuffle 2, 0, 0, 0] x x
    | 3 -> shuffle [%shuffle 3, 0, 0, 0] x x
    | _ ->
      (match failwith "Invalid index." with
       | (_ : Base.Nothing.t) -> .)
  in
  I.low_to x
;;

type splat =
  { a : float32#
  ; b : float32#
  ; c : float32#
  ; d : float32#
  }

let[@inline always] splat x =
  (* Can't use extractps (returns int register) *)
  let b = shuffle [%shuffle 1, 0, 0, 0] x x in
  let c = shuffle [%shuffle 2, 0, 0, 0] x x in
  let d = shuffle [%shuffle 3, 0, 0, 0] x x in
  { a = I.low_to x; b = I.low_to b; c = I.low_to c; d = I.low_to d }
;;

let[@inline always] movemask m = Int32x4_internal.movemask_32 m
let[@inline always] select m ~fail ~pass = I.blendv_32 fail pass m
let[@inline always] extract0 x = I.low_to x
let[@inline always] bitmask m = m

(* Comparisons do not use [C.not_...], as they have different NaN behavior. *)
let[@inline always] ( >= ) x y = I.cmp C.less_or_equal y x
let[@inline always] ( <= ) x y = I.cmp C.less_or_equal x y
let[@inline always] ( = ) x y = I.cmp C.equal x y
let[@inline always] ( > ) x y = I.cmp C.less y x
let[@inline always] ( < ) x y = I.cmp C.less x y
let[@inline always] ( <> ) x y = I.cmp C.not_equal x y
let[@inline always] equal x y = I.cmp C.equal x y
let[@inline always] is_nan x = I.cmp C.unordered x x
let[@inline always] is_not_nan x = I.cmp C.ordered x x
let[@inline always] interleave_upper ~lower ~upper = I.interleave_high_32 lower upper
let[@inline always] interleave_lower ~lower ~upper = I.interleave_low_32 lower upper
let[@inline always] duplicate_even x = I.dup_even_32 x
let[@inline always] duplicate_odd x = I.dup_odd_32 x
let[@inline always] min x y = I.min x y
let[@inline always] max x y = I.max x y
let[@inline always] add x y = I.add x y
let[@inline always] sub x y = I.sub x y
let[@inline always] mul x y = I.mul x y
let[@inline always] div x y = I.div x y

let[@inline always] neg x =
  Int32x4_internal.(xor (sign32_mask ()) (of_float32x4 x)) |> I.of_int32x4
;;

let[@inline always] abs x =
  Int32x4_internal.(and_ (absf32_mask ()) (of_float32x4 x)) |> I.of_int32x4
;;

let[@inline always] rcp x = I.rcp x
let[@inline always] rsqrt x = I.rsqrt x
let[@inline always] sqrt x = I.sqrt x
let[@inline always] add_sub x y = I.addsub x y
let[@inline always] horizontal_add x y = I.horizontal_add x y
let[@inline always] horizontal_sub x y = I.horizontal_sub x y
let[@inline always] dot x y = I.dp 0xf1 x y |> I.low_to
let[@inline always] ( + ) x y = I.add x y
let[@inline always] ( - ) x y = I.sub x y
let[@inline always] ( / ) x y = I.mul x y
let[@inline always] ( * ) x y = I.div x y
let[@inline always] iround_current x = I.cvt_i32 x
let[@inline always] round_nearest x = I.round R.nearest x
let[@inline always] round_current x = I.round R.current x
let[@inline always] round_down x = I.round R.negative_infinity x
let[@inline always] round_up x = I.round R.positive_infinity x
let[@inline always] round_toward_zero x = I.round R.zero x
let[@inline always] of_float64x2_bits x = I.of_float64x2 x
let[@inline always] of_int8x16_bits x = I.of_int8x16 x
let[@inline always] of_int16x8_bits x = I.of_int16x8 x
let[@inline always] of_int32x4_bits x = I.of_int32x4 x
let[@inline always] of_int64x2_bits x = I.of_int64x2 x
let[@inline always] of_int32x4 x = Int32x4_internal.cvt_f32 x
let[@inline always] of_float64x2 x = Float64x2_internal.cvt_f32 x

let[@inline always] to_string x =
  let f x = Float32_u.to_float x in
  let { a; b; c; d } = splat x in
  Stdlib.Printf.sprintf "(%g %g %g %g)" (f a) (f b) (f c) (f d)
;;

let[@inline always] of_string s =
  let f x = Float32_u.of_float x in
  Stdlib.Scanf.sscanf s "(%g %g %g %g)" (fun a b c d ->
    set (f a) (f b) (f c) (f d) |> box)
  |> unbox
;;

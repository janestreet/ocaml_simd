module I = Int64x4_internal

type t = int64x4#
type mask = int64x4#

external box : t -> int64x4 @@ portable = "%box_vec256"
external unbox : int64x4 @ local -> t @@ portable = "%unbox_vec256"

module Test = Test.Int64x4
module Raw = Load_store.Raw_Int64x4
module String = Load_store.String_Int64x4
module Bytes = Load_store.Bytes_Int64x4
module Bigstring = Load_store.Bigstring_Int64x4
module Unsafe_immediate_array = Load_store.Unsafe_immediate_array
module Unsafe_immediate_iarray = Load_store.Unsafe_immediate_iarray
module Int64_u_array = Load_store.Int64_u_array
module Nativeint_u_array = Load_store.Nativeint_u_array

external const1
  :  int64#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int64x4_const1"
[@@noalloc] [@@builtin]

external const
  :  int64#
  -> int64#
  -> int64#
  -> int64#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_int64x4_const4"
[@@noalloc] [@@builtin]

external shuffle_lanes
  :  (Ocaml_simd.Shuffle2x2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_shuffle_64"
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
  -> idx:t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec128x2_permutev_64"
[@@noalloc] [@@builtin]

external blend
  :  (Ocaml_simd.Blend4.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_blend_64"
[@@noalloc] [@@builtin]

external insert_lane
  :  idx:int64#
  -> t
  -> int64x2#
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_insert_128"
[@@noalloc] [@@builtin]

external extract_lane
  :  idx:int64#
  -> t
  -> int64x2#
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx_vec256_extract_128"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0L
let[@inline] one () = const1 #1L
let[@inline] all_ones () = const1 #0xffffffffffffffffL
let[@inline] sign64_mask () = const1 #0x8000000000000000L
let[@inline] set1 x = I.broadcast_64 (I.I64x2.low_of x)

let[@inline] set a b c d =
  let ab = Int64x2.set a b in
  let cd = Int64x2.set c d in
  insert_lane ~idx:#1L (I.low_of_i64x2 ab) cd
;;

let[@inline] set_lanes a b = insert_lane ~idx:#1L (I.low_of_i64x2 a) b
let[@inline] movemask m = I.movemask_64 m
let[@inline] select m ~fail ~pass = I.blendv_64 fail pass m

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
    let x = I.low_to_i64x2 x in
    Int64x2.extract ~idx:#1L x
  | #2L ->
    let x = extract_lane ~idx:#1L x in
    I.I64x2.low_to x
  | #3L ->
    let x = extract_lane ~idx:#1L x in
    Int64x2.extract ~idx:#1L x
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract0 x = I.low_to x
let[@inline] extract_lane0 x = I.low_to_i64x2 x

let[@inline] splat x =
  #(extract0 x, extract ~idx:#1L x, extract ~idx:#2L x, extract ~idx:#3L x)
;;

let[@inline] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline] ( = ) x y = I.cmpeq x y
let[@inline] ( > ) x y = I.cmpgt x y
let[@inline] ( < ) x y = I.cmpgt y x
let[@inline] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline] equal x y = I.cmpeq x y
let[@inline] interleave_upper_lanes ~even ~odd = I.interleave_high_64 even odd
let[@inline] interleave_lower_lanes ~even ~odd = I.interleave_low_64 even odd
let[@inline] duplicate_even x = I.dup_even_64 x
let[@inline] add x y = I.add x y
let[@inline] sub x y = I.sub x y
let[@inline] neg x = I.add I.(xor x (all_ones ())) (one ())
let[@inline] abs x = select I.(and_ x (sign64_mask ())) ~pass:(neg x) ~fail:x

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
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_avx_unreachable" "caml_avx2_int64x4_srli"
[@@noalloc] [@@builtin]

let[@inline] ( + ) x y = I.add x y
let[@inline] ( - ) x y = I.sub x y
let[@inline] ( lor ) x y = I.or_ x y
let[@inline] ( land ) x y = I.and_ x y
let[@inline] ( lxor ) x y = I.xor x y
let[@inline] lnot m = I.(xor (all_ones ()) m)
let[@inline] landnot ~not y = I.andnot ~not y
let[@inline] unsafe_of_int64x2 x = I.low_of_i64x2 x
let[@inline] of_float16x16_bits x = I.of_float16x16 x
let[@inline] of_float32x8_bits x = I.of_float32x8 x
let[@inline] of_float64x4_bits x = I.of_float64x4 x
let[@inline] of_int8x32_bits x = I.of_int8x32 x
let[@inline] of_int16x16_bits x = I.of_int16x16 x
let[@inline] of_int32x8_bits x = I.of_int32x8 x
let[@inline] of_int8x16 x = Int8x32_internal.I8x16.cvtsx_i64 x
let[@inline] of_int8x16_unsigned x = Int8x32_internal.I8x16.cvtzx_i64 x
let[@inline] of_int16x8 x = Int16x16_internal.I16x8.cvtsx_i64 x
let[@inline] of_int16x8_unsigned x = Int16x16_internal.I16x8.cvtzx_i64 x
let[@inline] of_int32x4 x = Int32x8_internal.I32x4.cvtsx_i64 x
let[@inline] of_int32x4_unsigned x = Int32x8_internal.I32x4.cvtzx_i64 x

let[@inline] shift_left_logical x i =
  let c = Int64x4_internal.I64x2.low_of i in
  I.(sll x c)
;;

let[@inline] shift_right_logical x i =
  let c = Int64x4_internal.I64x2.low_of i in
  I.(srl x c)
;;

let[@inline] shift_left_logical_by x ~shift = I.sllv x shift
let[@inline] shift_right_logical_by x ~shift = I.srlv x shift

let[@inline] to_string x =
  let bx = Int64_u.to_int64 in
  let #(x0, x1, x2, x3) = splat x in
  Stdlib.Printf.sprintf "(%Ld %Ld %Ld %Ld)" (bx x0) (bx x1) (bx x2) (bx x3)
;;

let[@inline] of_string s =
  let ub = Int64_u.of_int64 in
  Stdlib.Scanf.sscanf s "(%Ld %Ld %Ld %Ld)" (fun x0 x1 x2 x3 ->
    set (ub x0) (ub x1) (ub x2) (ub x3) |> box)
  |> unbox
;;

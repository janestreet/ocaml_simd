module I = Int16x8_internal

type t = int16x8#
type mask = int16x8#

external box : t -> int16x8 = "%box_vec128"
external unbox : int16x8 -> t = "%unbox_vec128"

module String = Load_store.String_Int16x8
module Bytes = Load_store.Bytes_Int16x8
module Bigstring = Load_store.Bigstring_Int16x8

external const1
  :  (int[@untagged])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_int16x8_const1"
[@@noalloc] [@@builtin]

external const
  :  (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (int[@untagged])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_int16x8_const8"
[@@noalloc] [@@builtin]

external shuffle_upper
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shuffle_high_16"
[@@noalloc] [@@builtin]

external shuffle_lower
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shuffle_low_16"
[@@noalloc] [@@builtin]

external extract
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> (int[@untagged])
  = "ocaml_simd_unreachable" "caml_sse41_int16x8_extract"
[@@noalloc] [@@builtin]

external insert
  :  idx:(int[@untagged])
  -> (t[@unboxed])
  -> (int[@untagged])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse41_int16x8_insert"
[@@noalloc] [@@builtin]

let[@inline always] zero () = const1 0
let[@inline always] one () = const1 1
let[@inline always] all_ones () = const1 0xffff
let[@inline always] zero_mask () = Int32x4_internal.const1 #0l

let[@inline always] set1 a =
  let a = I.low_of a in
  let pattern = const1 0x01_00 in
  I.shuffle_8 a pattern
;;

let[@inline always] set a b c d e f g h =
  (* movd, + 7x insert -> 15 cycle latency
     this              -> 5 cycle latency *)
  let a = I.low_of a in
  let c = I.low_of c in
  let e = I.low_of e in
  let g = I.low_of g in
  let ba = insert ~idx:1 a b in
  let dc = insert ~idx:1 c d in
  let fe = insert ~idx:1 e f in
  let gh = insert ~idx:1 g h in
  let dcba = I.interleave_low_32 ba dc in
  let ghfe = I.interleave_low_32 fe gh in
  I.interleave_low_64 dcba ghfe
;;

let[@inline always] extract0 x = I.low_to x

let[@inline always] splat x =
  (* 8x movd, 8x movzx, 6x shuffle_lower, shuffle_64 -> 6 cycle latency
     this                                            -> 5 cycle latency *)
  ( extract0 x
  , extract ~idx:1 x
  , extract ~idx:2 x
  , extract ~idx:3 x
  , extract ~idx:4 x
  , extract ~idx:5 x
  , extract ~idx:6 x
  , extract ~idx:7 x )
;;

(* Comparisons do not use [C.not_...], as they have different NaN behavior. *)
let[@inline always] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline always] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline always] ( = ) x y = I.cmpeq x y
let[@inline always] ( > ) x y = I.cmpgt x y
let[@inline always] ( < ) x y = I.cmpgt y x
let[@inline always] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline always] equal x y = I.cmpeq x y
let[@inline always] interleave_upper ~lower ~upper = I.interleave_high_16 lower upper
let[@inline always] interleave_lower ~lower ~upper = I.interleave_low_16 lower upper

external blend
  :  (Ocaml_simd.Blend8.t[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blend_16"
[@@noalloc] [@@builtin]

let[@inline always] min x y = I.min x y
let[@inline always] max x y = I.max x y
let[@inline always] min_unsigned x y = I.min_unsigned x y
let[@inline always] max_unsigned x y = I.max_unsigned x y
let[@inline always] add x y = I.add x y
let[@inline always] add_saturating x y = I.add_saturating x y
let[@inline always] add_saturating_unsigned x y = I.add_saturating_unsigned x y
let[@inline always] sub x y = I.sub x y
let[@inline always] sub_saturating x y = I.sub_saturating x y
let[@inline always] sub_saturating_unsigned x y = I.sub_saturating_unsigned x y
let[@inline always] neg x = I.(mulsign x (all_ones ()))
let[@inline always] abs x = I.abs x

external shifti_left_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

external shifti_right_bytes
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

external shifti_left_logical
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_int16x8_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_int16x8_srli"
[@@noalloc] [@@builtin]

external shifti_right_arithmetic
  :  (int[@untagged])
  -> (t[@unboxed])
  -> (t[@unboxed])
  = "ocaml_simd_unreachable" "caml_sse2_int16x8_srai"
[@@noalloc] [@@builtin]

let[@inline always] horizontal_add x y = I.horizontal_add x y
let[@inline always] horizontal_sub x y = I.horizontal_sub x y
let[@inline always] horizontal_add_saturating x y = I.horizontal_add_saturating x y
let[@inline always] horizontal_sub_saturating x y = I.horizontal_sub_saturating x y
let[@inline always] mulsign x y = I.mulsign x y
let[@inline always] average_unsigned x y = I.avg_unsigned x y
let[@inline always] minpos_unsigned x = I.minpos_unsigned x
let[@inline always] ( + ) x y = I.add x y
let[@inline always] ( - ) x y = I.sub x y
let[@inline always] ( lor ) x y = I.or_ x y
let[@inline always] ( land ) x y = I.and_ x y
let[@inline always] ( lxor ) x y = I.xor x y
let[@inline always] lnot m = I.(xor (all_ones ()) m)
let[@inline always] landnot ~not y = I.andnot ~not y
let[@inline always] of_float32x4_bits x = I.of_float32x4 x
let[@inline always] of_float64x2_bits x = I.of_float64x2 x
let[@inline always] of_int8x16_bits x = I.of_int8x16 x
let[@inline always] of_int32x4_bits x = I.of_int32x4 x
let[@inline always] of_int64x2_bits x = I.of_int64x2 x
let[@inline always] of_int8x16 x = Int8x16_internal.cvtsx_i16 x
let[@inline always] of_int8x16_unsigned x = Int8x16_internal.cvtzx_i16 x
let[@inline always] of_int32x4_saturating x = Int32x4_internal.(cvt_si16 x (zero_mask ()))
let[@inline always] mul_high_bits x y = I.mul_high x y
let[@inline always] mul_low_bits x y = I.mul_low x y
let[@inline always] mul_unsigned_high_bits x y = I.mul_high_unsigned x y
let[@inline always] mul_horizontal_add x y = I.mul_horizontal_add x y

let[@inline always] of_int32x4_saturating_unsigned x =
  Int32x4_internal.(cvt_su16 x (zero_mask ()))
;;

let[@inline always] shift_left_logical x i =
  let c = Int64x2_internal.low_of (Int64_u.of_int i) in
  I.(sll x c)
;;

let[@inline always] shift_right_logical x i =
  let c = Int64x2_internal.low_of (Int64_u.of_int i) in
  I.(srl x c)
;;

let[@inline always] shift_right_arithmetic x i =
  let c = Int64x2_internal.low_of (Int64_u.of_int i) in
  I.(sra x c)
;;

let[@inline always] to_string x =
  let a, b, c, d, e, f, g, h = splat x in
  Stdlib.Printf.sprintf "(%d %d %d %d %d %d %d %d)" a b c d e f g h
;;

let[@inline always] of_string s =
  Stdlib.Scanf.sscanf s "(%d %d %d %d %d %d %d %d)" (fun a b c d e f g h ->
    set a b c d e f g h |> box)
  |> unbox
;;

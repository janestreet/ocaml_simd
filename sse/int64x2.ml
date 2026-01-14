module I = Int64x2_internal

type t = int64x2#
type mask = int64x2#

external box : t -> int64x2 @@ portable = "%box_vec128"
external unbox : int64x2 @ local -> t @@ portable = "%unbox_vec128"

module Test = Test.Int64x2
module Raw = Load_store.Raw_Int64x2
module String = Load_store.String_Int64x2
module Bytes = Load_store.Bytes_Int64x2
module Bigstring = Load_store.Bigstring_Int64x2
module Unsafe_immediate_array = Load_store.Unsafe_immediate_array
module Unsafe_immediate_iarray = Load_store.Unsafe_immediate_iarray
module Int64_u_array = Load_store.Int64_u_array
module Nativeint_u_array = Load_store.Nativeint_u_array

external const1
  :  int64#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int64x2_const1"
[@@noalloc] [@@builtin]

external const
  :  int64#
  -> int64#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int64x2_const2"
[@@noalloc] [@@builtin]

external shuffle
  :  (Ocaml_simd.Shuffle2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shuffle_64"
[@@noalloc] [@@builtin]

let[@inline] insert ~idx t x =
  match idx with
  | #0L -> I.insert ~idx:#0L t x
  | #1L -> I.insert ~idx:#1L t x
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract ~idx t =
  match idx with
  | #0L -> I.extract ~idx:#0L t
  | #1L -> I.extract ~idx:#1L t
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] zero () = const1 #0L
let[@inline] one () = const1 #1L
let[@inline] all_ones () = const1 #0xffffffffffffffffL
let[@inline] sign64_mask () = const1 #0x8000000000000000L

let[@inline] set1 a =
  let a = I.low_of a in
  I.dup_low_64 a
;;

let[@inline] set a b =
  (*=movq, + insert -> 3 cycle latency
     this           -> 2 cycle latency *)
  let a = I.low_of a in
  let b = I.low_of b in
  I.low_64_to_high_64 a b
;;

let[@inline] movemask m = I.movemask_64 m
let[@inline] select m ~fail ~pass = I.blendv_64 fail pass m
let[@inline] extract0 x = I.low_to x

let[@inline] splat x =
  (*=shuffle, movq -> 4 cycle latency
     this          -> 4 cycle latency but fewer registers *)
  #(extract0 x, extract ~idx:#1L x)
;;

let[@inline] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline] ( = ) x y = I.cmpeq x y
let[@inline] ( > ) x y = I.cmpgt x y
let[@inline] ( < ) x y = I.cmpgt y x
let[@inline] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline] equal x y = I.cmpeq x y
let[@inline] interleave_upper ~even ~odd = I.interleave_high_64 even odd
let[@inline] interleave_lower ~even ~odd = I.interleave_low_64 even odd
let[@inline] upper_to_lower ~from ~onto = I.high_64_to_low_64 onto from
let[@inline] lower_to_upper ~from ~onto = I.low_64_to_high_64 onto from
let[@inline] duplicate_lower x = I.dup_low_64 x

external blend
  :  (Ocaml_simd.Blend2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_64"
[@@noalloc] [@@builtin]

let[@inline] add x y = I.add x y
let[@inline] sub x y = I.sub x y
let[@inline] neg x = I.add I.(xor x (all_ones ())) (one ())
let[@inline] abs x = select I.(and_ x (sign64_mask ())) ~pass:(neg x) ~fail:x

external shifti_left_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

external shifti_right_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

external shifti_left_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int64x2_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int64x2_srli"
[@@noalloc] [@@builtin]

external mul_without_carry
  :  int64#
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_clmul_int64x2"
[@@noalloc] [@@builtin]

let[@inline] ( + ) x y = I.add x y
let[@inline] ( - ) x y = I.sub x y
let[@inline] ( lor ) x y = I.or_ x y
let[@inline] ( land ) x y = I.and_ x y
let[@inline] ( lxor ) x y = I.xor x y
let[@inline] lnot m = I.(xor (all_ones ()) m)
let[@inline] landnot ~not y = I.andnot ~not y
let[@inline] of_float16x8_bits x = I.of_float16x8 x
let[@inline] of_float32x4_bits x = I.of_float32x4 x
let[@inline] of_float64x2_bits x = I.of_float64x2 x
let[@inline] of_int8x16_bits x = I.of_int8x16 x
let[@inline] of_int16x8_bits x = I.of_int16x8 x
let[@inline] of_int32x4_bits x = I.of_int32x4 x
let[@inline] of_int8x16 x = Int8x16_internal.cvtsx_i64 x
let[@inline] of_int8x16_unsigned x = Int8x16_internal.cvtzx_i64 x
let[@inline] of_int16x8 x = Int16x8_internal.cvtsx_i64 x
let[@inline] of_int16x8_unsigned x = Int16x8_internal.cvtzx_i64 x
let[@inline] of_int32x4 x = Int32x4_internal.cvtsx_i64 x
let[@inline] of_int32x4_unsigned x = Int32x4_internal.cvtzx_i64 x

let[@inline] shift_left_logical x i =
  let c = Int64x2_internal.low_of i in
  I.(sll x c)
;;

let[@inline] shift_right_logical x i =
  let c = Int64x2_internal.low_of i in
  I.(srl x c)
;;

let[@inline] to_string x =
  let f = Int64_u.to_int64 in
  let #(a, b) = splat x in
  Stdlib.Printf.sprintf "(%Ld %Ld)" (f a) (f b)
;;

let[@inline] of_string s =
  let f = Int64_u.of_int64 in
  Stdlib.Scanf.sscanf s "(%Ld %Ld)" (fun a b -> set (f a) (f b) |> box) |> unbox
;;

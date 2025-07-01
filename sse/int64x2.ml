module I = Int64x2_internal

type t = int64x2#
type mask = int64x2#

external box : t -> int64x2 @@ portable = "%box_vec128"
external unbox : int64x2 -> t @@ portable = "%unbox_vec128"

module String = Load_store.String_Int64x2
module Bytes = Load_store.Bytes_Int64x2
module Bigstring = Load_store.Bigstring_Int64x2
module Immediate_array = Load_store.Immediate_array
module Immediate_iarray = Load_store.Immediate_iarray
module Int64_u_array = Load_store.Int64_u_array
module Nativeint_u_array = Load_store.Nativeint_u_array

external const1 : int64# -> t @@ portable = "ocaml_simd_unreachable" "caml_int64x2_const1"
[@@noalloc] [@@builtin]

external const
  :  int64#
  -> int64#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_int64x2_const2"
[@@noalloc] [@@builtin]

external shuffle
  :  (Ocaml_simd.Shuffle2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shuffle_64"
[@@noalloc] [@@builtin]

external extract
  :  idx:int64#
  -> t
  -> int64#
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int64x2_extract"
[@@noalloc] [@@builtin]

external insert
  :  idx:int64#
  -> t
  -> int64#
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_int64x2_insert"
[@@noalloc] [@@builtin]

let[@inline always] zero () = const1 #0L
let[@inline always] one () = const1 #1L
let[@inline always] all_ones () = const1 #0xffffffffffffffffL
let[@inline always] sign64_mask () = const1 #0x8000000000000000L

let[@inline always] set1 a =
  let a = I.low_of a in
  shuffle [%shuffle 0, 0] a a
;;

let[@inline always] set a b =
  (* movq, + insert -> 3 cycle latency
     this           -> 2 cycle latency *)
  let a = I.low_of a in
  let b = I.low_of b in
  I.low_64_to_high_64 a b
;;

let[@inline always] movemask m = I.movemask_64 m
let[@inline always] select m ~fail ~pass = I.blendv_64 fail pass m
let[@inline always] extract0 x = I.low_to x

let[@inline always] splat x =
  (* shuffle, movq -> 4 cycle latency
     this          -> 4 cycle latency but fewer registers *)
  #(extract0 x, extract ~idx:#1L x)
;;

(* Comparisons do not use [C.not_...], as they have different NaN behavior. *)
let[@inline always] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline always] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline always] ( = ) x y = I.cmpeq x y
let[@inline always] ( > ) x y = I.cmpgt x y
let[@inline always] ( < ) x y = I.cmpgt y x
let[@inline always] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline always] equal x y = I.cmpeq x y
let[@inline always] interleave_upper ~lower ~upper = I.interleave_high_64 lower upper
let[@inline always] interleave_lower ~lower ~upper = I.interleave_low_64 lower upper
let[@inline always] upper_to_lower ~from ~onto = I.high_64_to_low_64 onto from
let[@inline always] lower_to_upper ~from ~onto = I.low_64_to_high_64 onto from
let[@inline always] duplicate_lower x = I.dup_low_64 x

external blend
  :  (Ocaml_simd.Blend2.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse41_vec128_blend_64"
[@@noalloc] [@@builtin]

let[@inline always] add x y = I.add x y
let[@inline always] sub x y = I.sub x y
let[@inline always] neg x = I.add I.(xor x (all_ones ())) (one ())
let[@inline always] abs x = select I.(and_ x (sign64_mask ())) ~pass:(neg x) ~fail:x

external shifti_left_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_left_bytes"
[@@noalloc] [@@builtin]

external shifti_right_bytes
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_vec128_shift_right_bytes"
[@@noalloc] [@@builtin]

external shifti_left_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int64x2_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_sse2_int64x2_srli"
[@@noalloc] [@@builtin]

external mul_without_carry
  :  int64#
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_unreachable" "caml_clmul_int64x2"
[@@noalloc] [@@builtin]

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
let[@inline always] of_int16x8_bits x = I.of_int16x8 x
let[@inline always] of_int32x4_bits x = I.of_int32x4 x
let[@inline always] of_int8x16 x = Int8x16_internal.cvtsx_i64 x
let[@inline always] of_int8x16_unsigned x = Int8x16_internal.cvtzx_i64 x
let[@inline always] of_int16x8 x = Int16x8_internal.cvtsx_i64 x
let[@inline always] of_int16x8_unsigned x = Int16x8_internal.cvtzx_i64 x
let[@inline always] of_int32x4 x = Int32x4_internal.cvtsx_i64 x
let[@inline always] of_int32x4_unsigned x = Int32x4_internal.cvtzx_i64 x

let[@inline always] shift_left_logical x i =
  let c = Int64x2_internal.low_of i in
  I.(sll x c)
;;

let[@inline always] shift_right_logical x i =
  let c = Int64x2_internal.low_of i in
  I.(srl x c)
;;

let[@inline always] to_string x =
  let f = Int64_u.to_int64 in
  let #(a, b) = splat x in
  Stdlib.Printf.sprintf "(%Ld %Ld)" (f a) (f b)
;;

let[@inline always] of_string s =
  let f = Int64_u.of_int64 in
  Stdlib.Scanf.sscanf s "(%Ld %Ld)" (fun a b -> set (f a) (f b) |> box) |> unbox
;;

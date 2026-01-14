module I = Int32x4_internal

type t = int32x4#
type mask = int32x4#

external box : t -> int32x4 @@ portable = "%box_vec128"
external unbox : int32x4 @ local -> t @@ portable = "%unbox_vec128"

module Test = Test.Int32x4
module Raw = Load_store.Raw_Int32x4
module String = Load_store.String_Int32x4
module Bytes = Load_store.Bytes_Int32x4
module Bigstring = Load_store.Bigstring_Int32x4
module Int32_u_array = Load_store.Int32_u_array

external const1
  :  int32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int32x4_const1"
[@@noalloc] [@@builtin]

external const
  :  int32#
  -> int32#
  -> int32#
  -> int32#
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_int32x4_const4"
[@@noalloc] [@@builtin]

external shuffle
  :  (Ocaml_simd.Shuffle4.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse_vec128_shuffle_32"
[@@noalloc] [@@builtin]

let[@inline] zero () = const1 #0l
let[@inline] one () = const1 #1l
let[@inline] all_ones () = const1 #0xffffffffl

let[@inline] set1 a =
  let a = I.low_of a in
  shuffle [%shuffle 0, 0, 0, 0] a a
;;

let[@inline] set a b c d =
  (*=movd, + 3x insert -> 7 cycle latency
     this              -> 3 cycle latency *)
  let a = I.low_of a in
  let b = I.low_of b in
  let c = I.low_of c in
  let d = I.low_of d in
  let ba = I.interleave_low_32 a b in
  let dc = I.interleave_low_32 c d in
  I.interleave_low_64 ba dc
;;

let[@inline] insert ~idx t x =
  match idx with
  | #0L -> I.insert ~idx:#0L t x
  | #1L -> I.insert ~idx:#1L t x
  | #2L -> I.insert ~idx:#2L t x
  | #3L -> I.insert ~idx:#3L t x
  | _ ->
    (match failwith "Invalid index." with
     | (_ : Base.Nothing.t) -> .)
;;

let[@inline] extract ~idx t =
  let open struct
    external int32_of_int64 : int64# -> int32# @@ portable = "%int32#_of_int64#"
  end in
  let x =
    match idx with
    | #0L -> I.extract ~idx:#0L t
    | #1L -> I.extract ~idx:#1L t
    | #2L -> I.extract ~idx:#2L t
    | #3L -> I.extract ~idx:#3L t
    | _ ->
      (match failwith "Invalid index." with
       | (_ : Base.Nothing.t) -> .)
  in
  (* Sign extend. *)
  int32_of_int64 x
;;

let[@inline] movemask m = I.movemask_32 m
let[@inline] select m ~fail ~pass = I.blendv_32 fail pass m
let[@inline] extract0 x = I.low_to x

let[@inline] splat x =
  (*=3x shuffle, 4x movd -> 4 cycle latency
     this                -> 4 cycle latency but fewer registers *)
  #(extract0 x, extract ~idx:#1L x, extract ~idx:#2L x, extract ~idx:#3L x)
;;

let[@inline] ( >= ) x y = I.(or_ (cmpgt x y) (cmpeq x y))
let[@inline] ( <= ) x y = I.(or_ (cmpgt y x) (cmpeq x y))
let[@inline] ( = ) x y = I.cmpeq x y
let[@inline] ( > ) x y = I.cmpgt x y
let[@inline] ( < ) x y = I.cmpgt y x
let[@inline] ( <> ) x y = I.(xor (all_ones ()) (cmpeq x y))
let[@inline] equal x y = I.cmpeq x y
let[@inline] interleave_upper ~even ~odd = I.interleave_high_32 even odd
let[@inline] interleave_lower ~even ~odd = I.interleave_low_32 even odd
let[@inline] duplicate_even x = I.dup_even_32 x
let[@inline] duplicate_odd x = I.dup_odd_32 x

external blend
  :  (Ocaml_simd.Blend4.t[@untagged])
  -> t
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse41_vec128_blend_32"
[@@noalloc] [@@builtin]

let[@inline] min x y = I.min x y
let[@inline] max x y = I.max x y
let[@inline] min_unsigned x y = I.min_unsigned x y
let[@inline] max_unsigned x y = I.max_unsigned x y
let[@inline] add x y = I.add x y
let[@inline] sub x y = I.sub x y
let[@inline] neg x = I.(mul_sign x (all_ones ()))
let[@inline] abs x = I.abs x

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
  = "ocaml_simd_sse_unreachable" "caml_sse2_int32x4_slli"
[@@noalloc] [@@builtin]

external shifti_right_logical
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int32x4_srli"
[@@noalloc] [@@builtin]

external shifti_right_arithmetic
  :  int64#
  -> t
  -> t
  @@ portable
  = "ocaml_simd_sse_unreachable" "caml_sse2_int32x4_srai"
[@@noalloc] [@@builtin]

let[@inline] horizontal_add x y = I.horizontal_add x y
let[@inline] horizontal_sub x y = I.horizontal_sub x y
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
let[@inline] of_float16x8_bits x = I.of_float16x8 x
let[@inline] of_float32x4_bits x = I.of_float32x4 x
let[@inline] of_float64x2_bits x = I.of_float64x2 x
let[@inline] of_int8x16_bits x = I.of_int8x16 x
let[@inline] of_int16x8_bits x = I.of_int16x8 x
let[@inline] of_int64x2_bits x = I.of_int64x2 x
let[@inline] of_float32x4 x = Float32x4_internal.cvt_i32 x
let[@inline] of_float32x4_trunc x = Float32x4_internal.cvtt_i32 x
let[@inline] of_int8x16 x = Int8x16_internal.cvtsx_i32 x
let[@inline] of_int8x16_unsigned x = Int8x16_internal.cvtzx_i32 x
let[@inline] of_int16x8 x = Int16x8_internal.cvtsx_i32 x
let[@inline] of_int16x8_unsigned x = Int16x8_internal.cvtzx_i32 x
let[@inline] of_float64x2 x = Float64x2_internal.cvt_i32 x
let[@inline] of_float64x2_trunc x = Float64x2_internal.cvtt_i32 x

let[@inline] shift_left_logical x i =
  let c = Int64x2_internal.low_of i in
  I.(sll x c)
;;

let[@inline] shift_right_logical x i =
  let c = Int64x2_internal.low_of i in
  I.(srl x c)
;;

let[@inline] shift_right_arithmetic x i =
  let c = Int64x2_internal.low_of i in
  I.(sra x c)
;;

let[@inline] to_string x =
  let f = Int32_u.to_int32 in
  let #(a, b, c, d) = splat x in
  Stdlib.Printf.sprintf "(%ld %ld %ld %ld)" (f a) (f b) (f c) (f d)
;;

let[@inline] of_string s =
  let f = Int32_u.of_int32 in
  Stdlib.Scanf.sscanf s "(%ld %ld %ld %ld)" (fun a b c d ->
    set (f a) (f b) (f c) (f d) |> box)
  |> unbox
;;

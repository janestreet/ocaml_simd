open Stdlib
include Load_store_intf

(* We can functorize instead of duplicating all the intrinsics because the externals are
   not [@@unboxed]. *)

type void : void

module Raw (T : sig
    (** Must be one of [int8x32,int16x16,int32x8,int64x4,float16x16,float32x8,float64x4]. *)
    type t : vec256
  end) =
struct
  external aligned_load
    :  nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_aligned"
  [@@noalloc] [@@builtin]

  external unaligned_load
    :  nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_unaligned"
  [@@noalloc] [@@builtin]

  external aligned_store
    :  nativeint#
    -> T.t
    -> void
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_store_aligned"
  [@@noalloc] [@@builtin]

  external unaligned_store
    :  nativeint#
    -> T.t
    -> void
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_store_unaligned"
  [@@noalloc] [@@builtin]

  let[@inline] aligned_store mem t =
    let _ : void = aligned_store mem t in
    ()
  ;;

  let[@inline] unaligned_store mem t =
    let _ : void = unaligned_store mem t in
    ()
  ;;

  external aligned_load_uncached
    :  nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_aligned_uncached"
  [@@noalloc] [@@builtin]

  external aligned_store_uncached
    :  nativeint#
    -> T.t
    -> void
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_store_aligned_uncached"
  [@@noalloc] [@@builtin]

  let[@inline] aligned_store_uncached mem t =
    let _ : void = aligned_store_uncached mem t in
    ()
  ;;

  external broadcast_lanes
    :  nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_broadcast128"
  [@@noalloc] [@@builtin]
end

module Raw64 (T : sig
    (** Must be one of [int64x4,float64x4]. *)
    type t : vec256
  end) =
struct
  external broadcast
    :  nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_broadcast64"
  [@@noalloc] [@@builtin]

  external load_masked
    :  mask:int64x4#
    -> nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_mask64"
  [@@noalloc] [@@builtin]

  let[@inline] load_masked mem ~mask = load_masked ~mask mem

  external store_masked
    :  nativeint#
    -> mask:int64x4#
    -> T.t
    -> void
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_store_mask64"
  [@@noalloc] [@@builtin]

  let[@inline] store_masked mem t ~mask =
    let _ : void = store_masked mem ~mask t in
    ()
  ;;
end

module Raw32 (T : sig
    (** Must be one of [int32x8,float32x8]. *)
    type t : vec256
  end) =
struct
  external broadcast
    :  nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_broadcast32"
  [@@noalloc] [@@builtin]

  external load_masked
    :  mask:int32x8#
    -> nativeint#
    -> T.t
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_load_mask32"
  [@@noalloc] [@@builtin]

  let[@inline] load_masked mem ~mask = load_masked ~mask mem

  external store_masked
    :  nativeint#
    -> mask:int32x8#
    -> T.t
    -> void
    @@ portable
    = "ocaml_simd_avx_unreachable" "caml_avx_vec256_store_mask32"
  [@@noalloc] [@@builtin]

  let[@inline] store_masked mem t ~mask =
    let _ : void = store_masked mem ~mask t in
    ()
  ;;
end

module String (T : sig
    (** Must be one of [int8x32,int16x16,int32x8,int64x4,float16x16,float32x8,float64x4]. *)
    type t : vec256
  end) =
struct
  external get
    :  (string[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_string_getu256#"

  external unsafe_get
    :  (string[@local_opt])
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_string_getu256u#"

  module Int32_u = struct
    external get
      :  (string[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_string_getu256#_indexed_by_int32#"

    external unsafe_get
      :  (string[@local_opt])
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_string_getu256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (string[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_string_getu256#_indexed_by_int64#"

    external unsafe_get
      :  (string[@local_opt])
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_string_getu256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (string[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_string_getu256#_indexed_by_nativeint#"

    external unsafe_get
      :  (string[@local_opt])
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_string_getu256u#_indexed_by_nativeint#"
  end
end

module Bytes (T : sig
    (** Must be one of [int8x32,int16x16,int32x8,int64x4,float16x16,float32x8,float64x4]. *)
    type t : vec256
  end) =
struct
  external get
    :  (bytes[@local_opt]) @ read
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bytes_getu256#"

  external unsafe_get
    :  (bytes[@local_opt]) @ read
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bytes_getu256u#"

  external set
    :  (bytes[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bytes_setu256#"

  external unsafe_set
    :  (bytes[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bytes_setu256u#"

  module Int32_u = struct
    external get
      :  (bytes[@local_opt]) @ read
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bytes_getu256#_indexed_by_int32#"

    external unsafe_get
      :  (bytes[@local_opt]) @ read
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bytes_getu256u#_indexed_by_int32#"

    external set
      :  (bytes[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu256#_indexed_by_int32#"

    external unsafe_set
      :  (bytes[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (bytes[@local_opt]) @ read
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bytes_getu256#_indexed_by_int64#"

    external unsafe_get
      :  (bytes[@local_opt]) @ read
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bytes_getu256u#_indexed_by_int64#"

    external set
      :  (bytes[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu256#_indexed_by_int64#"

    external unsafe_set
      :  (bytes[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (bytes[@local_opt]) @ read
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bytes_getu256#_indexed_by_nativeint#"

    external unsafe_get
      :  (bytes[@local_opt]) @ read
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bytes_getu256u#_indexed_by_nativeint#"

    external set
      :  (bytes[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu256#_indexed_by_nativeint#"

    external unsafe_set
      :  (bytes[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bytes_setu256u#_indexed_by_nativeint#"
  end
end

module Bigstring (T : sig
    (** Must be one of [int8x32,int16x16,int32x8,int64x4,float16x16,float32x8,float64x4]. *)
    type t : vec256
  end) =
struct
  type bigstring = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

  external unaligned_get
    :  (bigstring[@local_opt]) @ read
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_getu256#"

  external unsafe_unaligned_get
    :  (bigstring[@local_opt]) @ read
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_getu256u#"

  external aligned_get
    :  (bigstring[@local_opt]) @ read
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_geta256#"

  external unsafe_aligned_get
    :  (bigstring[@local_opt]) @ read
    -> byte:int
    -> T.t
    @@ portable
    = "%caml_bigstring_geta256u#"

  external unaligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_setu256#"

  external unsafe_unaligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_setu256u#"

  external aligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_seta256#"

  external unsafe_aligned_set
    :  (bigstring[@local_opt])
    -> byte:int
    -> T.t
    -> unit
    @@ portable
    = "%caml_bigstring_seta256u#"

  module Int32_u = struct
    external unaligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu256#_indexed_by_int32#"

    external unsafe_unaligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu256u#_indexed_by_int32#"

    external aligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta256#_indexed_by_int32#"

    external unsafe_aligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int32#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta256u#_indexed_by_int32#"

    external unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu256#_indexed_by_int32#"

    external unsafe_unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu256u#_indexed_by_int32#"

    external aligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta256#_indexed_by_int32#"

    external unsafe_aligned_set
      :  (bigstring[@local_opt])
      -> byte:int32#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external unaligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu256#_indexed_by_int64#"

    external unsafe_unaligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu256u#_indexed_by_int64#"

    external aligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta256#_indexed_by_int64#"

    external unsafe_aligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:int64#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta256u#_indexed_by_int64#"

    external unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu256#_indexed_by_int64#"

    external unsafe_unaligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu256u#_indexed_by_int64#"

    external aligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta256#_indexed_by_int64#"

    external unsafe_aligned_set
      :  (bigstring[@local_opt])
      -> byte:int64#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external unaligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu256#_indexed_by_nativeint#"

    external unsafe_unaligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_getu256u#_indexed_by_nativeint#"

    external aligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta256#_indexed_by_nativeint#"

    external unsafe_aligned_get
      :  (bigstring[@local_opt]) @ read
      -> byte:nativeint#
      -> T.t
      @@ portable
      = "%caml_bigstring_geta256u#_indexed_by_nativeint#"

    external unaligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu256#_indexed_by_nativeint#"

    external unsafe_unaligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_setu256u#_indexed_by_nativeint#"

    external aligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta256#_indexed_by_nativeint#"

    external unsafe_aligned_set
      :  (bigstring[@local_opt])
      -> byte:nativeint#
      -> T.t
      -> unit
      @@ portable
      = "%caml_bigstring_seta256u#_indexed_by_nativeint#"
  end
end

module Float_array = struct
  type t = float64x4#

  external get
    :  (float array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get256#"

  external unsafe_get
    :  (float array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get256u#"

  external set
    :  (float array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_float_array_set256#"

  external unsafe_set
    :  (float array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_float_array_set256u#"

  module Int32_u = struct
    external get
      :  (float array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_float_array_get256#_indexed_by_int32#"

    external unsafe_get
      :  (float array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_float_array_get256u#_indexed_by_int32#"

    external set
      :  (float array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_float_array_set256#_indexed_by_int32#"

    external unsafe_set
      :  (float array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_float_array_set256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (float array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_float_array_get256#_indexed_by_int64#"

    external unsafe_get
      :  (float array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_float_array_get256u#_indexed_by_int64#"

    external set
      :  (float array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_float_array_set256#_indexed_by_int64#"

    external unsafe_set
      :  (float array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_float_array_set256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (float array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_float_array_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (float array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_float_array_get256u#_indexed_by_nativeint#"

    external set
      :  (float array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_float_array_set256#_indexed_by_nativeint#"

    external unsafe_set
      :  (float array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_float_array_set256u#_indexed_by_nativeint#"
  end
end

module Floatarray = struct
  type t = float64x4#

  external get
    :  (floatarray[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_floatarray_get256#"

  external unsafe_get
    :  (floatarray[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_floatarray_get256u#"

  external set
    :  (floatarray[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_floatarray_set256#"

  external unsafe_set
    :  (floatarray[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_floatarray_set256u#"

  module Int32_u = struct
    external get
      :  (floatarray[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_floatarray_get256#_indexed_by_int32#"

    external unsafe_get
      :  (floatarray[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_floatarray_get256u#_indexed_by_int32#"

    external set
      :  (floatarray[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_floatarray_set256#_indexed_by_int32#"

    external unsafe_set
      :  (floatarray[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_floatarray_set256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (floatarray[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_floatarray_get256#_indexed_by_int64#"

    external unsafe_get
      :  (floatarray[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_floatarray_get256u#_indexed_by_int64#"

    external set
      :  (floatarray[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_floatarray_set256#_indexed_by_int64#"

    external unsafe_set
      :  (floatarray[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_floatarray_set256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (floatarray[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_floatarray_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (floatarray[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_floatarray_get256u#_indexed_by_nativeint#"

    external set
      :  (floatarray[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_floatarray_set256#_indexed_by_nativeint#"

    external unsafe_set
      :  (floatarray[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_floatarray_set256u#_indexed_by_nativeint#"
  end
end

module Float_iarray = struct
  type t = float64x4#

  external get
    :  (float iarray[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get256#"

  external unsafe_get
    :  (float iarray[@local_opt])
    -> idx:int
    -> t
    @@ portable
    = "%caml_float_array_get256u#"

  module Int32_u = struct
    external get
      :  (float iarray[@local_opt])
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_float_array_get256#_indexed_by_int32#"

    external unsafe_get
      :  (float iarray[@local_opt])
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_float_array_get256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (float iarray[@local_opt])
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_float_array_get256#_indexed_by_int64#"

    external unsafe_get
      :  (float iarray[@local_opt])
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_float_array_get256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (float iarray[@local_opt])
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_float_array_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (float iarray[@local_opt])
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_float_array_get256u#_indexed_by_nativeint#"
  end
end

module Unsafe_immediate_array = struct
  module I64 = Int64_u
  module I = Int64x4_internal

  type t = int64x4#

  let one () = I.const1 #1L
  let bit x i = Int64_u.((x lsr i) land #1L |> to_int_trunc)

  let[@inline never] invalid_set_tagged pass =
    let fail = Int64_u.(pass lxor #0xfL) in
    raise
      (Invalid_argument
         (Printf.sprintf
            "Int64x4 contained untagged value(s) (mask: 0b%u%u%u%u)."
            (bit fail 3)
            (bit fail 2)
            (bit fail 1)
            (bit fail 0)))
  ;;

  let[@inline never] invalid_tag_and_set fail =
    raise
      (Invalid_argument
         (Printf.sprintf
            "Int64x4 contained untaggable value(s) (mask: 0b%u%u%u%u)."
            (bit fail 3)
            (bit fail 2)
            (bit fail 1)
            (bit fail 0)))
  ;;

  external get_tagged
    : ('a : immediate64).
    ('a array[@local_opt]) @ read -> idx:int -> t
    @@ portable
    = "%caml_int_array_get256#"

  external unsafe_get_tagged
    : ('a : immediate64).
    ('a array[@local_opt]) @ read -> idx:int -> t
    @@ portable
    = "%caml_int_array_get256u#"

  let get_and_untag arr ~idx =
    let v = get_tagged arr ~idx in
    I.srli #1L v
  ;;

  let unsafe_get_and_untag arr ~idx =
    let v = unsafe_get_tagged arr ~idx in
    I.srli #1L v
  ;;

  external set_raw
    : ('a : immediate64).
    ('a array[@local_opt]) -> idx:int -> t -> unit
    @@ portable
    = "%caml_int_array_set256#"

  external unsafe_set_tagged
    : ('a : immediate64).
    ('a array[@local_opt]) -> idx:int -> t -> unit
    @@ portable
    = "%caml_int_array_set256u#"

  let set_tagged arr ~idx v =
    let mask = I.(slli #63L v |> movemask_64) in
    if not (I64.equal mask #0b1111L) then invalid_set_tagged mask;
    set_raw arr ~idx v
  ;;

  let tag_and_set arr ~idx v =
    let mask = I.movemask_64 v in
    if not (I64.equal mask #0L) then invalid_tag_and_set mask;
    let v = I.slli #1L v in
    let v = I.or_ v (one ()) in
    set_raw arr ~idx v
  ;;

  let unsafe_tag_and_set arr ~idx v =
    let v = I.slli #1L v in
    let v = I.or_ v (one ()) in
    unsafe_set_tagged arr ~idx v
  ;;

  module Int32_u = struct
    external get_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) @ read -> idx:int32# -> t
      @@ portable
      = "%caml_int_array_get256#_indexed_by_int32#"

    external unsafe_get_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) @ read -> idx:int32# -> t
      @@ portable
      = "%caml_int_array_get256u#_indexed_by_int32#"

    let get_and_untag arr ~idx =
      let v = get_tagged arr ~idx in
      I.srli #1L v
    ;;

    let unsafe_get_and_untag arr ~idx =
      let v = unsafe_get_tagged arr ~idx in
      I.srli #1L v
    ;;

    external set_raw
      : ('a : immediate64).
      ('a array[@local_opt]) -> idx:int32# -> t -> unit
      @@ portable
      = "%caml_int_array_set256#_indexed_by_int32#"

    external unsafe_set_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) -> idx:int32# -> t -> unit
      @@ portable
      = "%caml_int_array_set256u#_indexed_by_int32#"

    let set_tagged arr ~idx v =
      let mask = I.(slli #63L v |> movemask_64) in
      if not (I64.equal mask #0b1111L) then invalid_set_tagged mask;
      set_raw arr ~idx v
    ;;

    let tag_and_set arr ~idx v =
      let mask = I.movemask_64 v in
      if not (I64.equal mask #0L) then invalid_tag_and_set mask;
      let v = I.slli #1L v in
      let v = I.or_ v (one ()) in
      set_raw arr ~idx v
    ;;

    let unsafe_tag_and_set arr ~idx v =
      let v = I.slli #1L v in
      let v = I.or_ v (one ()) in
      unsafe_set_tagged arr ~idx v
    ;;
  end

  module Int64_u = struct
    external get_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) @ read -> idx:int64# -> t
      @@ portable
      = "%caml_int_array_get256#_indexed_by_int64#"

    external unsafe_get_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) @ read -> idx:int64# -> t
      @@ portable
      = "%caml_int_array_get256u#_indexed_by_int64#"

    let get_and_untag arr ~idx =
      let v = get_tagged arr ~idx in
      I.srli #1L v
    ;;

    let unsafe_get_and_untag arr ~idx =
      let v = unsafe_get_tagged arr ~idx in
      I.srli #1L v
    ;;

    external set_raw
      : ('a : immediate64).
      ('a array[@local_opt]) -> idx:int64# -> t -> unit
      @@ portable
      = "%caml_int_array_set256#_indexed_by_int64#"

    external unsafe_set_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) -> idx:int64# -> t -> unit
      @@ portable
      = "%caml_int_array_set256u#_indexed_by_int64#"

    let set_tagged arr ~idx v =
      let mask = I.(slli #63L v |> movemask_64) in
      if not (I64.equal mask #0b1111L) then invalid_set_tagged mask;
      set_raw arr ~idx v
    ;;

    let tag_and_set arr ~idx v =
      let mask = I.movemask_64 v in
      if not (I64.equal mask #0L) then invalid_tag_and_set mask;
      let v = I.slli #1L v in
      let v = I.or_ v (one ()) in
      set_raw arr ~idx v
    ;;

    let unsafe_tag_and_set arr ~idx v =
      let v = I.slli #1L v in
      let v = I.or_ v (one ()) in
      unsafe_set_tagged arr ~idx v
    ;;
  end

  module Nativeint_u = struct
    external get_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) @ read -> idx:nativeint# -> t
      @@ portable
      = "%caml_int_array_get256#_indexed_by_nativeint#"

    external unsafe_get_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) @ read -> idx:nativeint# -> t
      @@ portable
      = "%caml_int_array_get256u#_indexed_by_nativeint#"

    let get_and_untag arr ~idx =
      let v = get_tagged arr ~idx in
      I.srli #1L v
    ;;

    let unsafe_get_and_untag arr ~idx =
      let v = unsafe_get_tagged arr ~idx in
      I.srli #1L v
    ;;

    external set_raw
      : ('a : immediate64).
      ('a array[@local_opt]) -> idx:nativeint# -> t -> unit
      @@ portable
      = "%caml_int_array_set256#_indexed_by_nativeint#"

    external unsafe_set_tagged
      : ('a : immediate64).
      ('a array[@local_opt]) -> idx:nativeint# -> t -> unit
      @@ portable
      = "%caml_int_array_set256u#_indexed_by_nativeint#"

    let set_tagged arr ~idx v =
      let mask = I.(slli #63L v |> movemask_64) in
      if not (I64.equal mask #0b1111L) then invalid_set_tagged mask;
      set_raw arr ~idx v
    ;;

    let tag_and_set arr ~idx v =
      let mask = I.movemask_64 v in
      if not (I64.equal mask #0L) then invalid_tag_and_set mask;
      let v = I.slli #1L v in
      let v = I.or_ v (one ()) in
      set_raw arr ~idx v
    ;;

    let unsafe_tag_and_set arr ~idx v =
      let v = I.slli #1L v in
      let v = I.or_ v (one ()) in
      unsafe_set_tagged arr ~idx v
    ;;
  end
end

module Unsafe_immediate_iarray = struct
  module I = Int64x4_internal

  type t = int64x4#

  external get_tagged
    : ('a : immediate64).
    ('a iarray[@local_opt]) -> idx:int -> t
    @@ portable
    = "%caml_int_array_get256#"

  external unsafe_get_tagged
    : ('a : immediate64).
    ('a iarray[@local_opt]) -> idx:int -> t
    @@ portable
    = "%caml_int_array_get256u#"

  let get_and_untag (local_ arr) ~idx =
    let v = get_tagged arr ~idx in
    I.srli #1L v
  ;;

  let unsafe_get_and_untag (local_ arr) ~idx =
    let v = unsafe_get_tagged arr ~idx in
    I.srli #1L v
  ;;

  module Int32_u = struct
    external get_tagged
      : ('a : immediate64).
      ('a iarray[@local_opt]) -> idx:int32# -> t
      @@ portable
      = "%caml_int_array_get256#_indexed_by_int32#"

    external unsafe_get_tagged
      : ('a : immediate64).
      ('a iarray[@local_opt]) -> idx:int32# -> t
      @@ portable
      = "%caml_int_array_get256u#_indexed_by_int32#"

    let get_and_untag (local_ arr) ~idx =
      let v = get_tagged arr ~idx in
      I.srli #1L v
    ;;

    let unsafe_get_and_untag (local_ arr) ~idx =
      let v = unsafe_get_tagged arr ~idx in
      I.srli #1L v
    ;;
  end

  module Int64_u = struct
    external get_tagged
      : ('a : immediate64).
      ('a iarray[@local_opt]) -> idx:int64# -> t
      @@ portable
      = "%caml_int_array_get256#_indexed_by_int64#"

    external unsafe_get_tagged
      : ('a : immediate64).
      ('a iarray[@local_opt]) -> idx:int64# -> t
      @@ portable
      = "%caml_int_array_get256u#_indexed_by_int64#"

    let get_and_untag (local_ arr) ~idx =
      let v = get_tagged arr ~idx in
      I.srli #1L v
    ;;

    let unsafe_get_and_untag (local_ arr) ~idx =
      let v = unsafe_get_tagged arr ~idx in
      I.srli #1L v
    ;;
  end

  module Nativeint_u = struct
    external get_tagged
      : ('a : immediate64).
      ('a iarray[@local_opt]) -> idx:nativeint# -> t
      @@ portable
      = "%caml_int_array_get256#_indexed_by_nativeint#"

    external unsafe_get_tagged
      : ('a : immediate64).
      ('a iarray[@local_opt]) -> idx:nativeint# -> t
      @@ portable
      = "%caml_int_array_get256u#_indexed_by_nativeint#"

    let get_and_untag (local_ arr) ~idx =
      let v = get_tagged arr ~idx in
      I.srli #1L v
    ;;

    let unsafe_get_and_untag (local_ arr) ~idx =
      let v = unsafe_get_tagged arr ~idx in
      I.srli #1L v
    ;;
  end
end

module Float_u_array = struct
  type t = float64x4#

  external get
    :  (float# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float_array_get256#"

  external unsafe_get
    :  (float# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float_array_get256u#"

  external set
    :  (float# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float_array_set256#"

  external unsafe_set
    :  (float# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float_array_set256u#"

  module Int32_u = struct
    external get
      :  (float# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_float_array_get256#_indexed_by_int32#"

    external unsafe_get
      :  (float# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_float_array_get256u#_indexed_by_int32#"

    external set
      :  (float# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float_array_set256#_indexed_by_int32#"

    external unsafe_set
      :  (float# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float_array_set256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (float# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_float_array_get256#_indexed_by_int64#"

    external unsafe_get
      :  (float# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_float_array_get256u#_indexed_by_int64#"

    external set
      :  (float# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float_array_set256#_indexed_by_int64#"

    external unsafe_set
      :  (float# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float_array_set256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (float# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_float_array_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (float# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_float_array_get256u#_indexed_by_nativeint#"

    external set
      :  (float# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float_array_set256#_indexed_by_nativeint#"

    external unsafe_set
      :  (float# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float_array_set256u#_indexed_by_nativeint#"
  end
end

module Float32_u_array = struct
  type t = float32x8#

  external get
    :  (float32# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float32_array_get256#"

  external unsafe_get
    :  (float32# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_float32_array_get256u#"

  external set
    :  (float32# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float32_array_set256#"

  external unsafe_set
    :  (float32# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_float32_array_set256u#"

  module Int32_u = struct
    external get
      :  (float32# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_float32_array_get256#_indexed_by_int32#"

    external unsafe_get
      :  (float32# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_float32_array_get256u#_indexed_by_int32#"

    external set
      :  (float32# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float32_array_set256#_indexed_by_int32#"

    external unsafe_set
      :  (float32# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float32_array_set256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (float32# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_float32_array_get256#_indexed_by_int64#"

    external unsafe_get
      :  (float32# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_float32_array_get256u#_indexed_by_int64#"

    external set
      :  (float32# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float32_array_set256#_indexed_by_int64#"

    external unsafe_set
      :  (float32# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float32_array_set256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (float32# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_float32_array_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (float32# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_float32_array_get256u#_indexed_by_nativeint#"

    external set
      :  (float32# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float32_array_set256#_indexed_by_nativeint#"

    external unsafe_set
      :  (float32# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_float32_array_set256u#_indexed_by_nativeint#"
  end
end

module Int64_u_array = struct
  type t = int64x4#

  external get
    :  (int64# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int64_array_get256#"

  external unsafe_get
    :  (int64# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int64_array_get256u#"

  external set
    :  (int64# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int64_array_set256#"

  external unsafe_set
    :  (int64# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int64_array_set256u#"

  module Int32_u = struct
    external get
      :  (int64# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_int64_array_get256#_indexed_by_int32#"

    external unsafe_get
      :  (int64# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_int64_array_get256u#_indexed_by_int32#"

    external set
      :  (int64# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int64_array_set256#_indexed_by_int32#"

    external unsafe_set
      :  (int64# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int64_array_set256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (int64# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_int64_array_get256#_indexed_by_int64#"

    external unsafe_get
      :  (int64# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_int64_array_get256u#_indexed_by_int64#"

    external set
      :  (int64# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int64_array_set256#_indexed_by_int64#"

    external unsafe_set
      :  (int64# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int64_array_set256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (int64# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_int64_array_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (int64# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_int64_array_get256u#_indexed_by_nativeint#"

    external set
      :  (int64# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int64_array_set256#_indexed_by_nativeint#"

    external unsafe_set
      :  (int64# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int64_array_set256u#_indexed_by_nativeint#"
  end
end

module Nativeint_u_array = struct
  type t = int64x4#

  external get
    :  (nativeint# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_nativeint_array_get256#"

  external unsafe_get
    :  (nativeint# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_nativeint_array_get256u#"

  external set
    :  (nativeint# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_nativeint_array_set256#"

  external unsafe_set
    :  (nativeint# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_nativeint_array_set256u#"

  module Int32_u = struct
    external get
      :  (nativeint# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_nativeint_array_get256#_indexed_by_int32#"

    external unsafe_get
      :  (nativeint# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_nativeint_array_get256u#_indexed_by_int32#"

    external set
      :  (nativeint# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_nativeint_array_set256#_indexed_by_int32#"

    external unsafe_set
      :  (nativeint# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_nativeint_array_set256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (nativeint# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_nativeint_array_get256#_indexed_by_int64#"

    external unsafe_get
      :  (nativeint# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_nativeint_array_get256u#_indexed_by_int64#"

    external set
      :  (nativeint# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_nativeint_array_set256#_indexed_by_int64#"

    external unsafe_set
      :  (nativeint# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_nativeint_array_set256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (nativeint# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_nativeint_array_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (nativeint# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_nativeint_array_get256u#_indexed_by_nativeint#"

    external set
      :  (nativeint# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_nativeint_array_set256#_indexed_by_nativeint#"

    external unsafe_set
      :  (nativeint# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_nativeint_array_set256u#_indexed_by_nativeint#"
  end
end

module Int32_u_array = struct
  type t = int32x8#

  external get
    :  (int32# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int32_array_get256#"

  external unsafe_get
    :  (int32# array[@local_opt]) @ read
    -> idx:int
    -> t
    @@ portable
    = "%caml_unboxed_int32_array_get256u#"

  external set
    :  (int32# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int32_array_set256#"

  external unsafe_set
    :  (int32# array[@local_opt])
    -> idx:int
    -> t
    -> unit
    @@ portable
    = "%caml_unboxed_int32_array_set256u#"

  module Int32_u = struct
    external get
      :  (int32# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_int32_array_get256#_indexed_by_int32#"

    external unsafe_get
      :  (int32# array[@local_opt]) @ read
      -> idx:int32#
      -> t
      @@ portable
      = "%caml_unboxed_int32_array_get256u#_indexed_by_int32#"

    external set
      :  (int32# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int32_array_set256#_indexed_by_int32#"

    external unsafe_set
      :  (int32# array[@local_opt])
      -> idx:int32#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int32_array_set256u#_indexed_by_int32#"
  end

  module Int64_u = struct
    external get
      :  (int32# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_int32_array_get256#_indexed_by_int64#"

    external unsafe_get
      :  (int32# array[@local_opt]) @ read
      -> idx:int64#
      -> t
      @@ portable
      = "%caml_unboxed_int32_array_get256u#_indexed_by_int64#"

    external set
      :  (int32# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int32_array_set256#_indexed_by_int64#"

    external unsafe_set
      :  (int32# array[@local_opt])
      -> idx:int64#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int32_array_set256u#_indexed_by_int64#"
  end

  module Nativeint_u = struct
    external get
      :  (int32# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_int32_array_get256#_indexed_by_nativeint#"

    external unsafe_get
      :  (int32# array[@local_opt]) @ read
      -> idx:nativeint#
      -> t
      @@ portable
      = "%caml_unboxed_int32_array_get256u#_indexed_by_nativeint#"

    external set
      :  (int32# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int32_array_set256#_indexed_by_nativeint#"

    external unsafe_set
      :  (int32# array[@local_opt])
      -> idx:nativeint#
      -> t
      -> unit
      @@ portable
      = "%caml_unboxed_int32_array_set256u#_indexed_by_nativeint#"
  end
end

module Vec128 = struct
  module Raw64 (T : sig
      (** Must be one of [int64x2,float64x2]. *)
      type t : vec128
    end) =
  struct
    external load_masked
      :  mask:int64x2#
      -> nativeint#
      -> T.t
      @@ portable
      = "ocaml_simd_avx_unreachable" "caml_avx_vec128_load_mask64"
    [@@noalloc] [@@builtin]

    let[@inline] load_masked mem ~mask = load_masked ~mask mem

    external store_masked
      :  nativeint#
      -> mask:int64x2#
      -> T.t
      -> void
      @@ portable
      = "ocaml_simd_avx_unreachable" "caml_avx_vec128_store_mask64"
    [@@noalloc] [@@builtin]

    let[@inline] store_masked mem t ~mask =
      let _ : void = store_masked mem ~mask t in
      ()
    ;;
  end

  module Raw32 (T : sig
      (** Must be one of [int32x4,float32x4]. *)
      type t : vec128
    end) =
  struct
    external broadcast
      :  nativeint#
      -> T.t
      @@ portable
      = "ocaml_simd_avx_unreachable" "caml_avx_vec128_load_broadcast32"
    [@@noalloc] [@@builtin]

    external load_masked
      :  mask:int32x4#
      -> nativeint#
      -> T.t
      @@ portable
      = "ocaml_simd_avx_unreachable" "caml_avx_vec128_load_mask32"
    [@@noalloc] [@@builtin]

    let[@inline] load_masked mem ~mask = load_masked ~mask mem

    external store_masked
      :  nativeint#
      -> mask:int32x4#
      -> T.t
      -> void
      @@ portable
      = "ocaml_simd_avx_unreachable" "caml_avx_vec128_store_mask32"
    [@@noalloc] [@@builtin]

    let[@inline] store_masked mem t ~mask =
      let _ : void = store_masked mem ~mask t in
      ()
    ;;
  end

  include Ocaml_simd_sse.Load_store

  module Raw_Int32x4 = struct
    include Raw_Int32x4

    include Raw32 (struct
        type nonrec t = int32x4#
      end)
  end

  module Raw_Int64x2 = struct
    include Raw_Int64x2

    include Raw64 (struct
        type nonrec t = int64x2#
      end)
  end

  module Raw_Float32x4 = struct
    include Raw_Float32x4

    include Raw32 (struct
        type nonrec t = float32x4#
      end)
  end

  module Raw_Float64x2 = struct
    include Raw_Float64x2

    include Raw64 (struct
        type nonrec t = float64x2#
      end)
  end
end

module Raw_Int8x32 = Raw (struct
    type nonrec t = int8x32#
  end)

module Raw_Int16x16 = Raw (struct
    type nonrec t = int16x16#
  end)

module Raw_Int32x8 = struct
  include Raw32 (struct
      type nonrec t = int32x8#
    end)

  include Raw (struct
      type nonrec t = int32x8#
    end)
end

module Raw_Int64x4 = struct
  include Raw64 (struct
      type nonrec t = int64x4#
    end)

  include Raw (struct
      type nonrec t = int64x4#
    end)
end

module Raw_Float16x16 = Raw (struct
    type nonrec t = float16x16#
  end)

module Raw_Float32x8 = struct
  include Raw32 (struct
      type nonrec t = float32x8#
    end)

  include Raw (struct
      type nonrec t = float32x8#
    end)
end

module Raw_Float64x4 = struct
  include Raw64 (struct
      type nonrec t = float64x4#
    end)

  include Raw (struct
      type nonrec t = float64x4#
    end)
end

module String_Int8x32 = String (struct
    type nonrec t = int8x32#
  end)

module String_Int16x16 = String (struct
    type nonrec t = int16x16#
  end)

module String_Int32x8 = String (struct
    type nonrec t = int32x8#
  end)

module String_Int64x4 = String (struct
    type nonrec t = int64x4#
  end)

module String_Float16x16 = String (struct
    type nonrec t = float16x16#
  end)

module String_Float32x8 = String (struct
    type nonrec t = float32x8#
  end)

module String_Float64x4 = String (struct
    type nonrec t = float64x4#
  end)

module Bytes_Int8x32 = Bytes (struct
    type nonrec t = int8x32#
  end)

module Bytes_Int16x16 = Bytes (struct
    type nonrec t = int16x16#
  end)

module Bytes_Int32x8 = Bytes (struct
    type nonrec t = int32x8#
  end)

module Bytes_Int64x4 = Bytes (struct
    type nonrec t = int64x4#
  end)

module Bytes_Float16x16 = Bytes (struct
    type nonrec t = float16x16#
  end)

module Bytes_Float32x8 = Bytes (struct
    type nonrec t = float32x8#
  end)

module Bytes_Float64x4 = Bytes (struct
    type nonrec t = float64x4#
  end)

module Bigstring_Int8x32 = Bigstring (struct
    type nonrec t = int8x32#
  end)

module Bigstring_Int16x16 = Bigstring (struct
    type nonrec t = int16x16#
  end)

module Bigstring_Int32x8 = Bigstring (struct
    type nonrec t = int32x8#
  end)

module Bigstring_Int64x4 = Bigstring (struct
    type nonrec t = int64x4#
  end)

module Bigstring_Float16x16 = Bigstring (struct
    type nonrec t = float16x16#
  end)

module Bigstring_Float32x8 = Bigstring (struct
    type nonrec t = float32x8#
  end)

module Bigstring_Float64x4 = Bigstring (struct
    type nonrec t = float64x4#
  end)

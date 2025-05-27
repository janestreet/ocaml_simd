module Signed = Ocaml_simd.String.Signed
module Comparison = Ocaml_simd.String.Comparison
module Index = Ocaml_simd.String.Index
module Polarity = Ocaml_simd.String.Polarity
module Mask = Ocaml_simd.String.Mask

module Byte = struct
  type t = Int8x16.t
  type mask = Int8x16.mask

  external cmpestrm
    :  (Ocaml_simd.String.Bstrm.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (mask[@unboxed])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrm"
  [@@noalloc] [@@builtin]

  external cmpestra
    :  (Ocaml_simd.String.Bstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestra"
  [@@noalloc] [@@builtin]

  external cmpestrc
    :  (Ocaml_simd.String.Bstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrc"
  [@@noalloc] [@@builtin]

  external cmpestri
    :  (Ocaml_simd.String.Bstri.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestri"
  [@@noalloc] [@@builtin]

  external cmpestro
    :  (Ocaml_simd.String.Bstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestro"
  [@@noalloc] [@@builtin]

  external cmpistrm
    :  (Ocaml_simd.String.Bstrm.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (mask[@unboxed])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrm"
  [@@noalloc] [@@builtin]

  external cmpistra
    :  (Ocaml_simd.String.Bstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistra"
  [@@noalloc] [@@builtin]

  external cmpistrc
    :  (Ocaml_simd.String.Bstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrc"
  [@@noalloc] [@@builtin]

  external cmpistri
    :  (Ocaml_simd.String.Bstri.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistri"
  [@@noalloc] [@@builtin]

  external cmpistro
    :  (Ocaml_simd.String.Bstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistro"
  [@@noalloc] [@@builtin]

  external cmpestrs
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrs"
  [@@noalloc] [@@builtin]

  external cmpestrz
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrz"
  [@@noalloc] [@@builtin]

  external cmpistrs
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrs"
  [@@noalloc] [@@builtin]

  external cmpistrz
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrz"
  [@@noalloc] [@@builtin]

  let cmpestrs ~a ~b ~a_len ~b_len = cmpestrs 0 ~a ~b ~a_len ~b_len
  let cmpestrz ~a ~b ~a_len ~b_len = cmpestrz 0 ~a ~b ~a_len ~b_len
  let cmpistrs ~a ~b = cmpistrs 0 ~a ~b
  let cmpistrz ~a ~b = cmpistrz 0 ~a ~b
end

module Word = struct
  type t = Int16x8.t
  type mask = Int16x8.mask

  external cmpestrm
    :  (Ocaml_simd.String.Wstrm.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (mask[@unboxed])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrm"
  [@@noalloc] [@@builtin]

  external cmpestra
    :  (Ocaml_simd.String.Wstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestra"
  [@@noalloc] [@@builtin]

  external cmpestrc
    :  (Ocaml_simd.String.Wstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrc"
  [@@noalloc] [@@builtin]

  external cmpestri
    :  (Ocaml_simd.String.Wstri.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestri"
  [@@noalloc] [@@builtin]

  external cmpestro
    :  (Ocaml_simd.String.Wstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestro"
  [@@noalloc] [@@builtin]

  external cmpistrm
    :  (Ocaml_simd.String.Wstrm.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (mask[@unboxed])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrm"
  [@@noalloc] [@@builtin]

  external cmpistra
    :  (Ocaml_simd.String.Wstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistra"
  [@@noalloc] [@@builtin]

  external cmpistrc
    :  (Ocaml_simd.String.Wstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrc"
  [@@noalloc] [@@builtin]

  external cmpistri
    :  (Ocaml_simd.String.Wstri.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistri"
  [@@noalloc] [@@builtin]

  external cmpistro
    :  (Ocaml_simd.String.Wstr.t[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistro"
  [@@noalloc] [@@builtin]

  external cmpestrs
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrs"
  [@@noalloc] [@@builtin]

  external cmpestrz
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> a_len:(int[@untagged])
    -> b_len:(int[@untagged])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpestrz"
  [@@noalloc] [@@builtin]

  external cmpistrs
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrs"
  [@@noalloc] [@@builtin]

  external cmpistrz
    :  (int[@untagged])
    -> a:(t[@unboxed])
    -> b:(t[@unboxed])
    -> (int[@untagged])
    = "ocaml_simd_unreachable" "caml_sse42_vec128_cmpistrz"
  [@@noalloc] [@@builtin]

  let cmpestrs ~a ~b ~a_len ~b_len = cmpestrs 1 ~a ~b ~a_len ~b_len
  let cmpestrz ~a ~b ~a_len ~b_len = cmpestrz 1 ~a ~b ~a_len ~b_len
  let cmpistrs ~a ~b = cmpistrs 1 ~a ~b
  let cmpistrz ~a ~b = cmpistrz 1 ~a ~b
end

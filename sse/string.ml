module Signed = Ocaml_simd.String.Signed
module Comparison = Ocaml_simd.String.Comparison
module Index = Ocaml_simd.String.Index
module Polarity = Ocaml_simd.String.Polarity
module Mask = Ocaml_simd.String.Mask

module Byte = struct
  type t = Int8x16.t
  type mask = Int8x16.mask

  external cmpestrm
    :  (Ocaml_simd.String.Bytesm.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> mask
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrm"
  [@@noalloc] [@@builtin amd64]

  external cmpestra
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestra"
  [@@noalloc] [@@builtin amd64]

  external cmpestrc
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrc"
  [@@noalloc] [@@builtin amd64]

  external cmpestri
    :  (Ocaml_simd.String.Bytesi.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestri"
  [@@noalloc] [@@builtin amd64]

  external cmpestro
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestro"
  [@@noalloc] [@@builtin amd64]

  external cmpistrm
    :  (Ocaml_simd.String.Bytesm.t[@untagged])
    -> a:t
    -> b:t
    -> mask
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrm"
  [@@noalloc] [@@builtin amd64]

  external cmpistra
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistra"
  [@@noalloc] [@@builtin amd64]

  external cmpistrc
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrc"
  [@@noalloc] [@@builtin amd64]

  external cmpistri
    :  (Ocaml_simd.String.Bytesi.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistri"
  [@@noalloc] [@@builtin amd64]

  external cmpistro
    :  (Ocaml_simd.String.Bytes.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistro"
  [@@noalloc] [@@builtin amd64]

  external cmpestrs
    :  int64#
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrs"
  [@@noalloc] [@@builtin amd64]

  external cmpestrz
    :  int64#
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrz"
  [@@noalloc] [@@builtin amd64]

  external cmpistrs
    :  int64#
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrs"
  [@@noalloc] [@@builtin amd64]

  external cmpistrz
    :  int64#
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrz"
  [@@noalloc] [@@builtin amd64]

  let cmpestrs ~a ~b ~a_len ~b_len = cmpestrs #0L ~a ~b ~a_len ~b_len
  let cmpestrz ~a ~b ~a_len ~b_len = cmpestrz #0L ~a ~b ~a_len ~b_len
  let cmpistrs ~a ~b = cmpistrs #0L ~a ~b
  let cmpistrz ~a ~b = cmpistrz #0L ~a ~b
end

module Word = struct
  type t = Int16x8.t
  type mask = Int16x8.mask

  external cmpestrm
    :  (Ocaml_simd.String.Wordsm.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> mask
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrm"
  [@@noalloc] [@@builtin amd64]

  external cmpestra
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestra"
  [@@noalloc] [@@builtin amd64]

  external cmpestrc
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrc"
  [@@noalloc] [@@builtin amd64]

  external cmpestri
    :  (Ocaml_simd.String.Wordsi.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestri"
  [@@noalloc] [@@builtin amd64]

  external cmpestro
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestro"
  [@@noalloc] [@@builtin amd64]

  external cmpistrm
    :  (Ocaml_simd.String.Wordsm.t[@untagged])
    -> a:t
    -> b:t
    -> mask
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrm"
  [@@noalloc] [@@builtin amd64]

  external cmpistra
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistra"
  [@@noalloc] [@@builtin amd64]

  external cmpistrc
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrc"
  [@@noalloc] [@@builtin amd64]

  external cmpistri
    :  (Ocaml_simd.String.Wordsi.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistri"
  [@@noalloc] [@@builtin amd64]

  external cmpistro
    :  (Ocaml_simd.String.Words.t[@untagged])
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistro"
  [@@noalloc] [@@builtin amd64]

  external cmpestrs
    :  int64#
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrs"
  [@@noalloc] [@@builtin amd64]

  external cmpestrz
    :  int64#
    -> a:t
    -> b:t
    -> a_len:int64#
    -> b_len:int64#
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpestrz"
  [@@noalloc] [@@builtin amd64]

  external cmpistrs
    :  int64#
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrs"
  [@@noalloc] [@@builtin amd64]

  external cmpistrz
    :  int64#
    -> a:t
    -> b:t
    -> int64#
    @@ portable
    = "ocaml_simd_sse_unreachable" "caml_sse42_vec128_cmpistrz"
  [@@noalloc] [@@builtin amd64]

  let cmpestrs ~a ~b ~a_len ~b_len = cmpestrs #1L ~a ~b ~a_len ~b_len
  let cmpestrz ~a ~b ~a_len ~b_len = cmpestrz #1L ~a ~b ~a_len ~b_len
  let cmpistrs ~a ~b = cmpistrs #1L ~a ~b
  let cmpistrz ~a ~b = cmpistrz #1L ~a ~b
end

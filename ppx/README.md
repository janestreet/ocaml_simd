# SIMD Constant Syntax

This ppx provides convenient syntax for declaring SIMD instruction modifiers.

Such modifiers must be known at compile time, as they are included in the
binary encoding of the relevant instruction. The purpose of this ppx
is to assure that this is possible.
Hence, it translates statically known parameters to an integer literal
for the compiler to interpret.

There are currently five directives:

- `[%blend N, ...]` generates an `Ocaml_simd.Blend{2,4,8}.t`

   For example, `Float32x4.blend [%blend 0, 1, 0, 1] a b`

- `[%shuffle N, ...]` generates an `Ocaml_simd.Shuffle{2,2x2,4}.t`

   For example, `Float32x4.shuffle [%shuffle 3, 2, 1, 0] a b`

- `[%permute N, ...]` generates an `Ocaml_simd.Permute{2,2x2,4}.t`

   For example, `Float32x4.permute [%permute 3, 2, 1, 0] a`

- `[%bytes {Signed.t}, {Comparison.t}, {Polarity.t}, ?{Index.t|Mask.t}]`
   generates an `Ocaml_simd.Bytes{,i,m}`

   For example, `String.Byte.cmpistri [%bytes Signed, Eq_any, Pos, Least_sig] a b`

- `[%words {Signed.t}, {Comparison.t}, {Polarity.t}, ?{Index.t|Mask.t}]`
   generates an `Ocaml_simd.Words{,i,m}`

   For example, `String.Word.cmpistrm [%words Signed, Eq_any, Pos, Vec_mask] a b`

For usage details, see [`ocaml_simd`](../src/README.md) and the
relevant interfaces in `../sse/`.

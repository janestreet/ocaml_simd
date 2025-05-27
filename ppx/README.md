# SIMD Constant Syntax

This ppx provides convenient syntax for declaring SIMD instruction modifiers.

Such modifiers must be known at compile time, as they are included in the
binary encoding of the relevant instruction. The purpose of this ppx
is to assure that this is possible.
Hence, it translates statically known parameters to an integer literal
for the compiler to interpret.

There are currently four directives:

- `[%blend N, ...]` generates an `Ocaml_simd.Blend{2,4,8}.t`

   For example, `Float32x4.blend [%blend 0, 1, 0, 1] a b`

- `[%shuffle N, ...]` generates an `Ocaml_simd.Shuffle{2,4}.t`

   For example, `Float32x4.blend [%shuffle 3, 2, 1, 0] a b`

- `[%bstr {Signed.t}, {Comparison.t}, {Polarity.t}, ?{Index.t|Mask.t}]`
   generates an `Ocaml_simd.Bstr{,i,m}`

   For example, `String.Byte.cmpistri [%bstr Signed, Eq_any, Pos, Least_sig] a b`

- `[%wstr {Signed.t}, {Comparison.t}, {Polarity.t}, ?{Index.t|Mask.t}]`
   generates an `Ocaml_simd.Wstr{,i,m}`

   For example, `String.Word.cmpistrm [%bstr Signed, Eq_any, Pos, Vec_mask] a b`

For usage details, see [`ocaml_simd`](../src/README.md) and the
relevant interfaces in `../sse/`.

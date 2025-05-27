open Base
open Ppxlib

let failure ~loc fmt =
  Stdlib.Format.kasprintf (fun s -> Error (Location.Error.make ~loc ~sub:[] s)) fmt
;;

let eint_range ~max =
  let open Ast_pattern in
  map' (eint __) ~f:(fun loc f x ->
    (if x < 0 || x >= max
     then failure ~loc "Argument '%d' must be in range [0,%d]." x (max - 1)
     else Ok x)
    |> f)
;;

let etwoints_range ~max =
  let open Ast_pattern in
  let open Result.Let_syntax in
  pstr (pstr_eval (pexp_tuple (eint_range ~max ^:: eint_range ~max ^:: nil)) nil ^:: nil)
  |> map ~f:(fun f a b ->
    (let%map a and b in
     a, b)
    |> f)
;;

let efourints_range ~max =
  let open Ast_pattern in
  let open Result.Let_syntax in
  pstr
    (pstr_eval
       (pexp_tuple
          (eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: nil))
       nil
     ^:: nil)
  |> map ~f:(fun f a b c d ->
    (let%map a and b and c and d in
     a, b, c, d)
    |> f)
;;

let eeightints_range ~max =
  let open Ast_pattern in
  let open Result.Let_syntax in
  pstr
    (pstr_eval
       (pexp_tuple
          (eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: eint_range ~max
           ^:: nil))
       nil
     ^:: nil)
  |> map ~f:(fun ff a b c d e f g h ->
    (let%map a and b and c and d and e and f and g and h in
     a, b, c, d, e, f, g, h)
    |> ff)
;;

module Pack = struct
  module Blend = struct
    type args =
      | Two of int * int
      | Four of int * int * int * int
      | Eight of int * int * int * int * int * int * int * int

    let pack = function
      | Two (a, b) -> `Two, a lor (b lsl 1)
      | Four (a, b, c, d) -> `Four, a lor (b lsl 1) lor (c lsl 2) lor (d lsl 3)
      | Eight (a, b, c, d, e, f, g, h) ->
        ( `Eight
        , a
          lor (b lsl 1)
          lor (c lsl 2)
          lor (d lsl 3)
          lor (e lsl 4)
          lor (f lsl 5)
          lor (g lsl 6)
          lor (h lsl 7) )
    ;;
  end

  module Shuffle = struct
    type args =
      | Two of int * int
      | Four of int * int * int * int

    let pack = function
      | Two (a, b) -> `Two, a lor (b lsl 1)
      | Four (a, b, c, d) -> `Four, a lor (b lsl 2) lor (c lsl 4) lor (d lsl 6)
    ;;
  end

  module String = struct
    open Ocaml_simd.String

    type args =
      | Plain of Signed.t * Comparison.t * Polarity.t
      | Indexed of Signed.t * Comparison.t * Polarity.t * Index.t
      | Masked of Signed.t * Comparison.t * Polarity.t * Mask.t

    module Const = struct
      (** See the Intel SDM, Volume 2, Chapter 4.1: "IMM8 Control Byte Operation for
          PCMPESTRI / PCMPESTRM / PCMPISTRI / PCMPISTRM" *)

      let ubyte_data = 0b0000_0000
      let uword_data = 0b0000_0001
      let sbyte_data = 0b0000_0010
      let sword_data = 0b0000_0011
      let cmp_equal_any = 0b0000_0000
      let cmp_ranges = 0b0000_0100
      let cmp_equal_each = 0b0000_1000
      let cmp_equal_ordered = 0b0000_1100
      let positive_polarity = 0b0000_0000
      let negative_polarity = 0b0001_0000
      let masked_negative_polarity = 0b0011_0000
      let masked_positive_polarity = 0b0010_0000
      let least_significant = 0b0000_0000
      let most_significant = 0b0100_0000
      let bit_mask = 0b0000_0000
      let unit_mask = 0b0100_0000
    end

    let signed ~size (signed : Signed.t) =
      match size, signed with
      | `Byte, Signed -> Const.sbyte_data
      | `Word, Signed -> Const.sword_data
      | `Byte, Unsigned -> Const.ubyte_data
      | `Word, Unsigned -> Const.uword_data
    ;;

    let comparison : Comparison.t -> int = function
      | Eq_any -> Const.cmp_equal_any
      | Eq_each -> Const.cmp_equal_each
      | Eq_ordered -> Const.cmp_equal_ordered
      | In_range -> Const.cmp_ranges
    ;;

    let polarity : Polarity.t -> int = function
      | Pos -> Const.positive_polarity
      | Neg -> Const.negative_polarity
      | Masked_pos -> Const.masked_positive_polarity
      | Masked_neg -> Const.masked_negative_polarity
    ;;

    let index : Index.t -> int = function
      | Least_sig -> Const.least_significant
      | Most_sig -> Const.most_significant
    ;;

    let mask : Mask.t -> int = function
      | Bit_mask -> Const.bit_mask
      | Vec_mask -> Const.unit_mask
    ;;

    let pack ~size = function
      | Plain (s, c, p) -> `Plain, signed ~size s lor comparison c lor polarity p
      | Indexed (s, c, p, i) ->
        `Indexed, signed ~size s lor comparison c lor polarity p lor index i
      | Masked (s, c, p, m) ->
        `Masked, signed ~size s lor comparison c lor polarity p lor mask m
    ;;
  end
end

module Blend = struct
  open Ast_pattern

  let etwo ~max =
    etwoints_range ~max
    |> map ~f:(fun f ints -> f (Result.map ints ~f:(fun (a, b) -> Pack.Blend.Two (a, b))))
  ;;

  let efour ~max =
    efourints_range ~max
    |> map ~f:(fun f ints ->
      f (Result.map ints ~f:(fun (a, b, c, d) -> Pack.Blend.Four (a, b, c, d))))
  ;;

  let eeight ~max =
    eeightints_range ~max
    |> map ~f:(fun f ints ->
      f
        (Result.map ints ~f:(fun (a, b, c, d, e, f, g, h) ->
           Pack.Blend.Eight (a, b, c, d, e, f, g, h))))
  ;;

  let extension =
    let open Ast_builder.Default in
    Extension.declare
      "blend"
      Extension.Context.expression
      Ast_pattern.(etwo ~max:2 ||| efour ~max:2 ||| eeight ~max:2)
      (fun ~loc ~path:_ blend ->
        Merlin_helpers.hide_expression
          (match blend with
           | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
           | Ok blend ->
             let kind, imm = Pack.Blend.pack blend in
             let imm = eint ~loc imm in
             (match kind with
              | `Two -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Blend2.t)]
              | `Four -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Blend4.t)]
              | `Eight -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Blend8.t)])))
  ;;
end

module Shuffle = struct
  open Ast_pattern

  let etwo ~max =
    etwoints_range ~max
    |> map ~f:(fun f ints ->
      f (Result.map ints ~f:(fun (a, b) -> Pack.Shuffle.Two (a, b))))
  ;;

  let efour ~max =
    efourints_range ~max
    |> map ~f:(fun f ints ->
      f (Result.map ints ~f:(fun (a, b, c, d) -> Pack.Shuffle.Four (a, b, c, d))))
  ;;

  let extension =
    let open Ast_builder.Default in
    Extension.declare
      "shuffle"
      Extension.Context.expression
      Ast_pattern.(etwo ~max:2 ||| efour ~max:4)
      (fun ~loc ~path:_ shuffle ->
        Merlin_helpers.hide_expression
          (match shuffle with
           | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
           | Ok shuffle ->
             let kind, imm = Pack.Shuffle.pack shuffle in
             let imm = eint ~loc imm in
             (match kind with
              | `Two -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Shuffle2.t)]
              | `Four -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Shuffle4.t)])))
  ;;
end

module String = struct
  open Ast_pattern

  let bad_name ~loc s expected =
    failure
      ~loc
      "Argument '%s' must be one of [%s]."
      s
      (Base.String.concat ~sep:"," expected)
  ;;

  let esigned () =
    let open Ocaml_simd.String.Signed in
    pexp_construct (lident __) none
    |> map' ~f:(fun loc f s ->
      match s with
      | "Signed" -> f (Ok Signed)
      | "Unsigned" -> f (Ok Unsigned)
      | _ -> f (bad_name ~loc s [ "Signed"; "Unsigned" ]))
  ;;

  let ecomparison () =
    let open Ocaml_simd.String.Comparison in
    pexp_construct (lident __) none
    |> map' ~f:(fun loc f s ->
      match s with
      | "Eq_any" -> f (Ok Eq_any)
      | "Eq_each" -> f (Ok Eq_each)
      | "Eq_ordered" -> f (Ok Eq_ordered)
      | "In_range" -> f (Ok In_range)
      | _ -> f (bad_name ~loc s [ "Eq_any"; "Eq_each"; "Eq_ordered"; "In_range" ]))
  ;;

  let epolarity () =
    let open Ocaml_simd.String.Polarity in
    pexp_construct (lident __) none
    |> map' ~f:(fun loc f s ->
      match s with
      | "Pos" -> f (Ok Pos)
      | "Neg" -> f (Ok Neg)
      | "Masked_pos" -> f (Ok Masked_pos)
      | "Masked_neg" -> f (Ok Masked_neg)
      | _ -> f (bad_name ~loc s [ "Pos"; "Neg"; "Masked_pos"; "Masked_neg" ]))
  ;;

  let eindexmask () =
    let open Ocaml_simd.String.Mask in
    let open Ocaml_simd.String.Index in
    pexp_construct (lident __) none
    |> map' ~f:(fun loc f s ->
      match s with
      | "Bit_mask" -> f (Ok (`Mask Bit_mask))
      | "Vec_mask" -> f (Ok (`Mask Vec_mask))
      | "Least_sig" -> f (Ok (`Index Least_sig))
      | "Most_sig" -> f (Ok (`Index Most_sig))
      | _ -> f (bad_name ~loc s [ "Least_sig"; "Most_sig"; "Bit_mask"; "Vec_mask" ]))
  ;;

  let esigned_comparison_polarity =
    let open Result.Let_syntax in
    pstr
      (pstr_eval (pexp_tuple (esigned () ^:: ecomparison () ^:: epolarity () ^:: nil)) nil
       ^:: nil)
    |> map ~f:(fun f s c p ->
      (let%map s and c and p in
       Pack.String.Plain (s, c, p))
      |> f)
  ;;

  let esigned_comparison_polarity_indexmask =
    let open Result.Let_syntax in
    pstr
      (pstr_eval
         (pexp_tuple
            (esigned () ^:: ecomparison () ^:: epolarity () ^:: eindexmask () ^:: nil))
         nil
       ^:: nil)
    |> map ~f:(fun f s c p im ->
      (let%map s and c and p and im in
       match im with
       | `Mask m -> Pack.String.Masked (s, c, p, m)
       | `Index i -> Pack.String.Indexed (s, c, p, i))
      |> f)
  ;;

  let extension ~size ~loc ~path:_ =
    let open Ast_builder.Default in
    function
    | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
    | Ok str ->
      let kind, imm = Pack.String.pack ~size str in
      let imm = eint ~loc imm in
      (match size, kind with
       | `Byte, `Plain -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Bstr.t)]
       | `Byte, `Indexed -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Bstri.t)]
       | `Byte, `Masked -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Bstrm.t)]
       | `Word, `Plain -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Wstr.t)]
       | `Word, `Indexed -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Wstri.t)]
       | `Word, `Masked -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Wstrm.t)])
      |> Merlin_helpers.hide_expression
  ;;

  let byte_extension =
    Extension.declare
      "bstr"
      Extension.Context.expression
      Ast_pattern.(esigned_comparison_polarity ||| esigned_comparison_polarity_indexmask)
      (extension ~size:`Byte)
  ;;

  let word_extension =
    Extension.declare
      "wstr"
      Extension.Context.expression
      Ast_pattern.(esigned_comparison_polarity ||| esigned_comparison_polarity_indexmask)
      (extension ~size:`Word)
  ;;
end

let () =
  Driver.register_transformation
    "simd"
    ~extensions:
      [ Blend.extension; Shuffle.extension; String.byte_extension; String.word_extension ]
;;

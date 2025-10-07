open Base
open Ppxlib

module Pattern = struct
  open Ast_pattern

  let failure ~loc fmt =
    Stdlib.Format.kasprintf (fun s -> Error (Location.Error.make ~loc ~sub:[] s)) fmt
  ;;

  let bad_name ~loc s expected =
    failure
      ~loc
      "Argument '%s' must be one of [%s]."
      s
      (Base.String.concat ~sep:"," expected)
  ;;

  let eint_range ~max =
    map' (eint __) ~f:(fun loc f x ->
      (if x < 0 || x >= max
       then failure ~loc "Argument '%d' must be in range [0,%d]." x (max - 1)
       else Ok x)
      |> f)
  ;;

  let etwoints_range ~max =
    let open Result.Let_syntax in
    pstr (pstr_eval (pexp_tuple (eint_range ~max ^:: eint_range ~max ^:: nil)) nil ^:: nil)
    |> map ~f:(fun f a b ->
      (let%map a and b in
       a, b)
      |> f)
  ;;

  let etwoxtwoints_range ~max =
    let open Result.Let_syntax in
    pstr
      (pstr_eval
         (pexp_tuple
            (pexp_tuple (eint_range ~max ^:: eint_range ~max ^:: nil)
             ^:: pexp_tuple (eint_range ~max ^:: eint_range ~max ^:: nil)
             ^:: nil))
         nil
       ^:: nil)
    |> map ~f:(fun f a b c d ->
      (let%map a and b and c and d in
       a, b, c, d)
      |> f)
  ;;

  let efourints_range ~max =
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

    let etwo ~max =
      etwoints_range ~max
      |> map ~f:(fun f ints -> f (Result.map ints ~f:(fun (a, b) -> Two (a, b))))
    ;;

    let efour ~max =
      efourints_range ~max
      |> map ~f:(fun f ints ->
        f (Result.map ints ~f:(fun (a, b, c, d) -> Four (a, b, c, d))))
    ;;

    let eeight ~max =
      eeightints_range ~max
      |> map ~f:(fun f ints ->
        f
          (Result.map ints ~f:(fun (a, b, c, d, e, f, g, h) ->
             Eight (a, b, c, d, e, f, g, h))))
    ;;

    let pattern = etwo ~max:2 ||| efour ~max:2 ||| eeight ~max:2
  end

  module Shuffle_or_permute = struct
    type args =
      | Two of int * int
      | TwoxTwo of int * int * int * int
      | Four of int * int * int * int

    let pack = function
      | Two (a, b) -> `Two, a lor (b lsl 1)
      | TwoxTwo (a, b, c, d) -> `TwoxTwo, a lor (b lsl 1) lor (c lsl 2) lor (d lsl 3)
      | Four (a, b, c, d) -> `Four, a lor (b lsl 2) lor (c lsl 4) lor (d lsl 6)
    ;;

    let etwo ~max =
      etwoints_range ~max
      |> map ~f:(fun f ints -> f (Result.map ints ~f:(fun (a, b) -> Two (a, b))))
    ;;

    let etwoxtwo ~max =
      etwoxtwoints_range ~max
      |> map ~f:(fun f ints ->
        f (Result.map ints ~f:(fun (a, b, c, d) -> TwoxTwo (a, b, c, d))))
    ;;

    let efour ~max =
      efourints_range ~max
      |> map ~f:(fun f ints ->
        f (Result.map ints ~f:(fun (a, b, c, d) -> Four (a, b, c, d))))
    ;;

    let pattern = etwo ~max:2 ||| etwoxtwo ~max:2 ||| efour ~max:4
  end

  module String = struct
    open Ocaml_simd.String

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

    type args =
      | Plain of Signed.t * Comparison.t * Polarity.t
      | Indexed of Signed.t * Comparison.t * Polarity.t * Index.t
      | Masked of Signed.t * Comparison.t * Polarity.t * Mask.t

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
        (pstr_eval
           (pexp_tuple (esigned () ^:: ecomparison () ^:: epolarity () ^:: nil))
           nil
         ^:: nil)
      |> map ~f:(fun f s c p ->
        (let%map s and c and p in
         Plain (s, c, p))
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
         | `Mask m -> Masked (s, c, p, m)
         | `Index i -> Indexed (s, c, p, i))
        |> f)
    ;;

    let pattern = esigned_comparison_polarity ||| esigned_comparison_polarity_indexmask
  end

  module Comparison = struct
    open Ocaml_simd.Float.Comparison

    module Const = struct
      (** See the Intel SDM, Volume 2, Table 3-1: "Comparison Predicate for CMPPD and
          CMPPS Instructions" *)

      let equal = 0x0
      let less = 0x1
      let less_or_equal = 0x2
      let unordered = 0x3
      let not_equal = 0x4
      let not_less = 0x5
      let not_less_or_equal = 0x6
      let ordered = 0x7
    end

    let pack = function
      | Equal -> Const.equal
      | Less -> Const.less
      | Less_or_equal -> Const.less_or_equal
      | Unordered -> Const.unordered
      | Not_equal -> Const.not_equal
      | Not_less -> Const.not_less
      | Not_less_or_equal -> Const.not_less_or_equal
      | Ordered -> Const.ordered
    ;;

    let ecomparison =
      pstr
        (pstr_eval
           (pexp_construct (lident __) none
            |> map' ~f:(fun loc f s ->
              match s with
              | "Equal" -> f (Ok Equal)
              | "Less" -> f (Ok Less)
              | "Less_or_equal" -> f (Ok Less_or_equal)
              | "Unordered" -> f (Ok Unordered)
              | "Not_equal" -> f (Ok Not_equal)
              | "Not_less" -> f (Ok Not_less)
              | "Not_less_or_equal" -> f (Ok Not_less_or_equal)
              | "Ordered" -> f (Ok Ordered)
              | _ ->
                f
                  (bad_name
                     ~loc
                     s
                     [ "Equal"
                     ; "Less"
                     ; "Less_or_equal"
                     ; "Unordered"
                     ; "Not_equal"
                     ; "Not_less"
                     ; "Not_less_or_equal"
                     ; "Ordered"
                     ])))
           nil
         ^:: nil)
    ;;

    let pattern = ecomparison
  end

  module Rounding = struct
    open Ocaml_simd.Float.Rounding

    module Const = struct
      (** See the Intel SDM, Volume 2, Figure 4-24 / Table 4-18: "Rounding Modes and
          Encoding of Rounding Control (RC) Field" *)

      let nearest = 0x8
      let negative_infinity = 0x9
      let positive_infinity = 0xA
      let zero = 0xB
      let current = 0xC
    end

    let pack = function
      | Nearest -> Const.nearest
      | Negative_infinity -> Const.negative_infinity
      | Positive_infinity -> Const.positive_infinity
      | Zero -> Const.zero
      | Current -> Const.current
    ;;

    let erounding =
      let open Ocaml_simd.Float.Rounding in
      pstr
        (pstr_eval
           (pexp_construct (lident __) none
            |> map' ~f:(fun loc f s ->
              match s with
              | "Nearest" -> f (Ok Nearest)
              | "Negative_infinity" -> f (Ok Negative_infinity)
              | "Positive_infinity" -> f (Ok Positive_infinity)
              | "Zero" -> f (Ok Zero)
              | "Current" -> f (Ok Current)
              | _ ->
                f
                  (bad_name
                     ~loc
                     s
                     [ "Nearest"
                     ; "Negative_infinity"
                     ; "Positive_infinity"
                     ; "Zero"
                     ; "Current"
                     ])))
           nil
         ^:: nil)
    ;;

    let pattern = erounding
  end
end

module Blend = struct
  let extension =
    let open Ast_builder.Default in
    Extension.declare
      "simd.blend"
      Extension.Context.expression
      Pattern.Blend.pattern
      (fun ~loc ~path:_ blend ->
         Merlin_helpers.hide_expression
           (match blend with
            | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
            | Ok blend ->
              let kind, imm = Pattern.Blend.pack blend in
              let imm = eint ~loc imm in
              (match kind with
               | `Two -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Blend2.t)]
               | `Four -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Blend4.t)]
               | `Eight -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Blend8.t)])))
  ;;
end

module Shuffle = struct
  let extension =
    let open Ast_builder.Default in
    Extension.declare
      "simd.shuffle"
      Extension.Context.expression
      Pattern.Shuffle_or_permute.pattern
      (fun ~loc ~path:_ shuffle ->
         Merlin_helpers.hide_expression
           (match shuffle with
            | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
            | Ok shuffle ->
              let kind, imm = Pattern.Shuffle_or_permute.pack shuffle in
              let imm = eint ~loc imm in
              (match kind with
               | `Two -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Shuffle2.t)]
               | `TwoxTwo -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Shuffle2x2.t)]
               | `Four -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Shuffle4.t)])))
  ;;
end

module Permute = struct
  let extension =
    let open Ast_builder.Default in
    Extension.declare
      "simd.permute"
      Extension.Context.expression
      Pattern.Shuffle_or_permute.pattern
      (fun ~loc ~path:_ permute ->
         Merlin_helpers.hide_expression
           (match permute with
            | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
            | Ok permute ->
              let kind, imm = Pattern.Shuffle_or_permute.pack permute in
              let imm = eint ~loc imm in
              (match kind with
               | `Two -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Permute2.t)]
               | `TwoxTwo -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Permute2x2.t)]
               | `Four -> [%expr (Obj.magic [%e imm] : Ocaml_simd.Permute4.t)])))
  ;;
end

module String = struct
  let extension ~size ~loc ~path:_ =
    let open Ast_builder.Default in
    function
    | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
    | Ok str ->
      let kind, imm = Pattern.String.pack ~size str in
      let imm = eint ~loc imm in
      (match size, kind with
       | `Byte, `Plain -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Bytes.t)]
       | `Byte, `Indexed -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Bytesi.t)]
       | `Byte, `Masked -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Bytesm.t)]
       | `Word, `Plain -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Words.t)]
       | `Word, `Indexed -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Wordsi.t)]
       | `Word, `Masked -> [%expr (Obj.magic [%e imm] : Ocaml_simd.String.Wordsm.t)])
      |> Merlin_helpers.hide_expression
  ;;

  let byte_extension =
    Extension.declare
      "simd.bytes"
      Extension.Context.expression
      Pattern.String.pattern
      (extension ~size:`Byte)
  ;;

  let word_extension =
    Extension.declare
      "simd.words"
      Extension.Context.expression
      Pattern.String.pattern
      (extension ~size:`Word)
  ;;
end

module Comparison = struct
  let extension =
    let open Ast_builder.Default in
    Extension.declare
      "simd.float_compare"
      Extension.Context.expression
      Pattern.Comparison.pattern
      (fun ~loc ~path:_ comparison ->
         Merlin_helpers.hide_expression
           (match comparison with
            | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
            | Ok comparison ->
              let imm = Pattern.Comparison.pack comparison in
              let imm = eint ~loc imm in
              [%expr (Obj.magic [%e imm] : Ocaml_simd.Float.Comparison.t)]))
  ;;
end

module Rounding = struct
  let extension =
    let open Ast_builder.Default in
    Extension.declare
      "simd.float_round"
      Extension.Context.expression
      Pattern.Rounding.pattern
      (fun ~loc ~path:_ rounding ->
         Merlin_helpers.hide_expression
           (match rounding with
            | Error err -> pexp_extension ~loc (Location.Error.to_extension err)
            | Ok rounding ->
              let imm = Pattern.Rounding.pack rounding in
              let imm = eint ~loc imm in
              [%expr (Obj.magic [%e imm] : Ocaml_simd.Float.Rounding.t)]))
  ;;
end

let () =
  Driver.register_transformation
    "simd"
    ~extensions:
      [ Comparison.extension
      ; Rounding.extension
      ; Blend.extension
      ; Shuffle.extension
      ; Permute.extension
      ; String.byte_extension
      ; String.word_extension
      ]
;;

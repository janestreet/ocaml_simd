module type Abstract = sig
  type t = private int
end

module Abstract (_ : sig end) : Abstract = struct
  type t = private int
end

module Blend2 = Abstract (struct end)
module Blend4 = Abstract (struct end)
module Blend8 = Abstract (struct end)
module Shuffle2 = Abstract (struct end)
module Shuffle2x2 = Abstract (struct end)
module Shuffle4 = Abstract (struct end)
module Permute2 = Abstract (struct end)
module Permute2x2 = Abstract (struct end)
module Permute4 = Abstract (struct end)

module Float = struct
  module Comparison = struct
    type t =
      | Equal
      | Less
      | Less_or_equal
      | Unordered
      | Not_equal
      | Not_less
      | Not_less_or_equal
      | Ordered
  end

  module Rounding = struct
    type t =
      | Nearest
      | Negative_infinity
      | Positive_infinity
      | Zero
      | Current
  end
end

module String = struct
  module Bytes = Abstract (struct end)
  module Bytesm = Abstract (struct end)
  module Bytesi = Abstract (struct end)
  module Words = Abstract (struct end)
  module Wordsm = Abstract (struct end)
  module Wordsi = Abstract (struct end)

  module Signed = struct
    type t =
      | Signed
      | Unsigned
  end

  module Comparison = struct
    type t =
      | Eq_any
      | Eq_each
      | Eq_ordered
      | In_range
  end

  module Polarity = struct
    type t =
      | Pos
      | Neg
      | Masked_pos
      | Masked_neg
  end

  module Index = struct
    type t =
      | Least_sig
      | Most_sig
  end

  module Mask = struct
    type t =
      | Bit_mask
      | Vec_mask
  end
end

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
module Shuffle4 = Abstract (struct end)

module String = struct
  module Bstr = Abstract (struct end)
  module Bstrm = Abstract (struct end)
  module Bstri = Abstract (struct end)
  module Wstr = Abstract (struct end)
  module Wstrm = Abstract (struct end)
  module Wstri = Abstract (struct end)

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

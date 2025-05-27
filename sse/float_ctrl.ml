module Compare = struct
  type t = int

  (** See the Intel SDM, Volume 2, Table 3-1: "Comparison Predicate for CMPPD and CMPPS
      Instructions" *)

  let equal : t = 0x0
  let less : t = 0x1
  let less_or_equal : t = 0x2
  let unordered : t = 0x3
  let not_equal : t = 0x4
  let not_less : t = 0x5
  let not_less_or_equal : t = 0x6
  let ordered : t = 0x7
end

module Round = struct
  type t = int

  (** See the Intel SDM, Volume 2, Figure 4-24 / Table 4-18: "Rounding Modes and Encoding
      of Rounding Control (RC) Field" *)

  let nearest : t = 0x8
  let negative_infinity : t = 0x9
  let positive_infinity : t = 0xA
  let zero : t = 0xB
  let current : t = 0xC
end

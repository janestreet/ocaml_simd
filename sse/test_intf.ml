module type S = sig
  type t : vec128

  (** [_mm_testz_si128]: computes [x & y = 0]. *)
  val disjoint : t -> t -> bool

  (** [_mm_testc_si128]: computes [~x & y = 0]. *)
  val subset : t -> t -> bool

  (** [_mm_testnzc_si128]: computes [!disjoint && !subset]. *)
  val intersect : t -> t -> bool

  (** Returns [true] if all bits are set. *)
  val is_ones : t -> bool

  (** Returns [true] if no bits are set. *)
  val is_zeros : t -> bool

  (** Returns [true] if some bits are set and some are not. *)
  val is_mixed : t -> bool
end

module type Test = sig @@ portable
  module type S = S

  module Int8x16 : S with type t := int8x16#
  module Int16x8 : S with type t := int16x8#
  module Int32x4 : S with type t := int32x4#
  module Int64x2 : S with type t := int64x2#
end

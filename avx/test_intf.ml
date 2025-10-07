module type S = sig
  type t : vec256

  (** [_mm256_testz_si256]: computes [x & y = 0]. *)
  val disjoint : t -> t -> bool

  (** [_mm256_testc_si256]: computes [~x & y = 0]. *)
  val subset : t -> t -> bool

  (** [_mm256_testnzc_si256]: computes [!disjoint && !subset]. *)
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

  module Int8x32 : S with type t := int8x32#
  module Int16x16 : S with type t := int16x16#
  module Int32x8 : S with type t := int32x8#
  module Int64x4 : S with type t := int64x4#
end

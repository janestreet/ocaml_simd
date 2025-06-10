@@ portable

type ('a : vec128) t = { mutable contents : 'a }

val create : ('a : vec128). 'a -> 'a t
val get : ('a : vec128). 'a t -> 'a
val set : ('a : vec128). 'a t -> 'a -> unit

module O : sig
  val ( ! ) : ('a : vec128). 'a t -> 'a
  val ( := ) : ('a : vec128). 'a t -> 'a -> unit
end

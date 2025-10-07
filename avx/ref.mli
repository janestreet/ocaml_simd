@@ portable

type ('a : vec256) t = { mutable contents : 'a }

val create : ('a : vec256). 'a -> 'a t
val get : ('a : vec256). 'a t -> 'a
val set : ('a : vec256). 'a t -> 'a -> unit

module O : sig
  val ( ! ) : ('a : vec256). 'a t -> 'a
  val ( := ) : ('a : vec256). 'a t -> 'a -> unit
end

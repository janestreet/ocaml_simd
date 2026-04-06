@@ portable

(** [_popcnt64]. *)
val count_set_bits : int64# -> int64#

module Raw = Load_store.Int64

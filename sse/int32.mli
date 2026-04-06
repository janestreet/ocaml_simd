@@ portable

(** [_popcnt32]. *)
val count_set_bits : int32# -> int32#

module Raw = Load_store.Int32

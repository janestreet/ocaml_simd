type ('a : vec256) t = { mutable contents : 'a }

let create contents = { contents }
let get t = t.contents
let set t v = t.contents <- v

module O = struct
  let ( ! ) = get
  let ( := ) = set
end

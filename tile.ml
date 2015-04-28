type tile = (bool * bool * bool * bool * int)

type dir = North | South | East | West

let get_n (a, _, _, _, _) = a
let get_s (_, a, _, _, _) = a
let get_e (_, _, a, _, _) = a
let get_w (_, _, _, a, _) = a
let get_id (_, _, _, _, a) = a
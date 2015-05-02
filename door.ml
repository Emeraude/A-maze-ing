type status = Opened | Closed
type door = { x: int; y: int; mutable st: status }

let is_opened = function
  | { st=Opened; _ } -> true
  | { st=Closed; _ } -> false

let open_door = function
  | { st=Opened; _ } -> raise (Invalid_argument "Door already opened")
  | { st=Closed; _ } -> Opened

let close_door = function
  | { st=Opened; _ } -> Closed
  | { st=Closed; _ } -> raise (Invalid_argument "Door already closed")

type door = Opened | Closed

let is_opened = function
  | Opened -> true
  | Closed -> false

let open_door = function
  | Opened -> raise (Invalid_argument "Door already opened")
  | Closed -> Opened

let close_door = function
  | Opened -> Closed
  | Closed -> raise (Invalid_argument "Door already closed")

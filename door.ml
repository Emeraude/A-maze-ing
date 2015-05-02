type door = Opened | Closed

let isOpened = function
  | Opened -> true
  | Closed -> false

let openDoor = function
  | Opened -> raise (Invalid_argument "Door already opened")
  | Closed -> Opened

let closeDoor = function
  | Opened -> Closed
  | Closed -> raise (Invalid_argument "Door already closed")

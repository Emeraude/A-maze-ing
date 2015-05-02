open Door

type tile = { mutable n: Door.door; mutable s: Door.door; mutable e: Door.door; mutable w: Door.door; mutable id: int }

type dir = North | South | East | West

let default = { n = Closed; s = Closed; e = Closed; w = Closed; id = 0 }

let new_tile i =
  { n = Closed; s = Closed; e = Closed; w = Closed; id = i }

let open_door tile = function
  | North -> tile.n <- (Door.open_door tile.n)
  | South -> tile.n <- (Door.open_door tile.n)
  | East  -> tile.n <- (Door.open_door tile.n)
  | West  -> tile.n <- (Door.open_door tile.n)

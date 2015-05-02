open Door

type tile = { mutable n: Door.door; mutable s: Door.door; mutable e: Door.door; mutable w: Door.door; mutable id: int }

type dir = North | South | East | West

let default = { n = Closed; s = Closed; e = Closed; w = Closed; id = 0 }

let new_tile i =
  { n = Closed; s = Closed; e = Closed; w = Closed; id = i }

let open_door tile = function
  | North -> tile.n <- Opened
  | South -> tile.s <- Opened
  | East  -> tile.e <- Opened
  | West  -> tile.w <- Opened

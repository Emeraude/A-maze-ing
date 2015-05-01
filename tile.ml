open Door

type tile = { mutable n: Door.door; mutable s: Door.door; mutable e: Door.door; mutable w: Door.door; mutable id: int }

let default = { n = Closed; s = Closed; e = Closed; w = Closed; id = 0 }

let new_tile i =
	{ n = Closed; s = Closed; e = Closed; w = Closed; id = i }

type dir = North | South | East | West

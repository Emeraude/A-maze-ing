type tile = { mutable n: bool; mutable s: bool; mutable e: bool; mutable w: bool; mutable id: int }

let default = { n = false; s = false; e = false; w = false; id = 0 }

let new_tile i =
	{ n = false; s = false; e = false; w = false; id = i }

type dir = North | South | East | West
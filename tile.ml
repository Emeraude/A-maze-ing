open Door

type tile = { mutable n: Door.door; mutable s: Door.door; mutable e: Door.door; mutable w: Door.door; mutable nw: Door.door; mutable se: Door.door; mutable id: int }

type dir = { x: int; y: int; name: string; }

let dirs_sq = [|
	{ x = 0; y = -1; name = "North" };
	{ x = 0; y = 1; name = "South" };
	{ x = 1; y = 0; name = "East" };
	{ x = -1; y = 0; name = "West" };
  |]

let dirs_hex_even = [|
	{ x = 0; y = -1; name = "North-East" };
	{ x = -1; y = 1; name = "South-West" };
	{ x = 1; y = 0; name = "East" };
	{ x = -1; y = 0; name = "West" };
	{ x = -1; y = -1; name = "North-West" };
	{ x = 0; y = 1; name = "South-East" };
  |]

let dirs_hex_odd = [|
	{ x = 1; y = -1; name = "North-East" };
	{ x = 0; y = 1; name = "South-West" };
	{ x = 1; y = 0; name = "East" };
	{ x = -1; y = 0; name = "West" };
	{ x = 0; y = -1; name = "North-West" };
	{ x = 1; y = 1; name = "South-East" };
  |]

let new_tile i = {
  n = { Door.x = 1; Door.y = -1; st = Closed };
  s = { Door.x = -1; Door.y = 1; st = Closed };
  e = { Door.x = 1; Door.y = 0; st = Closed };
  w = { Door.x = -1; Door.y = 0; st = Closed };
  nw = { Door.x = -1; Door.y = -1; st = Closed };
  se = { Door.x = 1; Door.y = 1; st = Closed };
  id = i;
}

let open_door tile = function
  | 0 -> tile.n.st <- Opened
  | 1 -> tile.s.st <- Opened
  | 2 -> tile.e.st <- Opened
  | 3 -> tile.w.st <- Opened
  | 4 -> tile.nw.st <- Opened
  | 5 -> tile.se.st <- Opened
  | _ -> assert false
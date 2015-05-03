open Door

type tile = { mutable doors: door array; mutable id: int }

type dir = { x: int; y: int; name: string; }

let dirs_sq = [|
	{ x = 0; y = -1; name = "North" };
	{ x = 0; y = 1; name = "South" };
	{ x = 1; y = 0; name = "East" };
	{ x = -1; y = 0; name = "West" };
  |]

let dirs_hex_odd = [|
	{ x = 0; y = -1; name = "North-East" };
	{ x = -1; y = 1; name = "South-West" };
	{ x = 1; y = 0; name = "East" };
	{ x = -1; y = 0; name = "West" };
	{ x = -1; y = -1; name = "North-West" };
	{ x = 0; y = 1; name = "South-East" };
  |]

let dirs_hex_even = [|
	{ x = 1; y = -1; name = "North-East" };
	{ x = 0; y = 1; name = "South-West" };
	{ x = 1; y = 0; name = "East" };
	{ x = -1; y = 0; name = "West" };
	{ x = 0; y = -1; name = "North-West" };
	{ x = 1; y = 1; name = "South-East" };
  |]

let new_tile i size = {
  doors = Array.make size Closed;
  id = i;
}

let open_door tile id =
  tile.doors.(id) <- Opened

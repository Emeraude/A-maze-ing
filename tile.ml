open Door

type tile = { mutable n: Door.door; mutable s: Door.door; mutable e: Door.door; mutable w: Door.door; mutable id: int }

type dir = North | South | East | West

let default = {
  n = { x = 0; y = -1; st = Closed };
  s = { x = 0; y = 1; st = Closed };
  e = { x = 1; y = 0; st = Closed };
  w = { x = -1; y = 0; st = Closed };
  id = 0;
}

let new_tile i = {
  n = { x = 0; y = -1; st = Closed };
  s = { x = 0; y = 1; st = Closed };
  e = { x = 1; y = 0; st = Closed };
  w = { x = -1; y = 0; st = Closed };
  id = i;
}

(*let new_tile_hex i = {
  nw = {};
  ne = {};
  e = {};
  se = {};
  sw = {};
  w = {};
}*)

let open_door tile = function
  | North -> tile.n.st <- Opened
  | South -> tile.s.st <- Opened
  | East  -> tile.e.st <- Opened
  | West  -> tile.w.st <- Opened

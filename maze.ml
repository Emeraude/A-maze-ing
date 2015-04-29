open Tile

let open_door maze i j w h = function
	| North -> if j > -1 then
		maze.(i + j * w).id <- w * h;
		maze.(i + j * w).n <- true
	| South -> if j < h then
		maze.(i + j * w).id <- w * h;
		maze.(i + j * w).s <- true
	| East	-> if i < w then
		maze.(i + j * w).id <- w * h;
		maze.(i + j * w).e <- true
	| West	-> if i > -1 then
		maze.(i + j * w).id <- w * h;
		maze.(i + j * w).w <- true

let open_door_neighbour maze i j w h = function
	| North ->	open_door (maze) (i) (j + 1) (w) (h) (South)
	| South ->	open_door (maze) (i) (j - 1) (w) (h) (North)
	| East	->	open_door (maze) (i + 1) (j) (w) (h) (West)
	| West	->	open_door (maze) (i - 1) (j) (w) (h) (East)

(* Check if door can be open (not already open & within the maze's bounds) *)

let open_random_door maze w h =
	let i = Random.int w
	and j = Random.int h
	and dir = Random.int 4 in
		match dir with
			| 0 -> if j = 0 then 0
						else if maze.(i + j * w).n <- true then 0
						else
						open_door maze i j w h North;
						open_door_neighbour maze i j w h North;
						1;
			| 1 -> if j = h - 1 then 0
						else if maze.(i + j * w).s <- true then 0
						else
						open_door maze i j w h South;
						open_door_neighbour maze i j w h South;
						1;
			| 2 -> if i = w - 1 then 0
						else if maze.(i + j * w).e <- true then 0
						else
						open_door maze i j w h East;
						open_door_neighbour maze i j w h East;
						1;
			| 3 -> if i = 0 then 0
						else if maze.(i + j * w).w <- true then 0
						else
						open_door maze i j w h West;
						open_door_neighbour maze i j w h West;
						1;

let generate_maze maze w h =
	let converted = 0 in
		while converted < w * h do
			converted = converted + (open_random_door maze w h)
		done

(* Puts a different colour on each tile of the maze *)

let initialize_maze maze w h =
	for i = 0 to w * h - 1 do
		maze.(i) <- Tile.new_tile i
	done

let create_maze w h =
	let maze = Array.make (w * h) Tile.default in
		initialize_maze maze w h;
		generate_maze maze w h

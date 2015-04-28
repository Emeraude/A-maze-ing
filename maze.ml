open Tile

let open_door maze i j w h = function
	| North -> if j > -1 then
		maze.(i + j * w) <- (true, get_s maze.(i + j * w),
		get_e maze.(i + j * w), get_w maze.(i + j * w), get_id maze.(i + j * w))
	| South -> if j < h then
		maze.(i + j * w) <- (get_n maze.(i + j * w), true,
		get_e maze.(i + j * w), get_w maze.(i + j * w), get_id maze.(i + j * w))
	| East	-> if i < w then
		maze.(i + j * w) <- (get_n maze.(i + j * w), get_s maze.(i + j * w),
		true, get_w maze.(i + j * w), get_id maze.(i + j * w))
	| West	-> if i > -1 then
		maze.(i + j * w) <- (get_n maze.(i + j * w), get_s maze.(i + j * w),
		get_e maze.(i + j * w), true, get_id maze.(i + j * w))

let open_door_neighbour maze i j w h = function
	| North ->	open_door (maze) (i) (j + 1) (w) (h) (South)
	| South ->	open_door (maze) (i) (j - 1) (w) (h) (North)
	| East	->	open_door (maze) (i + 1) (j) (w) (h) (West)
	| West	->	open_door (maze) (i - 1) (j) (w) (h) (East)

(* Puts a different colour on each tile of the maze *)

let initialize_maze maze w h =
	for i = 0 to w * h - 1 do
		maze.(i) <- (false, false, false, false, i)
	done

let create_maze w h =
	let maze = Array.make (w * h) (false, false, false, false, 0) in
	initialize_maze maze w h

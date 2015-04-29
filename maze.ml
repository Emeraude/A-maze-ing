open Tile

let open_door maze i j w h id = function
  | North -> if j > -1 then
      maze.(i + j * w).id <- id;
      maze.(i + j * w).n <- true
  | South -> if j < h then
      maze.(i + j * w).id <- id;
      maze.(i + j * w).s <- true
  | East	-> if i < w then
      maze.(i + j * w).id <- id;
      maze.(i + j * w).e <- true
  | West	-> if i > -1 then
      maze.(i + j * w).id <- id;
      maze.(i + j * w).w <- true

let open_door_neighbour maze i j w h id = function
  | North ->	open_door (maze) (i) (j - 1) (w) (h) (id) (South)
  | South ->	open_door (maze) (i) (j + 1) (w) (h) (id) (North)
  | East	->	open_door (maze) (i + 1) (j) (w) (h) (id) (West)
  | West	->	open_door (maze) (i - 1) (j) (w) (h) (id) (East)

(* Check if door can be open (within the maze's bounds) *)

let open_random_door maze w h =
	let i = Random.int w
	and j = Random.int h
	and dir = Random.int 4 in
  if maze.(i + j * w).id = h * w then 0
  else
  match dir with
    | 0 -> if j = 0 then 0
      else if maze.(i + j * w).id = maze.(i + j * w - w).id then 0
      else
      begin
        open_door maze i j w h maze.(i + j * w).id North;
        open_door_neighbour maze i j w h maze.(i + j * w).id North;
        1;
      end
    | 1 -> if j = h - 1 then 0
      else if maze.(i + j * w).id = maze.(i + j * w + w).id then 0
      else
      begin
        open_door maze i j w h maze.(i + j * w).id South;
        open_door_neighbour maze i j w h maze.(i + j * w).id South;
        1;
      end
    | 2 -> if i = w - 1 then 0
      else if maze.(i + j * w).id = maze.(i + 1 + j * w).id then 0
      else
      begin
        open_door maze i j w h maze.(i + j * w).id East;
        open_door_neighbour maze i j w h maze.(i + j * w).id East;
        1;
      end
    | 3 -> if i = 0 then 0
      else if maze.(i + j * w).id = maze.(i - 1 + j * w).id then 0
      else
      begin
        open_door maze i j w h maze.(i + j * w).id West;
        open_door_neighbour maze i j w h maze.(i + j * w).id West;
        1;
      end
    | _ -> 0

(* Converted represents the number of tiles converted *)

let generate_maze maze w h =
  let converted = ref 0
  and max = ref ((w * h) - 1) in
    while converted < max do
      if open_random_door maze w h = 1 then converted := !converted + 1;
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

open Tile

type maze = {
  tiles: Tile.tile array;
  width: int;
  height: int;
  form: int;
  dirs: int -> int -> Tile.dir array
}

let int_of_bool = function
  | true -> 1
  | false -> 0

let access maze i j =
  maze.tiles.(i + j * maze.width)

let rec contagion maze i j id1 id2 =
  if i >= 0 && j >= 0 && i < maze.width && j < maze.height && (access maze i j).id = id1
  then begin
      (access maze i j).id <- id2;
      let dirs = maze.dirs i j in
      Array.iter (fun d -> contagion maze (i + d.x) (j + d.y) id1 id2) dirs
    end

let open_dir_door maze dir id i j new_i new_j =
  Tile.open_door (access maze i j) id;
  Tile.open_door (access maze new_i new_j) dir;
  contagion maze new_i new_j (access maze new_i new_j).id (access maze i j).id;
  true

let open_random_door maze =
  let i = Random.int maze.width
  and j = Random.int maze.height in
  let id = Random.int (Array.length (maze.dirs i j)) in
  let dir = if id mod 2 = 0 then id + 1 else id - 1
  and dirs = maze.dirs i j in
  let new_i = i + dirs.(dir).x
  and new_j = j + dirs.(dir).y in
  if new_i < 0 || new_i >= maze.width || new_j < 0 || new_j >= maze.height
  || (access maze new_i new_j).id = (access maze i j).id
  then false
  else open_dir_door maze id dir i j new_i new_j

(* Converted represents the number of tiles converted *)

let rec generate_maze maze remaining = match remaining with
  | 0 -> maze
  | _ -> generate_maze maze (remaining - (int_of_bool (open_random_door maze )))

(* Puts a different colour on each tile of the maze *)

let initialize_maze w h f =
  Array.mapi (fun i a -> Tile.new_tile i (f * 2 + 4)) (Array.make(w * h) (Tile.new_tile 0 (f * 2 + 4)))

let create_maze w h f =
  Random.self_init ();
  let maze = {
    tiles = (initialize_maze w h f);
    width = w;
    height = h;
    form = f;
    dirs = if f = 0
      then fun _ _ -> Tile.dirs_sq
      else fun _ j -> if j mod 2 = 0
        then Tile.dirs_hex_even
        else Tile.dirs_hex_odd
  } in
  generate_maze maze (maze.width * maze.height - 1)

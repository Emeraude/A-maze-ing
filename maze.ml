open Tile

type maze = {
  tiles: Tile.tile array;
  width: int;
  height: int;
  form: int;
  dirs: int -> int -> Tile.dir array
}

let access maze i j =
  maze.tiles.(i + j * maze.width)

let rec contagion maze i j id1 id2 =
  if i >= 0 && j >= 0 && i < maze.width && j < maze.height && (access maze i j).id = id1
  then begin
      let dirs = maze.dirs i j in
      (access maze i j).id <- id2;
      for n = 0 to 3 + 2 * maze.form do
        contagion maze (i + dirs.(n).x) (j + dirs.(n).y) id1 id2
      done
    end

(*let open_door_neighbour maze i j id dirs =
  | North ->	Tile.open_door (access maze i (j - 1)) South;
    contagion maze i (j - 1) (access maze i (j - 1)).id (access maze i j).id
  | South ->	Tile.open_door (access maze i (j + 1)) North;
    contagion maze i (j + 1) (access maze i (j + 1)).id (access maze i j).id
  | East  ->	Tile.open_door (access maze (i + 1) j) West;
    contagion maze (i + 1) j (access maze (i + 1) j).id (access maze i j).id
  | West  ->	Tile.open_door (access maze (i - 1) j) East;
    contagion maze (i - 1) j (access maze (i - 1) j).id (access maze i j).id
  *)

(* IDs are coupled : North with South, East with West, etc. *)

let open_dir_door maze dir id i j new_i new_j =
  Tile.open_door (access maze i j) id;
  Tile.open_door (access maze new_i new_j) dir;
  contagion maze new_i new_j (access maze new_i new_j).id (access maze i j).id;
  true

(*let open_dir_door maze next cond dir i j =
  if cond || (access maze i j).id = (access maze (i + next) j).id then false
  else
    begin
      Tile.open_door (access maze i j) dir;
      open_door_neighbour maze i j (access maze i j).id dir;
      true;
    end *)

(* Check if door can be open (within the maze's bounds) *)

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
(*  match dir with
    | 0 -> open_dir_door maze (-maze.width) (j = 0) North i j
    | 1 -> open_dir_door maze maze.width (j = maze.height - 1) South i j
    | 2 -> open_dir_door maze 1 (i = maze.width - 1) East i j
    | 3 -> open_dir_door maze (-1) (i = 0) West i j
    | _ -> false
  *)

(* Converted represents the number of tiles converted *)

let generate_maze maze =
  let converted = ref 0
  and max = ref (maze.width * maze.height - 1) in
  while converted < max do
    if open_random_door maze then converted := !converted + 1
  done;
  maze

(* Puts a different colour on each tile of the maze *)

let initialize_maze w h f =
  Array.mapi (fun i a -> Tile.new_tile i) (Array.make(w * h) (Tile.new_tile 0))

let create_maze w h f =
  Random.self_init ();
  let maze = {
    tiles = (initialize_maze w h f);
    width = w;
    height = h;
    form = f;
    dirs = if f = 0
      then fun _ _ -> Tile.dirs_sq
      else fun i _ -> if i mod 2 = 0
        then Tile.dirs_hex_even
        else Tile.dirs_hex_odd
  } in
  generate_maze maze

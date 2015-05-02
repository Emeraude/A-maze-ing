open Tile

type maze = { tiles: Tile.tile array; width: int; height: int }

let int_of_bool = function
  | true -> 1
  | false -> 0

let access maze i j =
  maze.tiles.(i + j * maze.width)

let rec contagion maze i j id1 id2 =
  if i < 0 || j < 0 || i = maze.width || j = maze.height || (access maze i j).id != id1 then ()
  else
    begin
      (access maze i j).id <- id2;
      contagion maze (i - 1) j id1 id2;
      contagion maze (i + 1) j id1 id2;
      contagion maze i (j - 1) id1 id2;
      contagion maze i (j + 1) id1 id2
    end

let open_door_neighbour maze i j id = function
  | North ->	Tile.open_door (access maze i (j - 1)) South;
    contagion maze i (j - 1) (access maze i (j - 1)).id (access maze i j).id
  | South ->	Tile.open_door (access maze i (j + 1)) North;
    contagion maze i (j + 1) (access maze i (j + 1)).id (access maze i j).id
  | East  ->	Tile.open_door (access maze (i + 1) j) West;
    contagion maze (i + 1) j (access maze (i + 1) j).id (access maze i j).id
  | West  ->	Tile.open_door (access maze (i - 1) j) East;
    contagion maze (i - 1) j (access maze (i - 1) j).id (access maze i j).id

let open_dir_door maze next cond dir i j =
  if cond || (access maze i j).id = (access maze (i + next) j).id then false
  else
    begin
      Tile.open_door (access maze i j) dir;
      open_door_neighbour maze i j (access maze i j).id dir;
      true;
    end

(* Check if door can be open (within the maze's bounds) *)

let open_random_door maze =
  let i = Random.int maze.width
  and j = Random.int maze.height
  and dir = Random.int 4 in
  match dir with
    | 0 -> open_dir_door maze (-maze.width) (j = 0) North i j
    | 1 -> open_dir_door maze maze.width (j = maze.height - 1) South i j
    | 2 -> open_dir_door maze 1 (i = maze.width - 1) East i j
    | 3 -> open_dir_door maze (-1) (i = 0) West i j
    | _ -> false

(* Converted represents the number of tiles converted *)

let rec generate_maze maze remaining = match remaining with
  | 0 -> maze
  | _ -> generate_maze maze (remaining - (int_of_bool (open_random_door maze )))

(* Puts a different colour on each tile of the maze *)

let initialize_maze w h =
  Array.mapi (fun i a -> Tile.new_tile i) (Array.make(w * h) Tile.default)

let create_maze w h =
  Random.self_init ();
  generate_maze { tiles = (initialize_maze w h); width = w; height = h } (w * h - 1)

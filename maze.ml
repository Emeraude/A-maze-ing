open Tile

let rec contagion maze w h i j id1 id2 =
  if i < 0 || j < 0 || i = w || j = h || maze.(i + j * w).id != id1 then ()
  else
    begin
      maze.(i + j * w).id <- id2;
      contagion maze w h (i - 1) j id1 id2;
      contagion maze w h (i + 1) j id1 id2;
      contagion maze w h i (j - 1) id1 id2;
      contagion maze w h i (j + 1) id1 id2
    end

let open_door_neighbour maze i j w h id = function
  | North ->	Tile.open_door maze i (j - 1) w h South;
    contagion maze w h i (j - 1) (maze.(i + (j - 1) * w).id) (maze.(i + j * w).id)
  | South ->	Tile.open_door maze i (j + 1) w h North;
    contagion maze w h i (j + 1) (maze.(i + (j + 1) * w).id) (maze.(i + j * w).id)
  | East  ->	Tile.open_door (maze) (i + 1) (j) w h (West);
    contagion (maze) w h (i + 1) j (maze.(i + 1 + j * w).id) (maze.(i + j * w).id)
  | West  ->	Tile.open_door (maze) (i - 1) (j) w h (East);
    contagion (maze) w h (i - 1) j (maze.(i - 1 + j * w).id) (maze.(i + j * w).id)

let open_dir_door maze next cond dir w h i j =
  if cond || maze.(i + j * w).id = maze.(i + j * w + next).id then false
  else
    begin
      open_door maze i j w h dir;
      open_door_neighbour maze i j w h maze.(i + j * w).id dir;
      true;
    end

(* Check if door can be open (within the maze's bounds) *)

let open_random_door maze w h =
  let i = Random.int w
  and j = Random.int h
  and dir = Random.int 4 in
  match dir with
    | 0 -> open_dir_door maze (-w) (j = 0) North w h i j
    | 1 -> open_dir_door maze w (j = h - 1) South w h i j
    | 2 -> open_dir_door maze 1 (i = w - 1) East w h i j
    | 3 -> open_dir_door maze (-1) (i = 0) West w h i j
    | _ -> false

(* Converted represents the number of tiles converted *)

let generate_maze maze w h =
  let converted = ref 0
  and max = ref (w * h - 1) in
  while converted < max do
    if open_random_door maze w h then converted := !converted + 1;
  done;
  maze

(* Puts a different colour on each tile of the maze *)

let initialize_maze w h =
  Array.mapi (fun i a -> Tile.new_tile i) (Array.make(w * h) Tile.default)

let create_maze w h =
  Random.self_init ();
  generate_maze (initialize_maze w h) w h;

open Tile

let contagion maze w h id1 id2 =
  for i = 0 to w * h - 1 do
    if maze.(i).id = id1 then maze.(i).id <- id2
  done

let open_door maze i j w h = function
  | North -> maze.(i + j * w).n <- true
  | South -> maze.(i + j * w).s <- true
  | East	-> maze.(i + j * w).e <- true
  | West	-> maze.(i + j * w).w <- true

let open_door_neighbour maze i j w h id = function
  | North ->	open_door (maze) (i) (j - 1) (w) (h) (South);
              contagion (maze) (w) (h) (maze.(i + (j - 1) * w).id) (maze.(i + j * w).id)
  | South ->	open_door (maze) (i) (j + 1) (w) (h) (North);
              contagion (maze) (w) (h) (maze.(i + (j + 1) * w).id) (maze.(i + j * w).id)
  | East	->	open_door (maze) (i + 1) (j) (w) (h) (West);
              contagion (maze) (w) (h) (maze.(i + 1 + j * w).id) (maze.(i + j * w).id)
  | West	->	open_door (maze) (i - 1) (j) (w) (h) (East);
              contagion (maze) (w) (h) (maze.(i - 1 + j * w).id) (maze.(i + j * w).id)

(* Check if door can be open (within the maze's bounds) *)

let open_random_door maze w h =
	let i = Random.int w
	and j = Random.int h
	and dir = Random.int 4 in
  match dir with
    | 0 -> if j = 0 then false
      else if maze.(i + j * w).id = maze.(i + j * w - w).id then false
      else
      begin
        open_door maze i j w h North;
        open_door_neighbour maze i j w h maze.(i + j * w).id North;
        true;
      end
    | 1 -> if j = h - 1 then false
      else if maze.(i + j * w).id = maze.(i + j * w + w).id then false
      else
      begin
        open_door maze i j w h South;
        open_door_neighbour maze i j w h maze.(i + j * w).id South;
        true;
      end
    | 2 -> if i = w - 1 then false
      else if maze.(i + j * w).id = maze.(i + 1 + j * w).id then false
      else
      begin
        open_door maze i j w h East;
        open_door_neighbour maze i j w h maze.(i + j * w).id East;
        true;
      end
    | 3 -> if i = 0 then false
      else if maze.(i + j * w).id = maze.(i - 1 + j * w).id then false
      else
      begin
        open_door maze i j w h West;
        open_door_neighbour maze i j w h maze.(i + j * w).id West;
        true;
      end
    | _ -> false

let print_maze maze w h =
  for i = 0 to h - 1 do
    for j = 0 to w - 1 do
      match maze.(j + i * w).e with
        | false -> Printf.printf " |"
        | true  -> Printf.printf "  "
    done;
    Printf.printf "\n";
    for j = 0 to w - 1 do
      match maze.(j + i * w).s with
        | false -> Printf.printf "--"
        | true  -> Printf.printf " -"
    done;
    Printf.printf "\n";
  done

let print_numbers maze w h =
  for i = 0 to h - 1 do
    for j = 0 to w - 1 do
      Printf.printf "%d " maze.(j + i * w).id
    done;
    Printf.printf "\n";
  done

(* Converted represents the number of tiles converted *)

let generate_maze maze w h =
  let converted = ref 0
  and max = ref (w * h - 1) in
    while converted < max do
      if open_random_door maze w h then converted := !converted + 1;
    done

(* Puts a different colour on each tile of the maze *)

let initialize_maze maze w h =
  for i = 0 to w * h - 1 do
    maze.(i) <- Tile.new_tile i
  done

let create_maze w h =
	let maze = Array.make (w * h) Tile.default in
    initialize_maze maze w h;
    generate_maze maze w h;
    print_maze maze w h

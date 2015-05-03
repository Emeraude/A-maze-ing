open Tile
open Maze

exception Found of int list

(* On met les id à -1 si on est sur le chemin vers l'arrivée *)

let rec solve maze curr last finish =
  if curr < 0 || curr >= maze.width * maze.height || last < 0 || last >= maze.width * maze.height then raise Not_found
  else if curr = finish then begin
    maze.tiles.(curr).id <- -1;
    [];
  end
  else let i = curr mod maze.width
  and j = curr / maze.width in
  let dirs = maze.dirs i j in
    try Array.iteri
      begin fun n d ->
        let next = (i + dirs.(n).x + (j + dirs.(n).y) * maze.width) in
        if   Door.is_opened d && next != last
    	then try let path = solve maze next curr finish in
    	raise (Found (next::path))
	    with Not_found -> ()
      end
      (access maze i j).doors;
    raise Not_found
  with Found path ->
    maze.tiles.(curr).id <- -1;
    path
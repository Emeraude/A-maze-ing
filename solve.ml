open Tile
open Maze

exception Found

(* On met les id à -1 si on est sur le chemin vers l'arrivée *)

let rec solve maze curr last finish =
  if curr < 0 || curr >= maze.width * maze.height || last < 0 || last >= maze.width * maze.height then false
  else if curr = finish then begin
    maze.tiles.(curr).id <- -1;
    true;
  end
  else let i = curr mod maze.width
  and j = curr / maze.width in
  let dirs = maze.dirs i j in
    try Array.iteri
      begin fun n d ->
        let next = (i + dirs.(n).x + (j + dirs.(n).y) * maze.width) in
        if   Door.is_opened d && next != last
    	  && solve maze next curr finish
    	then raise Found
      end
      (access maze i j).doors;
    false
  with Found ->
    maze.tiles.(curr).id <- -1;
    true
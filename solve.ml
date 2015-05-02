open Tile
open Maze

(* On met les id à -1 si on est sur le chemin vers l'arrivée *)

let rec solve maze curr last finish =
  if curr < 0 || curr >= maze.width * maze.height || last < 0 || last >= maze.width * maze.height then false
  else if curr = finish then begin
    maze.tiles.(curr).id <- -1;
    true;
  end
  else if (Door.isOpened maze.tiles.(curr).n && curr - maze.width != last
	  && solve maze (curr - maze.width) curr finish)
      || (Door.isOpened maze.tiles.(curr).s && curr + maze.width != last
	 && solve maze (curr + maze.width) curr finish)
      || (Door.isOpened maze.tiles.(curr).e && curr + 1 != last
	 && solve maze (curr + 1) curr finish)
      || (Door.isOpened maze.tiles.(curr).w && curr - 1 != last
	 && solve maze (curr - 1) curr finish)
  then begin
    maze.tiles.(curr).id <- -1;
    true;
  end
  else false

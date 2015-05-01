open Tile

(* On met les id à -1 si on est sur le chemin vers l'arrivée *)

let rec solve maze curr last finish w h =
	if curr < 0 || curr >= w * h || last < 0 || last >= w * h then false
	else if curr = finish then begin
		maze.(curr).id <- -1;
		true;
	end
	else if (maze.(curr).n && curr - w != last
			&& solve maze (curr - w) curr finish w h)
			|| (maze.(curr).s && curr + w != last
			&& solve maze (curr + w) curr finish w h)
			|| (maze.(curr).e && curr + 1 != last
			&& solve maze (curr + 1) curr finish w h)
			|| (maze.(curr).w && curr - 1 != last
			&& solve maze (curr - 1) curr finish w h)
	then begin
		maze.(curr).id <- -1;
		true;
	end
	else false
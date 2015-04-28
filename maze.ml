(* Puts a different colour on each tile of the maze *)

(*let rec initialize_maze maze i j w h =
  if i = w - 1 then initialize_maze ((false, false, false, false, i + j * w)::maze) 0 (j + 1) w h
	else if (i = w - 1) && (j = h - 1) then maze
	else initialize_maze ((false, false, false, false, i + j * w)::maze) (i + 1) j w h *)

let initialize_maze maze w h =
	for i = 0 to w * h - 1 do
		maze.(i) <- (false, false, false, false, i)
	done

let create_maze w h =
	let maze = Array.make (w * h) (false, false, false, false, 0) in
	let test = initialize_maze maze w h in
	if maze.(2) = (false, false, false, false, 2) then Printf.printf "success\n"
	else Printf.printf "fail\n"

(* Puts a different colour on each tile of the maze *)

let rec initialize_maze maze i j w h =
	if i = w - 1 then create_maze ((false, false, false, false, i + j * w)::maze) 0 (j + 1) w h
	else if (i = w - 1) && (j = h - 1) then maze
	else create_maze ((false, false, false, false, i + j * w)::maze) (i + 1) j w h

let rec create_maze maze i j w h =
	let maze = Maze.create_maze [] 0 0 width height in
	match maze with
		| [] -> ()
		| _ -> ()
let usage_msg = "Usage: step3 [width] [height]"

let _ =
	try
		let width = int_of_string Sys.argv.(1)
		and height = int_of_string Sys.argv.(2)
	in if width > 6 && height > 6 && width < 250 && height < 250
	  then let maze = Maze.create_maze width height in
	  		ignore(Solve.solve maze 0 0 (width * height - 1) width height);
	    	Draw.draw_maze maze width height
	else raise (Invalid_argument "wrong input")
	with
		| Invalid_argument ("index out of bounds") -> Printf.eprintf "%s\n" usage_msg
		| Invalid_argument ("wrong input") -> Printf.eprintf "width and height must be positive and less than 250\n"

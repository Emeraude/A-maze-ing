let usage_msg = "Usage: step1 [width] [height]"

let _ =
	try
		let width = int_of_string Sys.argv.(1)
		and height = int_of_string Sys.argv.(2)
	in if width > 1 && height > 1 && width < 1000 && height < 1000
	  then let maze = Maze.create_maze width height in
	  	Maze.print_maze maze width height
	else raise (Invalid_argument "wrong input")
	with
		| Failure ("int_of_string") -> Printf.eprintf "%s\n" usage_msg
		| Invalid_argument ("index out of bounds") -> Printf.eprintf "%s\n" usage_msg
		| Invalid_argument ("wrong input") -> Printf.eprintf "width and height must be positive and less than 1000\n"

let usage_msg = "Usage: step4 [width] [height] [--square | --hexagonal]"

let _ =
  try
    let width = int_of_string Sys.argv.(1)
    and height = int_of_string Sys.argv.(2)
    and form = Sys.argv.(3) in
    if String.compare form "--square" = 0
    && width > 6 && height > 6 && width < 250 && height < 250
    then let maze = Maze.create_maze width height 0 in
	 ignore(Solve.solve maze 0 0 (width * height - 1));
	 Draw.draw_maze maze
    else if String.compare form "--hexagonal" = 0
    && width > 6 && height > 6 && width < 250 && height < 250
    then let maze = Maze.create_maze width height 1 in
   ignore(Solve.solve maze 0 0 (width * height - 1));
   Draw_hex.draw_maze maze
    else raise (Invalid_argument "wrong input")
  with
    | Invalid_argument ("index out of bounds") -> Printf.eprintf "%s\n" usage_msg
    | Invalid_argument ("wrong input") -> Printf.eprintf "width and height must be positive and less than 250.\nForm must be hexagonal or square\n"

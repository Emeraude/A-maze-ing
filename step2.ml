let usage_msg = "Usage: step1 [width] [height]"

let _ =
  try
    let width = int_of_string Sys.argv.(1)
    and height = int_of_string Sys.argv.(2) in
    if width > 6 && height > 6 && width < 250 && height < 250
    then Draw.draw_maze (Maze.create_maze width height 0) false
    else raise (Invalid_argument "wrong input")
  with
    | Failure ("int_of_string") -> Printf.eprintf "%s\n" usage_msg
    | Invalid_argument ("index out of bounds") -> Printf.eprintf "%s\n" usage_msg
    | Invalid_argument ("wrong input") -> Printf.eprintf "width and height must be more than 6 and less than 250\n"
    | Sdl.SDL_init_exception (s)
    | Sdlvideo.Video_exn (s)
    | Sdlloader.SDLloader_exception (s) -> Printf.eprintf "SDL error: %s\n" s

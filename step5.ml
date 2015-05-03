let usage_msg = "Usage: step5 [width] [height] [theme]"

let _ =
  try
    let width = int_of_string Sys.argv.(1)
    and height = int_of_string Sys.argv.(2) in
    if width > 6 && height > 6 && width < 250 && height < 250
    then
      if Array.length Sys.argv > 3
      then
	Game.launch width height 3 Sys.argv.(3)
      else
	Game.launch width height 3 "nazi"
    else raise (Invalid_argument "wrong input")
  with
    | Invalid_argument ("index out of bounds") -> Printf.eprintf "%s\n" usage_msg
    | Invalid_argument ("wrong input") -> Printf.eprintf "width and height must be more than 6 and less than 250\n"
    | Sdl.SDL_init_exception (s)
    | Sdlvideo.Video_exn (s)
    | Sdlloader.SDLloader_exception (s)
    | Sdlmixer.SDLmixer_exception (s) -> Printf.eprintf "SDL error: %s\n" s

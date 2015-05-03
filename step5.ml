let usage_msg = "Usage: step5 [width] [height]"

let _ =
  try
    let width = int_of_string Sys.argv.(1)
    and height = int_of_string Sys.argv.(2) in
    if width > 6 && height > 6 && width < 250 && height < 250
    then Game.launch width height 3
    else raise (Invalid_argument "wrong input")
  with
    | Invalid_argument ("index out of bounds") -> Printf.eprintf "%s\n" usage_msg
    | Invalid_argument ("wrong input") -> Printf.eprintf "width and height must be positive and less than 250\n"

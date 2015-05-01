open Door
open Tile

let rec print_top w = match w with
  | 0 -> ()
  | _ -> Printf.printf "----"; print_top (w - 1)

let rec print_first_line maze w i j = match w - j with
  | 0 -> ()
  | _ -> match maze.(i * w + j).e with
      | Closed -> Printf.printf "   |"; print_first_line maze w i (j + 1)
      | Opened -> Printf.printf "    "; print_first_line maze w i (j + 1)

let rec print_second_line maze w i j = match w - j with
  | 0 -> ()
  | _ -> match maze.(i * w + j).s with
      | Closed -> Printf.printf "----"; print_second_line maze w i (j + 1)
      | Opened -> Printf.printf "   -"; print_second_line maze w i (j + 1)

let rec print_line maze w h i = match h - i with
  | 0 -> ()
  | _ -> Printf.printf "|"; print_first_line maze w i 0;
    Printf.printf "\n|";
    print_second_line maze w i 0;
    Printf.printf "\n";
    print_line maze w h (i + 1)

let print maze w h =
  print_top w;
  Printf.printf "-\n";
  print_line maze w h 0;

open Door
open Tile
open Maze

let rec print_top w = match w with
  | 0 -> ()
  | _ -> Printf.printf "----"; print_top (w - 1)

let rec print_first_line maze i j = match maze.width - j with
  | 0 -> ()
  | _ -> match (Maze.access maze j i).e.st with
      | Closed -> Printf.printf "   |"; print_first_line maze i (j + 1)
      | Opened -> Printf.printf "    "; print_first_line maze i (j + 1)

let rec print_second_line maze i j = match maze.width - j with
  | 0 -> ()
  | _ -> match (Maze.access maze j i).s.st with
      | Closed -> Printf.printf "----"; print_second_line maze i (j + 1)
      | Opened -> Printf.printf "   -"; print_second_line maze i (j + 1)

let rec print_line maze i = match maze.height - i with
  | 0 -> ()
  | _ -> Printf.printf "|"; print_first_line maze i 0;
    Printf.printf "\n|";
    print_second_line maze i 0;
    Printf.printf "\n";
    print_line maze (i + 1)

let print maze =
  print_top maze.width;
  Printf.printf "-\n";
  print_line maze 0;

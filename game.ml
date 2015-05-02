open Maze

type game = {nazis: int * int list;
	     juif: int * int;
	     camp: int * int;
	     pieces: int * int list;
	     teleporters: int * int list}

let int_sqrt n =
  int_of_float (sqrt (float_of_int n))

let create_nazis maze =
  let rec _create_nazis list n = match n with
    | 0 -> []
    | _ -> _create_nazis ((0, 0)::list) (n - 1)
  in _create_nazis [] ((int_sqrt (maze.height * maze.width)) / 10 + 1)


(* let init_game maze = *)
  

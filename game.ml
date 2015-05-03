open Maze

type game = {nazis: (int * int) list;
	     jew: int * int;
	     camp: int * int;
	     pieces: (int * int) list;
	     teleporters: (int * int) list}

let int_sqrt n =
  int_of_float (sqrt (float_of_int n))

let random_pos maze =
  (Random.int maze.width, Random.int maze.height)

let create_nazis maze =
  let rec _create_nazis n = match n with
    | 0 -> []
    | _ -> (random_pos maze)::(_create_nazis (n - 1))
  in _create_nazis ((int_sqrt (maze.height * maze.width)) / 10 + 1)

let create_jew maze =
  random_pos maze

let create_camp maze =
  random_pos maze

let create_teleporters maze =
  let rec _create_teleporters n = match n with
    | 0 -> []
    | _ -> (random_pos maze)::(_create_teleporters (n - 1))
  in _create_teleporters ((int_sqrt (maze.height * maze.width)) / 15 + 1)

let init_game maze =
  {nazis = create_nazis maze;
   jew = create_jew maze;
   camp = create_camp maze;
   pieces = [];
   teleporters = create_teleporters maze}

let launch maze =
  ()

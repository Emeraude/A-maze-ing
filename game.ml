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

let jew_move game pos =
  {nazis = game.nazis;
   jew = pos;
   camp = game.camp;
   pieces = game.pieces;
   teleporters = game.teleporters}

let take_teleporter game =
  let other_tp = (List.filter (fun a -> a != game.jew) game.teleporters) in
  jew_move game (List.nth other_tp (Random.int (List.length other_tp)))

let jew_is_alive game = match List.filter (fun a -> a = game.jew) game.nazis with
  | [] -> true
  | _ -> false

let end_is_reached game =
  game.jew = game.camp

let events = function
    | Sdlevent.QUIT ->                                                  Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE; _} ->        Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_q; _} ->             Sdl.quit ()
    | _ ->								()

let rec get_events () =
  match Sdlevent.poll () with
    | None -> ()
    | Some ev -> events ev; get_events ()

let rec new_level screen width height = function
  | 0 -> ()
  | lvl -> begin
    let maze = Maze.create_maze width height 0 in
    ignore (init_game maze);
    Printf.printf "level %d\n" lvl;
    new_level screen width height (lvl - 1)
  end

let launch width height lvl =
  begin
    Sdl.init [`VIDEO];
    at_exit Sdl.quit;
    let multiplier = Draw.get_multiplier width height in
    let screen = Sdlvideo.set_video_mode (width * multiplier) (height * multiplier) [`HWSURFACE] in
    Sdlvideo.fill_rect screen (Sdlvideo.map_RGB screen Sdlvideo.white);
    new_level screen width height lvl
  end

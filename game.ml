open Maze

type game = {nazis: (int * int) list;
	     jew: int * int;
	     camp: int * int;
	     pieces: (int * int) list;
	     teleporters: (int * int) list}

let images = [|
  Sdlloader.load_image "./images/camp.png";
  Sdlloader.load_image "./images/coin.png";
  Sdlloader.load_image "./images/jew.png";
  Sdlloader.load_image "./images/nazi.png";
  Sdlloader.load_image "./images/tp.png";
	     |]

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
  in _create_teleporters ((int_sqrt (maze.height * maze.width)) / 5 + 2)

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

let events game = function
    | Sdlevent.QUIT ->							exit 0
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE; _} ->	exit 0
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_q; _} ->		exit 0
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_LEFT; _} ->		print_endline "left"
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_UP; _} ->		print_endline "up"
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_DOWN; _} ->		print_endline "down"
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_RIGHT; _} ->		print_endline "right"
    | _ ->								()

let rec get_events game =
  match Sdlevent.poll () with
    | None -> ()
    | Some ev -> events game ev; get_events game

let put_sprite screen maze img (x, y) =
  Sdlvideo.blit_surface ~dst_rect:(Sdlvideo.rect(x * 40) (y * 40) 40 40) ~src:img ~dst:screen ()

let draw_teleporters screen maze game =
  List.iter (fun a -> put_sprite screen maze (Sdlloader.load_image "./images/tp.png") a) game.teleporters

let draw_nazis screen maze game =
  List.iter (fun a -> put_sprite screen maze (Sdlloader.load_image "./images/nazi.png") a) game.nazis

let draw_pieces screen maze game =
  List.iter (fun a -> put_sprite screen maze (Sdlloader.load_image "./images/coin.png") a) game.pieces

let draw_jew screen maze game =
  put_sprite screen maze (Sdlloader.load_image "./images/jew.png") game.jew

let draw_camp screen maze game =
  put_sprite screen maze (Sdlloader.load_image "./images/camp.png") game.camp

let draw_sprites screen maze game =
  begin
    draw_pieces screen maze game;
    draw_teleporters screen maze game;
    draw_nazis screen maze game;
    draw_camp screen maze game;
    draw_jew screen maze game
  end

let rec game_loop screen maze game =
  begin
    get_events ();
    Sdltimer.delay 50;
    (* faire bouger les nazis *)
    (* faire apparaitre les pieces *)
    Draw.draw_maze_tiles screen maze false;
    draw_sprites screen maze game;
    Sdlvideo.flip screen;
    if jew_is_alive game && end_is_reached game = false
    then
      game_loop screen maze game
  end

let rec new_level screen width height = function
  | 0 -> ()
  | lvl -> begin
    let maze = Maze.create_maze width height 0 in
    game_loop screen maze (init_game maze);
    new_level screen width height (lvl - 1)
  end

let launch width height lvl =
  begin
    Sdl.init [`VIDEO];
    at_exit Sdl.quit;
    let multiplier = Draw.get_multiplier width height in
    let screen = Sdlvideo.set_video_mode (width * multiplier) (height * multiplier) [`HWSURFACE] in
    Sdlvideo.fill_rect screen (Sdlvideo.map_RGB screen Sdlvideo.black);
    new_level screen width height lvl
  end

open Maze
open Tile

type game = {nazis: (int * int) list;
	     jew: int * int;
	     camp: int * int;
	     pieces: (int * int) list;
	     teleporters: (int * int) list;
	     score: int}

let images = [|
  Sdlloader.load_image "./images/camp.png";
  Sdlloader.load_image "./images/coin.png";
  Sdlloader.load_image "./images/jew.png";
  Sdlloader.load_image "./images/nazi.png";
  Sdlloader.load_image "./images/tp.png";
	     |]

let music_filename = "audio/nazi_audio.ogg"

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

let init_game maze score =
  {nazis = create_nazis maze;
   jew = create_jew maze;
   camp = create_camp maze;
   pieces = [];
   teleporters = create_teleporters maze;
   score = score}

let increase_score game nb =
  {nazis = game.nazis;
   jew = game.jew;
   camp = game.camp;
   pieces = game.pieces;
   teleporters = game.teleporters;
   score = game.score + nb}

let jew_move game pos =
  {nazis = game.nazis;
   jew = pos;
   camp = game.camp;
   pieces = game.pieces;
   teleporters = game.teleporters;
   score = game.score}

let move_right maze game = match game.jew with
  | (x, y) -> if Door.is_opened (Maze.access maze x y).doors.(2) then jew_move game (x + 1, y) else game

let move_left maze game = match game.jew with
  | (x, y) -> if Door.is_opened (Maze.access maze x y).doors.(3) then jew_move game (x - 1, y) else game

let move_up maze game = match game.jew with
  | (x, y) -> if Door.is_opened (Maze.access maze x y).doors.(0) then jew_move game (x, y - 1) else game

let move_down maze game = match game.jew with
  | (x, y) -> if Door.is_opened (Maze.access maze x y).doors.(1) then jew_move game (x, y + 1) else game

let take_teleporter game =
  let other_tp = (List.filter (fun a -> a != game.jew) game.teleporters) in
  jew_move game (List.nth other_tp (Random.int (List.length other_tp)))

let check_tp game = match List.filter (fun a -> a = game.jew) game.teleporters with
  | [] -> game
  | _ -> take_teleporter game

let check_coin game = match List.filter (fun a -> a = game.jew) game.pieces with
  | [] -> game
  | pos -> print_endline "Cling cling ! +10"; {nazis = game.nazis;
						jew = game.jew;
						camp = game.camp;
						pieces = List.filter (fun a -> a != List.hd pos) game.pieces;
						teleporters = game.teleporters;
						score = game.score + 10}

let jew_is_alive game = match List.filter (fun a -> a = game.jew) game.nazis with
  | [] -> true
  | _ -> false

let end_is_reached game =
  game.jew = game.camp

let events maze game = function
    | Sdlevent.QUIT ->							exit 0
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE; _} ->	exit 0
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_q; _} ->		exit 0
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_RIGHT; _} ->		check_coin (check_tp (move_right maze game))
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_UP; _} ->		check_coin (check_tp (move_up maze game))
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_DOWN; _} ->		check_coin (check_tp (move_down maze game))
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_LEFT; _} ->		check_coin (check_tp (move_left maze game))
    | _ ->								game

let rec get_events maze game =
  match Sdlevent.poll () with
    | None -> game
    | Some ev -> get_events maze (events maze game ev)

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

let two_to_one_pos maze = function
  | (x, y) -> y * maze.width + x

let one_to_two_pos maze = function
  | x -> (x mod maze.width, x / maze.width)

let move_nazis maze game t = try match t mod 7 with
  | 0 -> {nazis = List.map (fun a -> one_to_two_pos maze (List.hd (Solve.solve maze (two_to_one_pos maze a) (two_to_one_pos maze a) (two_to_one_pos maze game.jew)))) game.nazis;
	  jew = game.jew;
	  camp = game.camp;
	  pieces = game.pieces;
	  teleporters = game.teleporters;
	  score = game.score}
  | _ -> game
  with Failure ("hd") -> game

let add_pieces maze game t = match t mod 16 with
  | 0 -> {nazis = game.nazis;
	  jew = game.jew;
	  camp = game.camp;
	  pieces = (random_pos maze)::game.pieces;
	  teleporters = game.teleporters;
	  score = game.score}
  | _ -> game

let rec game_loop screen maze game t =
  begin
    let game = get_events maze game in
    Sdltimer.delay 50;
    let game = add_pieces maze (move_nazis maze game t) t in
    Draw.draw_maze_tiles screen maze false;
    draw_sprites screen maze game;
    if Sdlmixer.playing_music ();
       then
	 ();
    Sdlvideo.flip screen;
    if jew_is_alive game && end_is_reached game = false
    then
      game_loop screen maze game (t + 1)
    else
      match jew_is_alive game && end_is_reached game with
	| true -> print_endline "Welcome at home ! +200"; true
	| false -> false
  end

let rec new_level screen width height = function
  | 0 -> ()
  | lvl -> begin
    let maze = Maze.create_maze width height 0 in
    let game = init_game maze (3 - lvl * 200) in
    if game_loop screen maze game 0 then
      new_level screen width height (lvl - 1)
  end

let launch width height lvl =
  begin
    Sdl.init [`VIDEO; `AUDIO];
    at_exit Sdl.quit;
    Audio.open_audio ();
    let multiplier = Draw.get_multiplier width height in
    let screen = Sdlvideo.set_video_mode (width * multiplier) (height * multiplier) [`HWSURFACE] in
    Sdlvideo.fill_rect screen (Sdlvideo.map_RGB screen Sdlvideo.black);
    let music = Audio.play_music music_filename in
    new_level screen width height lvl;
    Audio.close_music music;
  end

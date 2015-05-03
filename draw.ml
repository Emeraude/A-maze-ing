open Door
open Tile
open Maze

let preloaded_images = [|
  Sdlloader.load_image "./images/00.png";
  Sdlloader.load_image "./images/01.png";
  Sdlloader.load_image "./images/10.png";
  Sdlloader.load_image "./images/11.png";
  Sdlloader.load_image "./images/path.png";
		       |]

let draw_tile screen maze i j =
  let img_id =
    match (Maze.access maze j i).doors.(0), (Maze.access maze j i).doors.(3) with
      | Opened, Opened -> 0
      | Opened, Closed -> 1
      | Closed, Opened -> 2
      | Closed, Closed -> 3 in
  let img = preloaded_images.(img_id)
  and img_pos = Sdlvideo.rect (j * 40) (i * 40) 40 40 in
  Sdlvideo.blit_surface ~dst_rect:img_pos ~src:img ~dst:screen ();
  if (Maze.access maze j i).id = -1 then begin
    let img_path = preloaded_images.(4)
    and img_path_pos = Sdlvideo.rect (j * 40 + 4) (i * 40 + 4) 32 32 in
    Sdlvideo.blit_surface ~dst_rect:img_path_pos ~src:img_path ~dst:screen();
  end

let rec wait_for_escape () =
  match Sdlevent.wait_event () with
    | Sdlevent.QUIT ->							Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE; _} ->	Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_q; _} ->		Sdl.quit ()
    | _ ->								wait_for_escape ()

let draw_maze_tiles maze screen =
  for i = 0 to maze.height - 1 do
    for j = 0 to maze.width - 1 do
      draw_tile screen maze i j
    done
  done

let get_multiplier a b = 40

let draw_maze maze =
  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
  let screen = Sdlvideo.set_video_mode (maze.width * 40) (maze.height * 40) [`HWSURFACE] in
  let colour = Sdlvideo.map_RGB screen Sdlvideo.black in
  Sdlvideo.fill_rect screen colour;
  draw_maze_tiles maze screen;
  Sdlvideo.flip screen;
  wait_for_escape ()

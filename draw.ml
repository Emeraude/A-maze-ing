open Door
open Tile
open Maze

let preloaded_images = [|
  Sdlloader.load_image "./images/0001.png";
  Sdlloader.load_image "./images/0010.png";
  Sdlloader.load_image "./images/1000.png";
  Sdlloader.load_image "./images/1001.png";
  Sdlloader.load_image "./images/path.png";
		       |]

let draw_tile screen maze i j multiplier =
  let img_id =
    match (Maze.access maze j i).doors.(0), (Maze.access maze j i).doors.(3) with
      | Opened, Closed -> 0
      | Opened, Opened -> 1
      | Closed, Opened -> 2
      | Closed, Closed -> 3 in
  let img = preloaded_images.(img_id)
  and img_pos = Sdlvideo.rect (j * multiplier) (i * multiplier) multiplier multiplier in
  Sdlvideo.blit_surface ~dst_rect:img_pos ~src:img ~dst:screen ();
  if (Maze.access maze j i).id = -1 then begin
    let img_path = preloaded_images.(4)
    and img_path_pos = Sdlvideo.rect (j * multiplier + (2 * multiplier) / 5) (i * multiplier + (2 * multiplier) / 5) (multiplier / 4) (multiplier / 4) in
    Sdlvideo.blit_surface ~dst_rect:img_path_pos ~src:img_path ~dst:screen();
  end

let rec wait_for_escape () =
  match Sdlevent.wait_event () with
    | Sdlevent.QUIT ->							Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE; _} ->	Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_q; _} ->		Sdl.quit ()
    | _ ->								wait_for_escape ()

let draw_maze maze =
  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
  let multiplier = if maze.width > maze.height then (900 / maze.width) else (900 / maze.height) in
  let screen = Sdlvideo.set_video_mode (maze.width * multiplier) (maze.height * multiplier) [`HWSURFACE] in
  let colour = Sdlvideo.map_RGB screen Sdlvideo.white in
  Sdlvideo.fill_rect screen colour;
  for i = 0 to maze.height - 1 do
    for j = 0 to maze.width - 1 do
      draw_tile screen maze i j multiplier
    done
  done;
  Sdlvideo.flip screen;
  wait_for_escape ()

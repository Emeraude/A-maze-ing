open Door
open Tile
open Maze

let preloaded_images = [|
  Sdlloader.load_image "./images/000.png";
  Sdlloader.load_image "./images/001.png";
  Sdlloader.load_image "./images/010.png";
  Sdlloader.load_image "./images/011.png";
  Sdlloader.load_image "./images/100.png";
  Sdlloader.load_image "./images/101.png";
  Sdlloader.load_image "./images/110.png";
  Sdlloader.load_image "./images/111.png";
  Sdlloader.load_image "./images/path_hex.png";
           |]

let draw_tile screen maze i j =
  let img_id =
    match (Maze.access maze j i).doors.(3),
          (Maze.access maze j i).doors.(4),
          (Maze.access maze j i).doors.(0) with
      | Opened, Opened, Opened -> 0
      | Opened, Opened, Closed -> 1
      | Opened, Closed, Opened -> 2
      | Opened, Closed, Closed -> 3
      | Closed, Opened, Opened -> 4
      | Closed, Opened, Closed -> 5
      | Closed, Closed, Opened -> 6
      | Closed, Closed, Closed -> 7 in
  let img = preloaded_images.(img_id)
  and multiplier = if i mod 2 = 0 then 16 else 0 in
  let img_pos = Sdlvideo.rect (j * 32 + multiplier) (i * 28) 32 36 in
    Sdlvideo.blit_surface ~dst_rect:img_pos ~src:img ~dst:screen ();
  if (Maze.access maze j i).id = -1 then begin
    let img_path = preloaded_images.(8)
    and img_path_pos = Sdlvideo.rect (j * 32 + multiplier) (i * 28) 16 16 in
    Sdlvideo.blit_surface ~dst_rect:img_path_pos ~src:img_path ~dst:screen();
  end

let rec wait_for_escape () =
  match Sdlevent.wait_event () with
    | Sdlevent.QUIT ->              Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE; _} ->  Sdl.quit ()
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_q; _} ->   Sdl.quit ()
    | _ ->                wait_for_escape ()

let draw_maze maze =
  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
  let screen = Sdlvideo.set_video_mode (maze.width * 32 + 16) (maze.height * 30) [`HWSURFACE] in
  let colour = Sdlvideo.map_RGB screen Sdlvideo.white in
  Sdlvideo.fill_rect screen colour;
  for i = 0 to maze.height - 1 do
    for j = 0 to maze.width - 1 do
      draw_tile screen maze i j
    done
  done;
  Sdlvideo.flip screen;
  wait_for_escape ()

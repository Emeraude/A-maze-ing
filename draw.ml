open Door
open Tile

let preloaded_images = [|
    Sdlloader.load_image "./images/0001.png";
    Sdlloader.load_image "./images/0010.png";
    Sdlloader.load_image "./images/0011.png";
    Sdlloader.load_image "./images/0100.png";
    Sdlloader.load_image "./images/0101.png";
    Sdlloader.load_image "./images/0110.png";
    Sdlloader.load_image "./images/0111.png";
    Sdlloader.load_image "./images/1000.png";
    Sdlloader.load_image "./images/1001.png";
    Sdlloader.load_image "./images/1010.png";
    Sdlloader.load_image "./images/1011.png";
    Sdlloader.load_image "./images/1100.png";
    Sdlloader.load_image "./images/1101.png";
    Sdlloader.load_image "./images/1110.png";
    Sdlloader.load_image "./images/0000.png";
    Sdlloader.load_image "./images/path.png";
  |]

let draw_tile screen maze w i j multiplier =
  let img_id =
    match maze.(j + i * w) with
      | {n=Opened; s=Opened; e=Opened; w=Closed; _} -> 0
      | {n=Opened; s=Opened; e=Closed; w=Opened; _} -> 1
      | {n=Opened; s=Opened; e=Closed; w=Closed; _} -> 2
      | {n=Opened; s=Closed; e=Opened; w=Opened; _} -> 3
      | {n=Opened; s=Closed; e=Opened; w=Closed; _} -> 4
      | {n=Opened; s=Closed; e=Closed; w=Opened; _} -> 5
      | {n=Opened; s=Closed; e=Closed; w=Closed; _} -> 6
      | {n=Closed; s=Opened; e=Opened; w=Opened; _} -> 7
      | {n=Closed; s=Opened; e=Opened; w=Closed; _} -> 8
      | {n=Closed; s=Opened; e=Closed; w=Opened; _} -> 9
      | {n=Closed; s=Opened; e=Closed; w=Closed; _} -> 10
      | {n=Closed; s=Closed; e=Opened; w=Opened; _} -> 11
      | {n=Closed; s=Closed; e=Opened; w=Closed; _} -> 12
      | {n=Closed; s=Closed; e=Closed; w=Opened; _} -> 13
      | {n=Opened; s=Opened; e=Opened; w=Opened; _} -> 14
      | {n=Closed; s=Closed; e=Closed; w=Closed; _} -> assert false in
  let img = preloaded_images.(img_id)
  and img_pos = Sdlvideo.rect (j * multiplier) (i * multiplier) multiplier multiplier in
  Sdlvideo.blit_surface ~dst_rect:img_pos ~src:img ~dst:screen ();
  if maze.(j + i * w).id = -1 then begin
    let img_path = preloaded_images.(15)
    and img_path_pos = Sdlvideo.rect (j * multiplier + (2 * multiplier) / 5) (i * multiplier + (2 * multiplier) / 5) (multiplier / 4) (multiplier / 4) in
    Sdlvideo.blit_surface ~dst_rect:img_path_pos ~src:img_path ~dst:screen();
  end

let draw_maze maze w h =
	Sdl.init [`VIDEO];
	at_exit Sdl.quit;
  let multiplier = if w > h then (800 / w) else (800 / h) in
	let screen = Sdlvideo.set_video_mode (w * multiplier) (h * multiplier) [`HWSURFACE] in
	let colour = Sdlvideo.map_RGB screen Sdlvideo.white in
	Sdlvideo.fill_rect screen colour;
	for i = 0 to h - 1 do
    for j = 0 to w - 1 do
      draw_tile screen maze w i j multiplier
    done
  done;
  Sdlvideo.flip screen;
  Sdltimer.delay 5000;
  Sdl.quit ()

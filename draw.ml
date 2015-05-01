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
  |]

let draw_tile screen maze w i j multiplier =
  let img_id =
    match maze.(i + j * w) with
      | {n=true; s=true; e=true; w=false; _} -> 0
      | {n=true; s=true; e=false; w=true; _} -> 1
      | {n=true; s=true; e=false; w=false; _} -> 2
      | {n=true; s=false; e=true; w=true; _} -> 3
      | {n=true; s=false; e=true; w=false; _} -> 4
      | {n=true; s=false; e=false; w=true; _} -> 5
      | {n=true; s=false; e=false; w=false; _} -> 6
      | {n=false; s=true; e=true; w=true; _} -> 7
      | {n=false; s=true; e=true; w=false; _} -> 8
      | {n=false; s=true; e=false; w=true; _} -> 9
      | {n=false; s=true; e=false; w=false; _} -> 10
      | {n=false; s=false; e=true; w=true; _} -> 11
      | {n=false; s=false; e=true; w=false; _} -> 12
      | {n=false; s=false; e=false; w=true; _} -> 13
      | {n=true; s=true; e=true; w=true; _} -> 14
      | {n=false; s=false; e=false; w=false; _} -> assert false in
  let img = preloaded_images.(img_id)
  and img_pos = Sdlvideo.rect (i * multiplier) (j * multiplier) multiplier multiplier in
  Sdlvideo.blit_surface ~dst_rect:img_pos ~src:img ~dst:screen ()

let draw_maze maze w h =
	Sdl.init [`VIDEO];
	at_exit Sdl.quit;
  let multiplier = (800 / w) in
	let screen = Sdlvideo.set_video_mode (w * multiplier) (h * multiplier) [`HWSURFACE] in
	let colour = Sdlvideo.map_RGB screen Sdlvideo.white in
	Sdlvideo.fill_rect screen colour;
	for i = 0 to h - 1 do
    for j = 0 to w - 1 do
      draw_tile screen maze w i j multiplier
    done
  done;
  Sdlvideo.flip screen;
  Sdltimer.delay 10000;
  Sdl.quit ()

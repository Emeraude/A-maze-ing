let open_audio () =
  try
    Sdlmixer.open_audio ();
    at_exit Sdlmixer.close_audio
  with _ ->
    prerr_endline "could not initialize audio device"

let play_music filename =
  let music = Sdlmixer.load_music filename in
  Sdlmixer.play_music music;
  music

let close_music music =
  Sdlmixer.free_music music

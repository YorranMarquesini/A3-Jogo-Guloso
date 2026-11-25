if (video_started && video_get_status() != video_status_closed) video_close();
if (surface_exists(video_snapshot)) surface_free(video_snapshot);
if (sprite_exists(logo_sprite)) sprite_delete(logo_sprite);
if (logo_sound != -1 && audio_is_playing(logo_sound)) audio_stop_sound(logo_sound);
if (shh_instance != -1 && audio_is_playing(shh_instance)) audio_stop_sound(shh_instance);

for (var _i = 0; _i < array_length(art); _i++) {
    if (sprite_exists(art[_i])) sprite_delete(art[_i]);
}
if (sprite_exists(credits_background)) sprite_delete(credits_background);
if (sprite_exists(studio_logo)) sprite_delete(studio_logo);
if (music_handle != noone && audio_is_playing(music_handle)) audio_stop_sound(music_handle);

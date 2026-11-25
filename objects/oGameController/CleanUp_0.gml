if (ambient_handle != noone && audio_is_playing(ambient_handle)) {
    audio_sound_gain(ambient_handle, 0, 250);
    audio_stop_sound(ambient_handle);
}
if (!preserve_music_on_cleanup && music_handle != noone && audio_is_playing(music_handle)) {
    audio_stop_sound(music_handle);
    if (variable_global_exists("gameplay_music_handle")
    &&  global.gameplay_music_handle == music_handle) {
        global.gameplay_music_handle = noone;
    }
}
if (sprite_exists(boss_backdrop)) sprite_delete(boss_backdrop);

if (sprite_exists(forest_sprite)) sprite_delete(forest_sprite);
if (sprite_exists(lake_sprite)) sprite_delete(lake_sprite);
if (transition_music_handle != noone && audio_is_playing(transition_music_handle)) {
    audio_stop_sound(transition_music_handle);
}
for (var _v = 0; _v < array_length(transition_voice_instances); _v++) {
    if (transition_voice_instances[_v] != -1 && audio_is_playing(transition_voice_instances[_v])) {
        audio_stop_sound(transition_voice_instances[_v]);
    }
}

if (bad_ending && audio_is_playing(bad_voice)) audio_stop_sound(bad_voice);
for (var i = 0; i < array_length(bad_scenes); i++) {
    if (sprite_exists(bad_scenes[i])) sprite_delete(bad_scenes[i]);
}
if (sprite_exists(factory_sprite)) sprite_delete(factory_sprite);
if (sprite_exists(forest_sprite)) sprite_delete(forest_sprite);
if (sprite_exists(animals_sprite)) sprite_delete(animals_sprite);
if (music_handle != noone && audio_is_playing(music_handle)) audio_stop_sound(music_handle);
for (var _v = 0; _v < array_length(final_voice_instances); _v++) {
    if (final_voice_instances[_v] != -1 && audio_is_playing(final_voice_instances[_v])) {
        audio_stop_sound(final_voice_instances[_v]);
    }
}

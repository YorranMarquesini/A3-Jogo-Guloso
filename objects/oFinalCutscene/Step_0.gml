timer++;
for (var _v = 0; _v < array_length(final_voices); _v++) {
    if (!final_voice_started[_v] && timer >= final_voice_frames[_v]) {
        final_voice_started[_v] = true;
        final_voice_instances[_v] = audio_play_sound(final_voices[_v], 20, false);
        audio_sound_gain(final_voice_instances[_v], 1, 0);
        final_voice_ducking = true;
        final_voice_duck_until = final_voice_end_frames[_v];
        audio_sound_gain(music_handle, 0.12, 160);
    }
}
if (final_voice_ducking && timer >= final_voice_duck_until) {
    final_voice_ducking = false;
    audio_sound_gain(music_handle, 0.45, 360);
}
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_escape)) {
    finish_final_cutscene();
    exit;
}
if (timer >= 990) finish_final_cutscene();

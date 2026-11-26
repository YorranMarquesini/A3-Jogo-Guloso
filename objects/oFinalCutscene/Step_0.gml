var _pad = scr_gamepad_slot();

timer++;
if (bad_ending) {
    if (timer >= 1190) finish_final_cutscene();
    exit;
}


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
if (controls_read(Bind.confirm, _pad) || controls_menu_space() || controls_read(Bind.back, _pad)) {
    finish_final_cutscene();
    exit;
}
if (timer >= 990) finish_final_cutscene();

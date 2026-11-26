var _pad = scr_gamepad_slot();

timer++;

for (var _v = 0; _v < array_length(transition_voices); _v++) {
    if (!transition_voice_started[_v] && timer >= transition_voice_frames[_v]) {
        transition_voice_started[_v] = true;
        transition_voice_instances[_v] = audio_play_sound(transition_voices[_v], 20, false);
        audio_sound_gain(transition_voice_instances[_v], 1, 0);
        transition_voice_ducking = true;
        transition_voice_duck_until = transition_voice_end_frames[_v];
        audio_sound_gain(transition_music_handle, 0.15, 180);
    }
}

if (transition_voice_ducking && timer >= transition_voice_duck_until) {
    transition_voice_ducking = false;
    audio_sound_gain(transition_music_handle, 0.48, 360);
}

// A transicao completa dura cerca de 14 segundos e pode ser pulada.
if (controls_read(Bind.confirm, _pad)
||  controls_menu_space()
||  controls_read(Bind.back, _pad)) {
    finish_transition();
    exit;
}

if (timer >= 840) finish_transition();

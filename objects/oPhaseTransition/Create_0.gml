timer = 0;
finished = false;
transition_path = working_directory + "transition/";
forest_sprite = sprite_add(transition_path + "phase_transition_forest.png", 1, false, false, 0, 0);
lake_sprite = sprite_add(transition_path + "phase_transition_lake.png", 1, false, false, 0, 0);
player_sprite = player_right_idle;
transition_music_handle = audio_play_sound(snd_theme_transition, 2, true);
audio_sound_gain(transition_music_handle, 0.48, 600);

// As duas falas acompanham a floresta e o lago, com a musica abaixando
// somente enquanto a narracao estiver ativa.
transition_voices = [snd_transition_voice_01, snd_transition_voice_02];
transition_voice_instances = [-1, -1];
transition_voice_started = [false, false];
transition_voice_frames = [205, 445];
transition_voice_end_frames = [385, 640];
transition_voice_ducking = false;
transition_voice_duck_until = -1;

function finish_transition() {
    if (finished) return;
    finished = true;
    global.fase2_landing_pending = true;
    global.player_cutscene_locked = true;
    room_goto(Fase2);
}

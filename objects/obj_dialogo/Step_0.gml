var _pad = scr_gamepad_slot();

if (tocando_final) {
    if (!audio_is_playing(voz_atual)) fechar_dialogo();
    exit;
}

var _texto = textos[pagina];
var _input_avancar = controls_read(Bind.interact, _pad) || mouse_check_button_pressed(mb_left);
var _ultimo = pagina == array_length(textos) - 1;

if (caractere_atual < string_length(_texto)) {
    caractere_atual = _input_avancar ? string_length(_texto) : caractere_atual + velocidade_texto;
    exit;
}

var _tem_voz = pagina < array_length(audios) && audios[pagina] != noone;
var _fala_terminou;
if (_tem_voz) {
    _fala_terminou = !audio_is_playing(voz_atual);
} else {
    if (tempo_espera_frames < 0) {
        tempo_espera_frames = ceil(tempo_padrao_sem_audio * game_get_speed(gamespeed_fps));
    }
    tempo_espera_frames--;
    _fala_terminou = tempo_espera_frames <= 0;
}

if (_ultimo && audio_final != noone) {
    if (_fala_terminou) {
        tocando_final = true;
        voz_atual = audio_play_sound(audio_final, 1, false);
    }
    exit;
}

if (_fala_terminou || _input_avancar) {
    if (_ultimo) {
        fechar_dialogo();
    } else {
        pagina++;
        caractere_atual = 0;
        tempo_espera_frames = -1;
        tocar_voz_pagina();
    }
}

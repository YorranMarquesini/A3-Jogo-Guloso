nome = "";
textos = [];
portrait = noone;
audios = [];

pagina = 0;
caractere_atual = 0;
velocidade_texto = 0.5;
voz_atual = noone;
audio_final = noone;
tocando_final = false;

function tocar_voz_pagina() {
    if (voz_atual != noone) audio_stop_sound(voz_atual);
    voz_atual = noone;
    if (pagina < array_length(audios) && audios[pagina] != noone) {
        voz_atual = audio_play_sound(audios[pagina], 1, false);
    }
}

function fechar_dialogo() {
    scr_weapon("arpao");
    instance_destroy();
}

// Tempo padrao de espera em segundos caso a fala NAO tenha audio
tempo_padrao_sem_audio = 2.5; 

// Guarda os frames que faltam para pular a pagina atual
tempo_espera_frames = -1;

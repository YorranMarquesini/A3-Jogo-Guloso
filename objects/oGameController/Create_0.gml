// ============================================================
//  Controlador do jogo dentro da Room1.
//  A resolução lógica vive em scr_config (BASE_WIDTH / BASE_HEIGHT).
// ============================================================

fullscreen_key = vk_f11;

// Trava a tela interna na resolução base.
screen_apply_base();

// ATENÇÃO: aqui NÃO se mexe no tamanho da janela.
// O jogador escolheu uma resolução no menu de opções; se este objeto
// forçasse BASE_WIDTH x BASE_HEIGHT ao entrar na Room1, ele jogaria
// fora a escolha do jogador e o jogo abriria menor do que o pedido.
//
// A única exceção é rodar a Room1 direto pela IDE, sem passar pelo menu:
// aí ninguém dimensionou a janela ainda, então damos um tamanho inicial.
if (!instance_exists(obj_opcoesMenu) && !window_get_fullscreen()) {
    window_set_size(BASE_WIDTH, BASE_HEIGHT);
    window_center();
}

gpu_set_texfilter(false);   // pixel art sem borrão

// Os puzzles industriais sempre recomecam no estado fechado ao entrar ou
// tentar novamente a Fase 2.
if (room == Fase2) global.factory_switches = array_create(4, false);

// Ambientes discretos acompanham a identidade de cada fase. A arena do
// Cagliostro fica sem ambience para nao competir com sua musica.
ambient_handle = noone;
boss_backdrop = -1;
music_handle = noone;
preserve_music_on_cleanup = false;

// Saria's Song atravessa Tutorial -> Fase 1 sem recomecar na troca de room.
if (room == Tutoras || room == Room1) {
    if (!variable_global_exists("gameplay_music_handle")) global.gameplay_music_handle = noone;
    if (global.gameplay_music_handle == noone || !audio_is_playing(global.gameplay_music_handle)) {
        global.gameplay_music_handle = audio_play_sound(snd_theme_tutorial_fase1, 1, true);
        audio_sound_gain(global.gameplay_music_handle, 0.42, 500);
    }
    music_handle = global.gameplay_music_handle;
    preserve_music_on_cleanup = (room == Tutoras);
} else if (room == Fase2) {
    music_handle = audio_play_sound(snd_theme_fase2, 1, true);
    audio_sound_gain(music_handle, 0.44, 600);
}

if (room == Room1 || room == BossRoom) {
    ambient_handle = audio_play_sound(snd_ambient_forest, 0, true);
    audio_sound_gain(ambient_handle, 0.12, 800);
    if (room == BossRoom) {
        boss_backdrop = sprite_add(working_directory + "boss1/boss1_ocean.png", 1, false, false, 0, 0);
        with (oSky) visible = false;
        // A camada preta da room esta em depth 200 e os objetos em 100.
        // O fundo fica no meio: aparece sobre o preto, mas atras do jogo.
        depth = 150;
        visible = true;
    }
} else if (room == Fase2) {
    ambient_handle = audio_play_sound(snd_ambient_factory, 0, true);
    audio_sound_gain(ambient_handle, 0.10, 800);
}

if (room == Fase2
&&  variable_global_exists("fase2_landing_pending")
&&  global.fase2_landing_pending
&& !instance_exists(oPhase2Landing)) {
    instance_create_depth(0, 0, -9998, oPhase2Landing);
}

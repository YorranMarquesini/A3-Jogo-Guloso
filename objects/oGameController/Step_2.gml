// ============================================================
//  F11 alterna tela cheia.
//
//  Repare no que NÃO tem mais aqui: nenhum view_set_wport com o
//  tamanho da janela. Era isso que fazia a tela cheia bagunçar.
//  Tela cheia só muda o tamanho da JANELA — o GameMaker estica
//  a tela interna pra dentro dela.
// ============================================================

if (keyboard_check_pressed(fullscreen_key)) {
    var _indo_pra_tela_cheia = !window_get_fullscreen();
    window_set_fullscreen(_indo_pra_tela_cheia);

    // saindo da tela cheia: pede de volta o tamanho de janela escolhido
    if (!_indo_pra_tela_cheia && variable_global_exists("win_want_w")) {
        window_request_size(global.win_want_w, global.win_want_h);
    }
}

// O GameMaker redimensiona a application_surface sozinho quando a janela
// muda de tamanho. Isto desfaz e mantém a resolução do jogo travada.
if (screen_needs_fix()) {
    screen_apply_base();
}

// Insiste no tamanho de janela pedido até o Windows obedecer.
window_apply_pending();

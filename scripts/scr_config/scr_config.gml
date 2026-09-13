// ============================================================
//  scr_config — configuração de tela do jogo.
//
//  A RESOLUÇÃO LÓGICA do jogo mora aqui e em nenhum outro lugar.
//  Mudou aqui, mudou no jogo inteiro.
//
//  Entenda as 4 camadas:
//    1. Câmera   -> quanto do MUNDO aparece   (fixa: BASE_WIDTH x BASE_HEIGHT)
//    2. Viewport -> onde a câmera desenha      (fixo)
//    3. Surface  -> a "tela interna" do jogo   (fixa)
//    4. Janela   -> o monitor                  (livre, muda à vontade)
//
//  Tela cheia mexe SÓ na camada 4. O GameMaker estica a camada 3
//  pra dentro da janela sozinho. É isso que faz o jogo aumentar
//  em vez de mostrar mais cenário.
// ============================================================

#macro BASE_WIDTH  1366
#macro BASE_HEIGHT 768


/// @desc Trava a tela interna do jogo na resolução base.
///       A janela pode ter qualquer tamanho — isto aqui não muda nunca.
function screen_apply_base() {

    // 1. viewport: a área da tela interna onde a câmera desenha
    view_set_xport(0, 0);
    view_set_yport(0, 0);
    view_set_wport(0, BASE_WIDTH);
    view_set_hport(0, BASE_HEIGHT);

    // 2. a tela interna em si
    if (surface_exists(application_surface)) {
        if (surface_get_width(application_surface)  != BASE_WIDTH
         || surface_get_height(application_surface) != BASE_HEIGHT) {
            surface_resize(application_surface, BASE_WIDTH, BASE_HEIGHT);
        }
    }

    // 3. a camada de GUI (menus, HUD) — mesma resolução, senão o menu desalinha
    display_set_gui_size(BASE_WIDTH, BASE_HEIGHT);
}


/// @desc A tela interna saiu do tamanho certo?
///       O GameMaker redimensiona a application_surface sozinho quando a janela
///       muda (tela cheia, arrastar a borda). Isto detecta e permite desfazer.
/// @return {Bool}
function screen_needs_fix() {
    if (!surface_exists(application_surface)) return false;

    return surface_get_width(application_surface)  != BASE_WIDTH
        || surface_get_height(application_surface) != BASE_HEIGHT;
}


// ============================================================
//  TAMANHO DA JANELA
//
//  Por que isto não é só um window_set_size()?
//  Porque sair da tela cheia não é instantâneo. O Windows leva alguns
//  frames pra devolver a janela, e quando devolve ele restaura o tamanho
//  ANTIGO — passando por cima do tamanho que você acabou de pedir.
//
//  Então em vez de mandar uma vez e torcer, a gente ANOTA o tamanho
//  desejado e insiste por alguns frames até a janela obedecer.
// ============================================================

/// @desc Pede um tamanho de janela. Vai ser aplicado assim que der.
/// @param {Real} _w  largura desejada
/// @param {Real} _h  altura desejada
function window_request_size(_w, _h) {
    global.win_want_w = _w;
    global.win_want_h = _h;
    global.win_tries  = 40;   // insiste por até 40 frames (~0,7s)
}


/// @desc Aplica o tamanho pedido, se ainda houver um pendente.
///       Chamar todo frame, num End Step.
function window_apply_pending() {
    if (!variable_global_exists("win_tries")) return;
    if (global.win_tries <= 0)                return;

    // em tela cheia não faz sentido mexer no tamanho — espera sair
    if (window_get_fullscreen()) return;

    global.win_tries--;

    if (window_get_width()  == global.win_want_w
     && window_get_height() == global.win_want_h) {
        global.win_tries = 0;   // a janela obedeceu, pode parar
        exit;
    }

    window_set_size(global.win_want_w, global.win_want_h);
    window_center();
}

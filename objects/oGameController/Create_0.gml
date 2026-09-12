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

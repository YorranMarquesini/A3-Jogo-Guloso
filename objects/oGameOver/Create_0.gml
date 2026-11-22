// ============================================================
//  TELA DE MORTE
//  Quem me cria é o scr_damage_player, quando a vida chega a zero.
// ============================================================

depth = -9999;   // por cima de tudo

// ---- congela a última imagem do jogo ----
// Instâncias desativadas não são desenhadas, então sem esta foto
// o cenário sumiria e sobraria só o fundo.
tela = -1;
if (surface_exists(application_surface)) {
    tela = surface_create(surface_get_width(application_surface),
                          surface_get_height(application_surface));
    surface_copy(tela, 0, 0, application_surface);
}

// ---- congela o jogo ----
// o 'true' quer dizer "menos eu", então este objeto continua rodando
instance_deactivate_all(true);

// ---- animação de entrada ----
fade   = 0;
atraso = 24;   // ignora teclas nos primeiros frames, pra não reiniciar sem querer

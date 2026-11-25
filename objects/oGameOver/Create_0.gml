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

// ---- animacao / menu ----
fade = 0;
atraso = 24;
opcao = 0;
pulso = 0;

// Na derrota de chefe, a musica respira por vinte segundos antes do fade.
eh_chefe = (room == BossRoom || room == Fase2Boss);
musica_timer = 20 * game_get_speed(gamespeed_fps);
musica_parada = false;

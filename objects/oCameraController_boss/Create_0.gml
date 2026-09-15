// ============================================================
//  A câmera define QUANTO DO MUNDO aparece na tela.
//
//  Como o tamanho vem de BASE_WIDTH/BASE_HEIGHT (scr_config) e nunca
//  muda, a quantidade de cenário visível é sempre a mesma — em janela,
//  em tela cheia, em qualquer resolução. Só o tamanho da imagem muda.
//
//  Na sala de boss, aplicamos um fator de zoom out por cima do
//  tamanho base, pra dar mais espaço de visão pra luta inteira.
// ============================================================

boss_zoom_factor = 1.5; // 1 = normal, >1 = mais afastado
shake_amount = 0;

cam_width  = BASE_WIDTH * boss_zoom_factor;
cam_height = BASE_HEIGHT * boss_zoom_factor;

// A room já cria uma câmera para a view 0 (Viewports ligado nas propriedades
// da Room1). Reaproveitar ela evita vazar uma câmera nova a cada vez que
// a sala é reaberta.
camera = view_camera[0];

if (camera < 0) {
    camera = camera_create_view(0, 0, cam_width, cam_height);
    view_camera[0] = camera;
}

camera_set_view_size(camera, cam_width, cam_height);

view_enabled    = true;
view_visible[0] = true;

// Alvos: câmera fica entre o player e o boss
target_player = oPlayer;
target_boss   = oBoss;

cam_lerp = 0.05; // suavização — mais baixo = mais "pesado"/cinematográfico

cam_x = target_player.x;
cam_y = target_player.y;
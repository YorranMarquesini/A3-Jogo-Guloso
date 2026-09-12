// ============================================================
//  A câmera define QUANTO DO MUNDO aparece na tela.
//
//  Como o tamanho vem de BASE_WIDTH/BASE_HEIGHT (scr_config) e nunca
//  muda, a quantidade de cenário visível é sempre a mesma — em janela,
//  em tela cheia, em qualquer resolução. Só o tamanho da imagem muda.
// ============================================================

cam_width  = BASE_WIDTH;
cam_height = BASE_HEIGHT;

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

target = oPlayer;

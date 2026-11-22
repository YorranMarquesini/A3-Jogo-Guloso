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

// A view considera os limites visuais completos do boss e do jogador.
boss_zoom_factor = 1.5;
camera_aspect = BASE_WIDTH / BASE_HEIGHT;
frame_padding_x = 20;
frame_padding_y = 20;
shake_amount = 0;
cam_lerp = 0.05;

target_player = instance_find(oPlayer, 0);
target_boss = instance_find(oBoss, 0);
if (target_boss == noone) target_boss = instance_find(oCagliostro, 0);

cam_width = BASE_WIDTH * boss_zoom_factor;
cam_height = BASE_HEIGHT * boss_zoom_factor;
initial_cam_x = (target_player != noone) ? target_player.x : room_width * 0.5;
initial_cam_y = (target_player != noone) ? target_player.y : room_height * 0.5;

// Amplia a view somente se o conteúdo não couber no zoom padrão.
if (instance_exists(target_player) && instance_exists(target_boss)) {
    var _scale_x = abs(target_boss.image_xscale);
    var _scale_y = abs(target_boss.image_yscale);
    var _sprite = target_boss.sprite_index;
    var _boss_left = target_boss.x - sprite_get_xoffset(_sprite) * _scale_x;
    var _boss_top = target_boss.y - sprite_get_yoffset(_sprite) * _scale_y;
    var _boss_right = _boss_left + sprite_get_width(_sprite) * _scale_x;
    var _boss_bottom = _boss_top + sprite_get_height(_sprite) * _scale_y;

    var _left = min(target_player.bbox_left, _boss_left);
    var _right = max(target_player.bbox_right, _boss_right);
    var _top = min(target_player.bbox_top, _boss_top);
    var _bottom = max(target_player.bbox_bottom, _boss_bottom);
    var _required_w = (_right - _left) + frame_padding_x * 2;
    var _required_h = (_bottom - _top) + frame_padding_y * 2;

    initial_cam_x = (_left + _right) * 0.5;
    initial_cam_y = (_top + _bottom) * 0.5;

    cam_width = max(cam_width, _required_w, _required_h * camera_aspect);
    cam_height = cam_width / camera_aspect;

    // Limite correto para uma room 2560x1280 mantendo proporção 1366:768.
    var _max_width = min(room_width, room_height * camera_aspect);
    var _max_height = _max_width / camera_aspect;
    cam_width = min(cam_width, _max_width);
    cam_height = min(cam_height, _max_height);
}

camera = view_camera[0];
if (camera < 0) {
    camera = camera_create_view(0, 0, cam_width, cam_height);
    view_camera[0] = camera;
}
camera_set_view_size(camera, cam_width, cam_height);

view_enabled = true;
view_visible[0] = true;

cam_x = initial_cam_x;
cam_y = initial_cam_y;

// As duas arenas mantêm o enquadramento calculado no início da luta.
camera_locked = (room == BossRoom || room == Fase2Boss);
locked_cam_x = clamp(cam_x - cam_width * 0.5, 0, max(0, room_width - cam_width));
locked_cam_y = clamp(cam_y - cam_height * 0.5, 0, max(0, room_height - cam_height));

if (camera_locked) {
    camera_set_view_pos(camera, floor(locked_cam_x), floor(locked_cam_y));
}

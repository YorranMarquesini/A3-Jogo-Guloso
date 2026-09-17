x += dir_x * move_spd;
y += dir_y * move_spd;

// Destrói ao sair da VIEW (não da room inteira, já que sua câmera segue o player)
var _margin = 32; // folga pra não sumir bruscamente na borda
var _view_x = camera_get_view_x(view_camera[0]);
var _view_y = camera_get_view_y(view_camera[0]);
var _view_w = camera_get_view_width(view_camera[0]);
var _view_h = camera_get_view_height(view_camera[0]);

if (x < _view_x - _margin || x > _view_x + _view_w + _margin ||
    y < _view_y - _margin || y > _view_y + _view_h + _margin) {
    instance_destroy();
    exit;
}

// Dano no player (respeitando invencibilidade do dash)
if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.is_invincible) {
        scr_damage_player(1, x);// Sistema de dano so adicionar isso em qualquer coisa que da dano
        instance_destroy();
    }
}
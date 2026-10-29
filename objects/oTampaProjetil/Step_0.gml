x += dir_x * move_spd;
y += dir_y * move_spd;

image_angle -= 14;   // girando no ar


// ---- sumir ao sair da view (mesma lógica do oBossProjectile) ----
var _margem = 48;
var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);

if (x < _vx - _margem || x > _vx + _vw + _margem
 || y < _vy - _margem || y > _vy + _vh + _margem) {
    instance_destroy();
    exit;
}


// ---- bateu no cenário ----
if (place_meeting(x, y, oGround) || place_meeting(x, y, oWall)) {
    instance_destroy();
    exit;
}


// ---- acertou o player ----
// O scr_damage_player já ignora o dano se o player estiver invencível
// (i-frames ou dash). A tampa some de qualquer jeito: atravessar ela
// com o dash é recompensa, não castigo.
if (instance_exists(oPlayer) && place_meeting(x, y, oPlayer)) {
    scr_damage_player(dano, x);
    instance_destroy();
    exit;
}

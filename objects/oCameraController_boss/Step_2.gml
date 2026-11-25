// As duas arenas usam o enquadramento calculado no Create sem movimento.
if (camera_locked) {
    var _locked_x = floor(locked_cam_x);
    var _locked_y = floor(locked_cam_y);
    if (shake_amount > 0) {
        _locked_x += random_range(-shake_amount, shake_amount);
        _locked_y += random_range(-shake_amount, shake_amount);
        shake_amount = max(shake_amount - 0.5, 0);
    }
    camera_set_view_pos(camera, _locked_x, _locked_y);
    exit;
}

// Fallback para qualquer outra room que reutilize este controlador.
if (!instance_exists(target_player)) target_player = instance_find(oPlayer, 0);
if (!instance_exists(target_boss)) {
    target_boss = instance_find(oBoss, 0);
    if (target_boss == noone) target_boss = instance_find(oCagliostro, 0);
}

var _has_player = instance_exists(target_player);
var _has_boss = instance_exists(target_boss);

if (_has_player && _has_boss) {
    // Usa os limites visuais do sprite ampliado, não apenas o x/y da instância.
    var _scale_x = abs(target_boss.image_xscale);
    var _scale_y = abs(target_boss.image_yscale);
    var _sprite = target_boss.sprite_index;
    var _boss_left = target_boss.x - sprite_get_xoffset(_sprite) * _scale_x;
    var _boss_top = target_boss.y - sprite_get_yoffset(_sprite) * _scale_y;
    var _boss_right = _boss_left + sprite_get_width(_sprite) * _scale_x;
    var _boss_bottom = _boss_top + sprite_get_height(_sprite) * _scale_y;

    var _content_left = min(target_player.bbox_left, _boss_left);
    var _content_right = max(target_player.bbox_right, _boss_right);
    var _content_top = min(target_player.bbox_top, _boss_top);
    var _content_bottom = max(target_player.bbox_bottom, _boss_bottom);

    var _goal_x = (_content_left + _content_right) * 0.5;
    var _goal_y = (_content_top + _content_bottom) * 0.5;
} else if (_has_player) {
    var _goal_x = target_player.x;
    var _goal_y = target_player.y;
} else {
    var _goal_x = cam_x;
    var _goal_y = cam_y;
}

cam_x = lerp(cam_x, _goal_x, cam_lerp);
cam_y = lerp(cam_y, _goal_y, cam_lerp);

var _cam_x = cam_x - cam_width * 0.5;
var _cam_y = cam_y - cam_height * 0.5;

_cam_x = clamp(_cam_x, 0, max(0, room_width - cam_width));
_cam_y = clamp(_cam_y, 0, max(0, room_height - cam_height));

_cam_x = floor(_cam_x);
_cam_y = floor(_cam_y);

if (shake_amount > 0) {
    _cam_x += random_range(-shake_amount, shake_amount);
    _cam_y += random_range(-shake_amount, shake_amount);
    shake_amount = max(shake_amount - 0.5, 0);
}

camera_set_view_pos(camera, _cam_x, _cam_y);

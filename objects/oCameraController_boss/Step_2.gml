var _has_player = instance_exists(target_player);
var _has_boss   = instance_exists(target_boss);

if (_has_player && _has_boss) {
    // Ponto médio entre player e boss
    var _goal_x = (target_player.x + target_boss.x) / 2;
    var _goal_y = (target_player.y + target_boss.y) / 2;

} else if (_has_player) {
    // Boss morreu/não existe mais: segue só o player
    var _goal_x = target_player.x;
    var _goal_y = target_player.y;

} else {
    // Nenhum dos dois existe (raro) — mantém a posição atual
    var _goal_x = cam_x;
    var _goal_y = cam_y;
}

// Suaviza o movimento até o alvo
cam_x = lerp(cam_x, _goal_x, cam_lerp);
cam_y = lerp(cam_y, _goal_y, cam_lerp);

var _cam_x = cam_x - cam_width * 0.5;
var _cam_y = cam_y - cam_height * 0.5;

_cam_x = clamp(
    _cam_x,
    0,
    max(0, room_width - cam_width)
);

_cam_y = clamp(
    _cam_y,
    0,
    max(0, room_height - cam_height)
);

_cam_x = floor(_cam_x);
_cam_y = floor(_cam_y);

if (shake_amount > 0) {
    _cam_x += random_range(-shake_amount, shake_amount);
    _cam_y += random_range(-shake_amount, shake_amount);
    shake_amount = max(shake_amount - 0.5, 0);
}

camera_set_view_pos(
    camera,
    _cam_x,
    _cam_y
);
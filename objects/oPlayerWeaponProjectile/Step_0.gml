x += dir_x * move_spd;
image_angle += spin_speed * dir_x;

lifetime -= 1;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// --- EFEITO DE RASTRO ---
trail_timer -= 1;
if (trail_timer <= 0) {
    trail_timer = trail_interval;
    var _t = instance_create_depth(x, y, depth, oAfterimage);
    _t.sprite_index = sprite_index;
    _t.image_index = 0;
    _t.image_xscale = image_xscale;
    _t.image_yscale = image_yscale;
    _t.image_angle = image_angle;
}

// --- DESTRÓI AO SAIR DA VIEW ---
var _margin = 32;
var _view_x = camera_get_view_x(view_camera[0]);
var _view_y = camera_get_view_y(view_camera[0]);
var _view_w = camera_get_view_width(view_camera[0]);
var _view_h = camera_get_view_height(view_camera[0]);

if (x < _view_x - _margin || x > _view_x + _view_w + _margin ||
    y < _view_y - _margin || y > _view_y + _view_h + _margin) {
    instance_destroy();
    exit;
}

// --- DANO NO BOSS ---
if (scr_try_hit_enemy(x, y, thrown_weapon_type, false)) {
    instance_destroy();
}
// ============================
// HUD DE VIDA (corações)
// ============================
var _heart_size = 32;
var _heart_spacing = 36;
var _heart_x = 20;
var _heart_y = 20;

for (var _i = 0; _i < max_hp; _i++) {
    var _hx = _heart_x + (_i * _heart_spacing);

    if (_i < hp) {
        draw_sprite_ext(spr_heart, 0, _hx, _heart_y, 1, 1, 0, c_white, 1);
    } else {
        draw_sprite_ext(spr_heart, 0, _hx, _heart_y, 1, 1, 0, c_gray, 0.4);
    }
}

// ============================
// BARRA DE POLUIÇÃO (logo abaixo dos corações)
// ============================
if (variable_global_exists("pollution_pct")) {
    var _pbar_x = 20;
    var _pbar_y = 110;
    var _pbar_w = 100;
    var _pbar_h = 8;

    draw_set_color(c_black);
    draw_rectangle(_pbar_x, _pbar_y, _pbar_x + _pbar_w, _pbar_y + _pbar_h, false);

    var _fill_w = _pbar_w * (global.pollution_pct / 100);
    draw_set_color(merge_color(c_lime, c_red, global.pollution_pct / 100));
    draw_rectangle(_pbar_x, _pbar_y, _pbar_x + _fill_w, _pbar_y + _pbar_h, false);

    draw_set_color(c_white);
    draw_rectangle(_pbar_x, _pbar_y, _pbar_x + _pbar_w, _pbar_y + _pbar_h, true);
    draw_set_color(c_white);
}

// ============================
// BARRA DE COOLDOWN DO DASH (abaixo da barra de poluição)
// ============================
var _bar_x = 20;
var _bar_y = 130;
var _bar_w = 60;
var _bar_h = 10;

draw_set_color(c_black);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

var _fill_pct = 1 - (dash_cooldown / dash_cooldown_max);
_fill_pct = clamp(_fill_pct, 0, 1);

var _fill_color = can_dash ? c_aqua : c_gray;
draw_set_color(_fill_color);
draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w * _fill_pct), _bar_y + _bar_h, false);

draw_set_color(c_white);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);
draw_set_color(c_white);

// ============================
// UI DE ARMA ATUAL (slot único, abaixo de tudo)
// ============================
var _sx = weapon_ui_x;
var _sy = weapon_ui_y;

draw_set_alpha(weapon_ui_bg_alpha);
draw_set_color(weapon_ui_bg_color);
draw_rectangle(_sx, _sy, _sx + weapon_ui_slot_size, _sy + weapon_ui_slot_size, false);
draw_set_alpha(1);

draw_set_color(weapon_ui_border_color);
draw_rectangle(_sx, _sy, _sx + weapon_ui_slot_size, _sy + weapon_ui_slot_size, true);

if (has_weapon && weapon_sprite != noone) {
    var _icon_target = weapon_ui_slot_size * weapon_ui_icon_padding;
    var _icon_scale = _icon_target / sprite_get_width(weapon_sprite);

    var _center_x = _sx + weapon_ui_slot_size / 2;
    var _center_y = _sy + weapon_ui_slot_size / 2;

    var _sprite_w = sprite_get_width(weapon_sprite);
    var _sprite_h = sprite_get_height(weapon_sprite);
    var _origin_x = sprite_get_xoffset(weapon_sprite);
    var _origin_y = sprite_get_yoffset(weapon_sprite);

    var _draw_x = _center_x - (_sprite_w / 2 - _origin_x) * _icon_scale;
    var _draw_y = _center_y - (_sprite_h / 2 - _origin_y) * _icon_scale;

    draw_sprite_ext(
        weapon_sprite, 0,
        _draw_x, _draw_y,
        _icon_scale, _icon_scale,
        0, c_white, 1
    );
}

draw_set_color(c_white);
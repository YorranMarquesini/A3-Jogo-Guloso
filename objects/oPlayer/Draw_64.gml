// Posição fixa na tela (canto inferior esquerdo, por exemplo)
var _bar_x = 20;
var _bar_y = display_get_gui_height() - 40;
var _bar_w = 60;
var _bar_h = 10;

// Fundo da barra
draw_set_color(c_black);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

// Preenchimento (mostra o quanto falta pro dash recarregar)
var _fill_pct = 1 - (dash_cooldown / dash_cooldown_max);
_fill_pct = clamp(_fill_pct, 0, 1);

var _fill_color = can_dash ? c_aqua : c_gray;
draw_set_color(_fill_color);
draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w * _fill_pct), _bar_y + _bar_h, false);

// Borda
draw_set_color(c_white);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

draw_set_color(c_white); // reset pra não afetar outros draws

// --- HUD DE VIDA (corações) ---
var _heart_size = 32;
var _heart_spacing = 36;
var _heart_x = 20;
var _heart_y = 20;

for (var _i = 0; _i < max_hp; _i++) {
    var _hx = _heart_x + (_i * _heart_spacing);

    if (_i < hp) {
        // Coração cheio
        draw_sprite_ext(spr_heart, 0, _hx, _heart_y, 1, 1, 0, c_white, 1);
    } else {
        // Coração vazio (mais escuro/transparente, já que não temos sprite separado ainda)
        draw_sprite_ext(spr_heart, 0, _hx, _heart_y, 1, 1, 0, c_gray, 0.4);
    }
}

// ============================
// UI DE ARMA ATUAL (slot único)
// ============================
var _sx = weapon_ui_x;
var _sy = weapon_ui_y;

// Fundo do quadrado
draw_set_alpha(weapon_ui_bg_alpha);
draw_set_color(weapon_ui_bg_color);
draw_rectangle(_sx, _sy, _sx + weapon_ui_slot_size, _sy + weapon_ui_slot_size, false);
draw_set_alpha(1);

// Borda
draw_set_color(weapon_ui_border_color);
draw_rectangle(_sx, _sy, _sx + weapon_ui_slot_size, _sy + weapon_ui_slot_size, true);

// Ícone da arma EQUIPADA no momento (troca sozinho quando você dá switch)
if (has_weapon && weapon_sprite != noone) {
    var _icon_target = weapon_ui_slot_size * weapon_ui_icon_padding;
    var _icon_scale = _icon_target / sprite_get_width(weapon_sprite);

    var _center_x = _sx + weapon_ui_slot_size / 2;
    var _center_y = _sy + weapon_ui_slot_size / 2;

    // Compensa a origem do sprite (que pode não estar no centro dele)
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

draw_set_color(c_white); // reset
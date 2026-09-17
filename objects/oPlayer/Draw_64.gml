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
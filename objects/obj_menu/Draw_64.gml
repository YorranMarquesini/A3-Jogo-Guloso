var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _accent = menu_accent[menu_variant];

if (sprite_exists(menu_background)) {
    var _sw = sprite_get_width(menu_background);
    var _sh = sprite_get_height(menu_background);
    var _zoom = max(_gui_w / _sw, _gui_h / _sh) * (1.025 + sin(menu_time * 0.35) * 0.004);
    var _dw = _sw * _zoom;
    var _dh = _sh * _zoom;
    draw_sprite_ext(menu_background, 0,
        (_gui_w - _dw) * 0.5 + sin(menu_time * 0.18) * 5,
        (_gui_h - _dh) * 0.5 + cos(menu_time * 0.21) * 3,
        _zoom, _zoom, 0, c_white, 1);
}

// Vinheta irregular, sem o aspecto de painel moderno.
draw_set_alpha(0.54);
draw_rectangle_color(0, 0, _gui_w * 0.37, _gui_h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(0.25);
draw_rectangle_color(_gui_w * 0.37, 0, _gui_w * 0.54, _gui_h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

// Esporos quadrados combinam com os pixels do cenario.
for (var p = 0; p < 16; p++) {
    var _px = ((_gui_w * 0.43) + p * 89) mod _gui_w;
    var _py = _gui_h + 70 - ((menu_time * (9 + (p mod 4) * 3) + p * 67) mod (_gui_h + 130));
    var _ps = 2 + (p mod 2) * 2;
    draw_set_alpha(0.16 + 0.22 * (0.5 + 0.5 * sin(menu_time * 1.4 + p)));
    draw_set_color(_accent);
    draw_rectangle(_px, _py, _px + _ps, _py + _ps, false);
}
draw_set_alpha(1);

// Logotipo em fonte de bitmap, com sombra dura como um sprite.
draw_set_font(fnt_tutoras);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _tx = _gui_w * 0.055;
var _ty = _gui_h * 0.075;
var _ts = min(_gui_w / 1366, _gui_h / 768) * 4.35;
draw_set_color(make_color_rgb(7, 13, 10));
draw_text_transformed(_tx + 7, _ty + 7, "SPIRIT", _ts, _ts, 0);
draw_text_transformed(_tx + 7, _ty + 82, "AWAKEN", _ts, _ts, 0);
draw_set_color(_accent);
draw_text_transformed(_tx - 2, _ty - 2, "SPIRIT", _ts, _ts, 0);
draw_text_transformed(_tx - 2, _ty + 73, "AWAKEN", _ts, _ts, 0);
draw_set_color(make_color_rgb(230, 226, 196));
draw_text_transformed(_tx, _ty, "SPIRIT", _ts, _ts, 0);
draw_text_transformed(_tx, _ty + 75, "AWAKEN", _ts, _ts, 0);

// Galho/musgo decorativo sob o titulo.
draw_set_color(make_color_rgb(54, 69, 43));
draw_rectangle(_tx, _ty + 151, _tx + 268, _ty + 157, false);
draw_set_color(_accent);
draw_rectangle(_tx + 9, _ty + 148, _tx + 78, _ty + 152, false);
draw_rectangle(_tx + 101, _ty + 150, _tx + 181, _ty + 153, false);
draw_rectangle(_tx + 207, _ty + 147, _tx + 260, _ty + 152, false);
draw_set_font(fnt_dialogo);
draw_set_color(make_color_rgb(202, 204, 174));
draw_text(_tx, _ty + 169, "A NATUREZA VAI DESPERTAR");

// Placas entalhadas, com cantos em blocos e musgo quebrado.
var _menu_x = _gui_w * 0.185;
var _menu_y = _gui_h * 0.605;
var _espaco = max(50, _gui_h * 0.072);
var _wood_dark = make_color_rgb(26, 29, 24);
var _wood = make_color_rgb(55, 55, 42);
var _wood_light = make_color_rgb(86, 80, 55);

draw_set_font(fnt_tutoras);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
for (var i = 0; i < total_opcoes; i++) {
    var _y = _menu_y + i * _espaco;
    var _selected = (i == opcao_selecionada);
    var _hw = largura_opcao * 0.5 + (_selected ? 7 : 0);
    var _hh = altura_opcao * 0.5;

    draw_set_alpha(0.78);
    draw_set_color(c_black);
    draw_rectangle(_menu_x - _hw + 6, _y - _hh + 7, _menu_x + _hw + 7, _y + _hh + 7, false);
    draw_set_alpha(_selected ? 0.98 : 0.82);
    draw_set_color(_wood_dark);
    draw_rectangle(_menu_x - _hw + 7, _y - _hh - 3, _menu_x + _hw - 7, _y + _hh + 3, false);
    draw_rectangle(_menu_x - _hw, _y - _hh + 5, _menu_x + _hw, _y + _hh - 5, false);
    draw_set_color(_wood);
    draw_rectangle(_menu_x - _hw + 5, _y - _hh + 6, _menu_x + _hw - 5, _y + _hh - 6, false);
    draw_set_color(_wood_light);
    draw_rectangle(_menu_x - _hw + 12, _y - _hh + 7, _menu_x + _hw - 18, _y - _hh + 10, false);

    draw_set_color(_selected ? _accent : make_color_rgb(72, 83, 60));
    draw_rectangle(_menu_x - _hw + 14, _y - _hh + 2, _menu_x - _hw + 70, _y - _hh + 6, false);
    draw_rectangle(_menu_x - _hw + 94, _y - _hh + 3, _menu_x - _hw + 148, _y - _hh + 7, false);
    draw_rectangle(_menu_x + _hw - 62, _y - _hh + 1, _menu_x + _hw - 16, _y - _hh + 5, false);

    if (_selected) {
        var _spirit_x = _menu_x - _hw - 24 + sin(menu_time * 4) * 3;
        var _bob = sin(menu_time * 6) * 3;
        draw_set_alpha(0.28);
        draw_set_color(_accent);
        draw_rectangle(_spirit_x - 5, _y - 11 + _bob, _spirit_x + 6, _y + 11 + _bob, false);
        draw_set_alpha(1);
        draw_rectangle(_spirit_x - 2, _y - 7 + _bob, _spirit_x + 3, _y + 5 + _bob, false);
        draw_rectangle(_spirit_x, _y + 6 + _bob, _spirit_x + 5, _y + 10 + _bob, false);
    }

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_text_transformed(_menu_x + 3, _y + 3, opcoes[i], 1.55, 1.55, 0);
    draw_set_color(_selected ? make_color_rgb(241, 231, 188) : make_color_rgb(196, 192, 159));
    draw_text_transformed(_menu_x, _y, opcoes[i], 1.55, 1.55, 0);
}

draw_set_font(fnt_dialogo);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(157, 164, 137));
draw_text(24, _gui_h - 18, "W/S OU SETAS  -  ENTER PARA CONFIRMAR");

var _fade = clamp(1 - menu_time / 0.85, 0, 1);
if (_fade > 0) {
    draw_set_alpha(_fade);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}
draw_set_alpha(1);
draw_set_color(c_white);

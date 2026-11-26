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

// A sombra da interface se dissolve no cenario.
draw_set_alpha(0.54);
draw_set_colour(c_black);
draw_rectangle(0, 0, _gui_w * 0.29, _gui_h, false);
draw_set_alpha(1);
draw_primitive_begin(pr_trianglestrip);
draw_vertex_colour(_gui_w * 0.29, 0, c_black, 0.54);
draw_vertex_colour(_gui_w * 0.29, _gui_h, c_black, 0.54);
draw_vertex_colour(_gui_w * 0.58, 0, c_black, 0);
draw_vertex_colour(_gui_w * 0.58, _gui_h, c_black, 0);
draw_primitive_end();
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

// O heroi e desenhado com o sprite verdadeiro do jogo. Assim a cabeca de
// pedra e o corpo espiritual nunca parecem uma colagem diferente do gameplay.
var _hero_x = _gui_w * 0.835;
var _hero_y = _gui_h * 0.77 + sin(menu_time * 2.2) * 4;
var _hero_scale = min(_gui_w / 1366, _gui_h / 768) * 3.05;
gpu_set_blendmode(bm_add);
for (var _a = 0; _a < 5; _a++) {
    var _ay = _hero_y - 9 + _a * 16 + ((menu_time * (18 + _a * 2)) mod 22);
    draw_set_alpha(0.18 - _a * 0.018);
    draw_set_color(_accent);
    draw_circle(_hero_x + sin(menu_time * 3 + _a) * 12, _ay, 8 - _a, false);
}
gpu_set_blendmode(bm_normal);
draw_set_alpha(0.22);
draw_set_color(c_black);
draw_ellipse(_hero_x - 53, _hero_y - 8, _hero_x + 53, _hero_y + 13, false);
draw_set_alpha(1);
draw_sprite_ext(player_right_idle, 0, _hero_x, _hero_y, _hero_scale, _hero_scale, 0, c_white, 1);

// Logotipo entalhado numa placa antiga, com pixels, pedra e musgo.
draw_set_font(fnt_tutoras);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _tx = _gui_w * 0.055;
var _ty = _gui_h * 0.075;
var _ts = min(_gui_w / 1366, _gui_h / 768) * 3.85;
var _slab_x1 = _tx - 24;
var _slab_y1 = _ty - 18;
var _slab_x2 = _tx + 334;
var _slab_y2 = _ty + 184;
draw_set_alpha(0.82);
draw_set_color(make_color_rgb(9, 16, 12));
draw_rectangle(_slab_x1 + 8, _slab_y1 + 9, _slab_x2 + 8, _slab_y2 + 9, false);
draw_set_color(make_color_rgb(36, 45, 34));
draw_rectangle(_slab_x1 + 8, _slab_y1, _slab_x2 - 10, _slab_y2, false);
draw_rectangle(_slab_x1, _slab_y1 + 10, _slab_x2, _slab_y2 - 8, false);
draw_set_color(make_color_rgb(76, 76, 52));
draw_rectangle(_slab_x1 + 7, _slab_y1 + 7, _slab_x2 - 7, _slab_y2 - 7, true);
draw_set_color(_accent);
draw_rectangle(_slab_x1 + 18, _slab_y1 + 3, _slab_x1 + 93, _slab_y1 + 8, false);
draw_rectangle(_slab_x2 - 124, _slab_y2 - 7, _slab_x2 - 20, _slab_y2 - 2, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(7, 13, 10));
draw_text_transformed(_tx + 6, _ty + 6, "SPIRIT", _ts, _ts, 0);
draw_text_transformed(_tx + 6, _ty + 72, "AWAKEN", _ts, _ts, 0);
draw_set_color(_accent);
draw_text_transformed(_tx - 2, _ty - 2, "SPIRIT", _ts, _ts, 0);
draw_text_transformed(_tx - 2, _ty + 64, "AWAKEN", _ts, _ts, 0);
draw_set_color(make_color_rgb(230, 226, 196));
draw_text_transformed(_tx, _ty, "SPIRIT", _ts, _ts, 0);
draw_text_transformed(_tx, _ty + 66, "AWAKEN", _ts, _ts, 0);

// Galho/musgo decorativo sob o titulo.
draw_set_color(make_color_rgb(54, 69, 43));
draw_rectangle(_tx, _ty + 139, _tx + 268, _ty + 145, false);
draw_set_color(_accent);
draw_rectangle(_tx + 9, _ty + 136, _tx + 78, _ty + 140, false);
draw_rectangle(_tx + 101, _ty + 138, _tx + 181, _ty + 141, false);
draw_rectangle(_tx + 207, _ty + 135, _tx + 260, _ty + 140, false);
draw_set_font(fnt_dialogo);
draw_set_color(make_color_rgb(202, 204, 174));
draw_text(_tx, _ty + 153, "A NATUREZA VAI DESPERTAR");

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
draw_text(24, _gui_h - 18, controls_label(Bind.up) + "/" + controls_label(Bind.down) + " ESCOLHER   -   " + controls_label(Bind.confirm) + " CONFIRMAR");

var _fade = clamp(1 - menu_time / 0.85, 0, 1);
if (_fade > 0) {
    draw_set_alpha(_fade);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}
draw_set_alpha(1);
draw_set_color(c_white);

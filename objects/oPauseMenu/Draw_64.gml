if (pause_exit != 0) exit;

var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _cx = _w * 0.5;
var _cy = _h * 0.5;

if (surface_exists(tela)) draw_surface_stretched(tela, 0, 0, _w, _h);
draw_set_alpha(fade * 0.68);
draw_rectangle_colour(0, 0, _w, _h, make_color_rgb(18, 24, 16), make_color_rgb(10, 14, 9), c_black, make_color_rgb(28, 18, 10), false);

// Esporos espirituais mantem a tela viva mesmo com o jogo congelado.
for (var _p = 0; _p < 24; _p++) {
    var _px = (_p * 211 + sin(ui_time + _p) * 34) mod _w;
    var _py = (_p * 137 - ui_time * 22) mod _h;
    if (_py < 0) _py += _h;
    draw_set_alpha(fade * (0.25 + 0.25 * sin(ui_time * 2 + _p)));
    draw_set_colour((_p mod 3 == 0) ? make_color_rgb(194, 170, 91) : make_color_rgb(99, 153, 67));
    draw_circle(_px, _py, 2 + (_p mod 2), false);
}

draw_set_alpha(fade);
draw_set_font(fnt_tutoras);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _panel_w = min(650, _w * 0.7);
var _panel_h = min(520, _h * 0.76);
var _x1 = _cx - _panel_w * 0.5;
var _y1 = _cy - _panel_h * 0.5;
var _x2 = _cx + _panel_w * 0.5;
var _y2 = _cy + _panel_h * 0.5;
draw_set_colour(make_color_rgb(30, 21, 14));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_colour(make_color_rgb(112, 77, 42));
draw_rectangle(_x1 + 5, _y1 + 5, _x2 - 5, _y2 - 5, true);
draw_set_colour(make_color_rgb(48, 62, 33));
draw_rectangle(_x1 + 12, _y1 + 12, _x2 - 12, _y2 - 12, true);
draw_set_colour(make_color_rgb(142, 118, 62));
draw_line(_x1 + 35, _y1 + 104, _x2 - 35, _y1 + 104);

draw_set_colour(make_color_rgb(239, 224, 169));
draw_text_transformed(_cx, _y1 + 45, pagina == 0 ? "JOGO PAUSADO" : "OPCOES", 1.45, 1.45, 0);
draw_set_font(fnt_dialogo);
draw_set_colour(make_color_rgb(151, 171, 101));
draw_text(_cx, _y1 + 87, pagina == 0 ? "A FLORESTA ESPERA" : "AJUSTE SUA JORNADA");

var _labels;
if (pagina == 0) {
    _labels = ["RESUMIR", "OPCOES", "VOLTAR AO MENU"];
} else {
    var _res = lista_resolucoes[res_index];
    _labels = [
        "RESOLUCAO  " + string(_res[0]) + " X " + string(_res[1]),
        "TELA CHEIA  " + (fullscreen ? "LIGADO" : "DESLIGADO"),
        "VOLUME  " + string(volume_level) + "%",
        "VOLTAR"
    ];
}

var _count = array_length(_labels);
for (var _i = 0; _i < _count; _i++) {
    var _spacing = (pagina == 0) ? 86 : 70;
    var _yy = _y1 + 158 + _i * _spacing;
    var _sel = (_i == opcao);
    draw_set_colour(_sel ? make_color_rgb(78, 67, 35) : make_color_rgb(43, 34, 22));
    draw_rectangle(_cx - 250, _yy - 30, _cx + 250, _yy + 30, false);
    draw_set_colour(_sel ? make_color_rgb(206, 185, 104) : make_color_rgb(126, 119, 88));
    if (_sel) {
        draw_rectangle(_cx - 250, _yy - 30, _cx + 250, _yy + 30, true);
        draw_set_font(fnt_tutoras);
        draw_text_transformed(_cx - 220, _yy, ">", 1.05, 1.05, 0);
    }
    draw_set_font(fnt_tutoras);
    draw_set_colour(_sel ? make_color_rgb(242, 226, 170) : make_color_rgb(190, 181, 143));
    draw_text_transformed(_cx, _yy, _labels[_i], 1.05, 1.05, 0);

    if (pagina == 1 && _i == 2) {
        draw_set_colour(make_color_rgb(18, 31, 28));
        draw_rectangle(_cx - 150, _yy + 39, _cx + 150, _yy + 49, false);
        draw_set_colour(make_color_rgb(117, 158, 72));
        draw_rectangle(_cx - 150, _yy + 39, _cx - 150 + 300 * volume_level / 100, _yy + 49, false);
    }
}

draw_set_font(fnt_dialogo);
draw_set_colour(make_color_rgb(156, 149, 116));
draw_text(_cx, _y2 - 28, pagina == 0 ? "W/S  ESCOLHER   -   ENTER  CONFIRMAR   -   ESC  RESUMIR" : "A/D  ALTERAR   -   ESC  VOLTAR");
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _cx = _w * 0.5;
var _cy = _h * 0.5;

if (surface_exists(tela)) draw_surface_stretched(tela, 0, 0, _w, _h);

// Cartao de derrota antigo: vinheta, grao e moldura de tinta.
draw_set_alpha(fade * 0.72);
draw_rectangle_colour(0, 0, _w, _h, make_color_rgb(45, 5, 8), c_black, c_black, make_color_rgb(30, 2, 5), false);
draw_set_alpha(fade * 0.22);
for (var _g = 0; _g < 70; _g++) {
    var _gx = ((_g * 193 + current_time div 13) mod _w);
    var _gy = ((_g * 97  + current_time div 21) mod _h);
    draw_point(_gx, _gy);
}

draw_set_alpha(fade);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_tutoras);

var _pw = min(720, _w * 0.72);
var _ph = min(470, _h * 0.72);
var _x1 = _cx - _pw * 0.5;
var _y1 = _cy - _ph * 0.5;
var _x2 = _cx + _pw * 0.5;
var _y2 = _cy + _ph * 0.5;
draw_set_colour(make_color_rgb(23, 16, 11));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_colour(make_color_rgb(101, 72, 39));
draw_rectangle(_x1 + 8, _y1 + 8, _x2 - 8, _y2 - 8, true);
draw_set_colour(make_color_rgb(80, 39, 30));
draw_rectangle(_x1 + 14, _y1 + 14, _x2 - 14, _y2 - 14, true);

// Raizes e musgo tomam a moldura enquanto o espirito se dispersa.
draw_set_colour(make_color_rgb(67, 94, 45));
draw_rectangle(_x1 + 20, _y1 + 8, _x1 + 145, _y1 + 14, false);
draw_rectangle(_x2 - 172, _y2 - 15, _x2 - 26, _y2 - 9, false);
draw_rectangle(_x1 + 28, _y1 + 12, _x1 + 34, _y1 + 43, false);

var _wobble = sin(pulso) * 3;
draw_set_colour(c_black);
draw_text_transformed(_cx + 4, _cy - 132 + _wobble + 4, "ESPIRITO DISPERSO", 1.35, 1.35, 0);
draw_set_colour(make_color_rgb(202, 67, 48));
draw_text_transformed(_cx, _cy - 132 + _wobble, "ESPIRITO DISPERSO", 1.35, 1.35, 0);

draw_set_font(fnt_dialogo);
draw_set_colour(make_color_rgb(199, 190, 148));
draw_text(_cx, _cy - 78, eh_chefe ? "A LUTA AINDA NAO TERMINOU" : "A NATUREZA AINDA PRECISA DE VOCE");

var _labels = ["TENTAR NOVAMENTE", "VOLTAR AO MENU"];
for (var _i = 0; _i < 2; _i++) {
    var _yy = _cy + 20 + _i * 72;
    var _selected = (_i == opcao);
    draw_set_colour(_selected ? make_color_rgb(91, 54, 31) : make_color_rgb(39, 31, 22));
    draw_rectangle(_cx - 250, _yy - 25, _cx + 250, _yy + 25, false);
    if (_selected) {
        draw_set_colour(make_color_rgb(184, 167, 86));
        draw_set_font(fnt_tutoras);
        draw_text_transformed(_cx - 222, _yy, ">", 0.95, 0.95, 0);
        draw_text_transformed(_cx + 222, _yy, "<", 0.95, 0.95, 0);
    }
    draw_set_colour(_selected ? make_color_rgb(241, 224, 164) : make_color_rgb(174, 165, 131));
    draw_set_font(fnt_tutoras);
    draw_text_transformed(_cx, _yy, _labels[_i], 0.95, 0.95, 0);
}

draw_set_font(fnt_dialogo);
draw_set_colour(make_color_rgb(150, 142, 125));
draw_text(_cx, _y2 - 30, "W/S PARA ESCOLHER   -   ENTER PARA CONFIRMAR");
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

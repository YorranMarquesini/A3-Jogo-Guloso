var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _intro = clamp(timer / 35, 0, 1);
var _out = 1 - clamp((timer - 140) / 35, 0, 1);
var _a = min(_intro, _out);

draw_set_alpha(_a * 0.45);
draw_rectangle_colour(0, 0, _w, _h, make_color_rgb(0, 25, 19), make_color_rgb(0, 25, 19), c_black, c_black, false);

draw_set_alpha(_a);
draw_set_colour(c_black);
draw_rectangle(0, 0, _w, 62, false);
draw_rectangle(0, _h - 62, _w, _h, false);
draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_colour(make_color_rgb(102, 255, 179));
draw_text(_w * 0.5, 90, "FASE II");
draw_set_font(fnt_dialogo);
draw_set_colour(c_white);
draw_text(_w * 0.5, 128, "CICATRIZES DA INDUSTRIA");

// Faíscas descem junto do corpo espiritual.
for (var _i = 0; _i < 28; _i++) {
    var _px = (_w * 0.5) + sin(timer * 0.08 + _i * 2.3) * (35 + (_i mod 5) * 12);
    var _py = ((timer * 5 + _i * 71) mod max(1, _h - 150)) + 80;
    draw_set_alpha(_a * (0.25 + (_i mod 4) * 0.13));
    draw_set_colour((_i mod 3 == 0) ? c_aqua : c_lime);
    draw_circle(_px, _py, 1 + (_i mod 3), false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);

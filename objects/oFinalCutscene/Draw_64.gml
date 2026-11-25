var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _cx = _w * 0.5;
var _draw_cover = function(_spr, _zoom, _alpha) {
    if (!sprite_exists(_spr)) return;
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _sw = sprite_get_width(_spr);
    var _sh = sprite_get_height(_spr);
    var _sc = max(_gw / _sw, _gh / _sh) * _zoom;
    draw_sprite_ext(_spr, 0, (_gw - _sw * _sc) * 0.5, (_gh - _sh * _sc) * 0.5, _sc, _sc, 0, c_white, _alpha);
};
var _caption = function(_text, _alpha) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(_alpha * 0.82);
    draw_set_colour(make_color_rgb(2, 17, 15));
    draw_rectangle(_gw * 0.16, _gh - 160, _gw * 0.84, _gh - 72, false);
    draw_set_alpha(_alpha);
    draw_set_colour(make_color_rgb(68, 238, 150));
    draw_rectangle(_gw * 0.16, _gh - 160, _gw * 0.84, _gh - 154, false);
    draw_set_font(fnt_tutoras);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_black);
    draw_text(_gw * 0.5 + 3, _gh - 113 + 3, _text);
    draw_set_colour(make_color_rgb(237, 251, 229));
    draw_text(_gw * 0.5, _gh - 113, _text);
};

draw_clear(c_black);
if (timer < 330) {
    var _p1 = timer / 330;
    _draw_cover(factory_sprite, 1.05 + _p1 * 0.08, 1);
    draw_set_alpha((1 - _p1) * 0.32);
    draw_set_colour(make_color_rgb(45, 255, 145));
    for (var _r = 0; _r < 5; _r++) draw_circle(_cx, _h * 0.52, timer * (1.8 + _r * 0.3) - _r * 70, true);
    _caption("AS FABRICAS SILENCIARAM", clamp((timer - 35) / 45, 0, 1));
} else if (timer < 660) {
    var _p2 = (timer - 330) / 330;
    _draw_cover(forest_sprite, 1.09 - _p2 * 0.05, 1);
    if (timer < 380) _draw_cover(factory_sprite, 1.13, 1 - (timer - 330) / 50);
    _caption("A FLORESTA VOLTOU A RESPIRAR", clamp((timer - 370) / 45, 0, 1));
} else {
    var _p3 = (timer - 660) / 330;
    _draw_cover(animals_sprite, 1.04 + _p3 * 0.03, 1);
    if (timer < 710) _draw_cover(forest_sprite, 1.04, 1 - (timer - 660) / 50);
    var _py = _h * 0.64 + sin(timer * 0.06) * 4;
    for (var _s = 0; _s < 9; _s++) {
        var _st = _s / 8;
        var _rad = lerp(22, 3, _st);
        var _sy = _py + 62 - _st * 78;
        var _sx = _cx + sin(timer * 0.1 + _s) * (5 + _st * 7);
        draw_set_alpha(0.62 - _st * 0.24);
        draw_set_colour(merge_color(c_lime, c_aqua, _st));
        draw_ellipse(_sx - _rad, _sy - _rad * 0.28, _sx + _rad, _sy + _rad * 0.28, false);
    }
    draw_set_alpha(1);
    draw_sprite_ext(player_sprite, 0, _cx, _py - 40, 2.45, 2.45, 0, c_white, 1);
    _caption("E A VIDA FLORESCEU NOVAMENTE", clamp((timer - 700) / 45, 0, 1));
}

draw_set_alpha(1);
draw_set_colour(c_black);
draw_rectangle(0, 0, _w, 48, false);
draw_rectangle(0, _h - 48, _w, _h, false);
draw_set_font(fnt_dialogo);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
draw_set_colour(make_color_rgb(145, 177, 161));
draw_text(_w - 20, _h - 24, "ENTER PARA PULAR");
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(clamp((timer - 955) / 35, 0, 1));
draw_set_colour(c_black);
draw_rectangle(0, 0, _w, _h, false);
draw_set_alpha(1);
draw_set_colour(c_white);

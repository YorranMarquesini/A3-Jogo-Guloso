if (state != "cutscene" && !final_explosion_started) {
    var _w = 560;
    var _h = 22;
    var _x = (display_get_gui_width() - _w) * 0.5;
    var _y = 36;
    var _pct = clamp(hp / max_hp, 0, 1);

    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(_x - 4, _y - 4, _x + _w + 4, _y + _h + 4, false);
    draw_set_color(make_color_rgb(135, 15, 12));
    draw_rectangle(_x, _y, _x + _w * _pct, _y + _h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogo);
    draw_text(display_get_gui_width() * 0.5, _y - 6, (phase == 2) ? "CAGLIOSTRO - FASE 2" : "CAGLIOSTRO");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (final_explosion_started) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _p = 1 - clamp(final_explosion_timer / final_explosion_duration, 0, 1);
    var _cx = _gw * 0.72;
    var _cy = _gh * 0.50;
    draw_set_alpha(max(0, 0.94 - _p * 1.25));
    draw_set_colour(c_white);
    draw_rectangle(0, 0, _gw, _gh, false);
    for (var _r = 0; _r < 9; _r++) {
        var _radius = max(0, (_p * 980) - _r * 54);
        draw_set_alpha(max(0, (1 - _p) * (0.60 - _r * 0.045)));
        draw_set_colour(choose(c_white, c_yellow, c_orange, make_color_rgb(75, 255, 150)));
        draw_circle(_cx, _cy, _radius, true);
    }
    draw_set_alpha(clamp((_p - 0.68) / 0.32, 0, 1));
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

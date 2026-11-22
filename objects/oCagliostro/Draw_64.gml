if (state != "cutscene") {
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
    draw_text(display_get_gui_width() * 0.5, _y - 6, "CAGLIOSTRO");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

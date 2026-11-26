var _y = y + sin(current_time * 0.003 + x) * 6;
draw_set_alpha(1);
draw_set_color(make_color_rgb(23, 39, 32));
draw_circle(x, _y, 20, false);
draw_set_color(make_color_rgb(255, 221, 135));
draw_circle(x, _y, 20, true);
draw_set_font(fnt_tutoras);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, _y, "?");
if (near_player && !show_hint && !instance_exists(obj_dialogo)) {
    var _text = "[" + controls_label(Bind.interact) + "] Ler";
    var _half = string_width(_text) * 0.5 + 8;
    draw_set_color(c_black);
    draw_rectangle(x - _half, _y - 55, x + _half, _y - 24, false);
    draw_set_color(c_white);
    draw_text(x, _y - 39, _text);
}
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

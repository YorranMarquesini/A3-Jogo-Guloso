draw_self();

var _cx = x + sprite_width * abs(image_xscale) * 0.5;
var _top = y - 20;

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (player_near && !activated) {
    draw_set_alpha(0.86);
    draw_set_colour(c_black);
    draw_rectangle(_cx - 94, _top - 20, _cx + 94, _top + 20, false);
    draw_set_alpha(1);
    draw_set_colour(make_color_rgb(42, 92, 66));
    draw_rectangle(_cx - 94, _top - 20, _cx + 94, _top + 20, true);
    draw_set_colour(c_black);
    draw_text_transformed(_cx + 2, _top + 2, controls_label(Bind.interact) + " - LER PLACA", 1.08, 1.08, 0);
    draw_set_colour(make_color_rgb(222, 255, 214));
    draw_text_transformed(_cx, _top, controls_label(Bind.interact) + " - LER PLACA", 1.08, 1.08, 0);
}

if (message_timer > 0) {
    var _alpha = clamp(message_timer / 24, 0, 1);
    draw_set_alpha(_alpha);
    draw_set_colour(make_color_rgb(6, 24, 19));
    draw_rectangle(_cx - 240, _top - 120, _cx + 240, _top - 30, false);
    draw_set_colour(make_color_rgb(65, 134, 91));
    draw_rectangle(_cx - 240, _top - 120, _cx + 240, _top - 30, true);

    var _line_1_y = _top - 91;
    var _line_2_y = _top - 58;

    // Contorno em quatro direcoes: preserva o estilo pixelado e continua
    // legivel mesmo diante das areas claras do cenario.
    draw_set_colour(c_black);
    draw_text_transformed(_cx - 2, _line_1_y, message_line_1, 1.08, 1.08, 0);
    draw_text_transformed(_cx + 2, _line_1_y, message_line_1, 1.08, 1.08, 0);
    draw_text_transformed(_cx, _line_1_y - 2, message_line_1, 1.08, 1.08, 0);
    draw_text_transformed(_cx, _line_1_y + 2, message_line_1, 1.08, 1.08, 0);
    if (message_line_2 != "") {
        draw_text_transformed(_cx - 2, _line_2_y, message_line_2, 1.08, 1.08, 0);
        draw_text_transformed(_cx + 2, _line_2_y, message_line_2, 1.08, 1.08, 0);
        draw_text_transformed(_cx, _line_2_y - 2, message_line_2, 1.08, 1.08, 0);
        draw_text_transformed(_cx, _line_2_y + 2, message_line_2, 1.08, 1.08, 0);
    }

    draw_set_colour(make_color_rgb(224, 255, 225));
    draw_text_transformed(_cx, _line_1_y, message_line_1, 1.08, 1.08, 0);
    if (message_line_2 != "") {
        draw_text_transformed(_cx, _line_2_y, message_line_2, 1.08, 1.08, 0);
    }
    draw_set_alpha(1);
}

if (activated) {
    draw_set_colour(make_color_rgb(89, 255, 157));
    draw_circle(_cx, y + 6, 5 + sin(current_time * 0.008) * 1.5, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


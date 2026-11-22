draw_self();

// Rasgos ficam inteiramente dentro da copa/aba do chapéu. Cada corte recebe
// uma borda clara e um miolo escuro para parecer uma abertura no tecido.
if (hat_disabled_timer > 0 && state != "cutscene" && state != "dying") {
    var _sx = abs(image_xscale);
    var _sy = abs(image_yscale);
    var _hat_y = y - (35 * _sy);
    var _edge_width = max(3, 0.58 * _sx);
    var _gap_width = max(1, 0.24 * _sx);
    var _thread_width = max(1, 0.12 * _sx);

    draw_set_alpha(0.92);

    // Rasgo esquerdo: bordas irregulares do tecido.
    draw_line_width_color(x - 17 * _sx, _hat_y - 2 * _sy, x - 12 * _sx, _hat_y + 2 * _sy, _edge_width, c_gray, c_silver);
    draw_line_width_color(x - 12 * _sx, _hat_y + 2 * _sy, x - 8 * _sx, _hat_y - 3 * _sy, _edge_width, c_silver, c_gray);
    draw_line_width_color(x - 8 * _sx, _hat_y - 3 * _sy, x - 3 * _sx, _hat_y + 1 * _sy, _edge_width, c_gray, c_silver);
    draw_line_width_color(x - 17 * _sx, _hat_y - 2 * _sy, x - 12 * _sx, _hat_y + 2 * _sy, _gap_width, c_black, c_black);
    draw_line_width_color(x - 12 * _sx, _hat_y + 2 * _sy, x - 8 * _sx, _hat_y - 3 * _sy, _gap_width, c_black, c_black);
    draw_line_width_color(x - 8 * _sx, _hat_y - 3 * _sy, x - 3 * _sx, _hat_y + 1 * _sy, _gap_width, c_black, c_black);

    // Rasgo direito, em outra direção para não parecer um zigue-zague desenhado.
    draw_line_width_color(x + 2 * _sx, _hat_y - 4 * _sy, x + 6 * _sx, _hat_y + 1 * _sy, _edge_width, c_silver, c_gray);
    draw_line_width_color(x + 6 * _sx, _hat_y + 1 * _sy, x + 11 * _sx, _hat_y - 2 * _sy, _edge_width, c_gray, c_silver);
    draw_line_width_color(x + 11 * _sx, _hat_y - 2 * _sy, x + 16 * _sx, _hat_y + 2 * _sy, _edge_width, c_silver, c_gray);
    draw_line_width_color(x + 2 * _sx, _hat_y - 4 * _sy, x + 6 * _sx, _hat_y + 1 * _sy, _gap_width, c_black, c_black);
    draw_line_width_color(x + 6 * _sx, _hat_y + 1 * _sy, x + 11 * _sx, _hat_y - 2 * _sy, _gap_width, c_black, c_black);
    draw_line_width_color(x + 11 * _sx, _hat_y - 2 * _sy, x + 16 * _sx, _hat_y + 2 * _sy, _gap_width, c_black, c_black);

    // Poucos fios atravessando as aberturas reforçam a leitura de tecido.
    draw_line_width_color(x - 12.8 * _sx, _hat_y - 0.2 * _sy, x - 10.8 * _sx, _hat_y + 1.5 * _sy, _thread_width, c_white, c_silver);
    draw_line_width_color(x - 8.8 * _sx, _hat_y - 1.5 * _sy, x - 6.8 * _sx, _hat_y - 0.1 * _sy, _thread_width, c_silver, c_white);
    draw_line_width_color(x + 5.1 * _sx, _hat_y - 0.5 * _sy, x + 7.1 * _sx, _hat_y + 0.8 * _sy, _thread_width, c_white, c_silver);
    draw_line_width_color(x + 10.1 * _sx, _hat_y - 0.6 * _sy, x + 12.1 * _sx, _hat_y + 0.8 * _sy, _thread_width, c_silver, c_white);

    // Clarão curto da tesoura no momento do impacto.
    if (hat_cut_flash_timer > 0) {
        var _flash_alpha = hat_cut_flash_timer / hat_cut_flash_duration;
        draw_set_alpha(_flash_alpha);
        draw_line_width_color(x - 19 * _sx, _hat_y - 7 * _sy, x + 18 * _sx, _hat_y + 4 * _sy, max(4, 0.9 * _sx), c_white, c_silver);
        draw_set_alpha(_flash_alpha * 0.55);
        draw_line_width_color(x - 17 * _sx, _hat_y - 9 * _sy, x + 16 * _sx, _hat_y + 1 * _sy, max(2, 0.35 * _sx), c_aqua, c_white);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}

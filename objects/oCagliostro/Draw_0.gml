draw_self();

// Marcas procedurais de tecido rasgado sobre o chapéu. O sprite normal deixa
// o chapéu na cabeça; estas linhas mostram que ele está inutilizado por 30 s.
if (hat_disabled_timer > 0 && state != "cutscene" && state != "dying") {
    var _sx = abs(image_xscale);
    var _sy = abs(image_yscale);
    var _hat_y = y - (29 * _sy);
    var _line_width = max(2, 0.45 * _sx);

    draw_set_alpha(0.9);
    draw_line_width_color(x - 13 * _sx, _hat_y - 3 * _sy, x - 5 * _sx, _hat_y + 4 * _sy, _line_width, c_black, c_dkgray);
    draw_line_width_color(x - 5 * _sx, _hat_y + 4 * _sy, x + 1 * _sx, _hat_y - 2 * _sy, _line_width, c_dkgray, c_black);
    draw_line_width_color(x + 3 * _sx, _hat_y - 5 * _sy, x + 9 * _sx, _hat_y + 4 * _sy, _line_width, c_black, c_red);
    draw_line_width_color(x + 9 * _sx, _hat_y + 4 * _sy, x + 15 * _sx, _hat_y - 1 * _sy, _line_width, c_red, c_black);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

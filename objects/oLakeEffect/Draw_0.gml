var _surface = y;
var _bottom = y + lake_height;

// Corpo do lago poluido: verde profundo com sedimento marrom.
// O objeto fica atras do player; a transparencia preserva a leitura do cenário.
draw_set_alpha(0.82);
draw_set_colour(make_color_rgb(71, 115, 86));
draw_rectangle(x, _surface + 12, x + lake_width, _bottom, false);
draw_set_colour(make_color_rgb(49, 87, 72));
draw_rectangle(x, _surface + lake_height * 0.38, x + lake_width, _bottom, false);
draw_set_colour(make_color_rgb(32, 58, 52));
draw_rectangle(x, _surface + lake_height * 0.72, x + lake_width, _bottom, false);

// Superfície ondulando em blocos curtos.
draw_set_alpha(0.95);
for (var _wx = 0; _wx < lake_width; _wx += 24) {
    var _wave_y = _surface + 8 + sin(degtorad(wave_phase * 2 + _wx * 0.8)) * 6;
    draw_set_colour((_wx div 24) mod 2 == 0 ? make_color_rgb(145, 167, 103) : make_color_rgb(102, 143, 94));
    draw_rectangle(x + _wx, _wave_y, min(x + _wx + 18, x + lake_width), _wave_y + 5, false);
}

// Manchas de óleo/lodo flutuando próximas da superfície.
draw_set_alpha(0.76);
for (var _scum = 0; _scum < 9; _scum++) {
    var _sx = x + ((_scum * 139 + wave_phase * 0.22) mod lake_width);
    var _sy = _surface + 22 + sin(degtorad(wave_phase + _scum * 47)) * 4;
    draw_set_colour((_scum mod 2) == 0 ? make_color_rgb(91, 82, 45) : make_color_rgb(73, 99, 54));
    draw_ellipse(_sx - 18, _sy - 4, _sx + 22, _sy + 5, false);
}

// Reflexos horizontais e bolhas dão movimento sem poluir o cenário.
draw_set_alpha(0.45);
for (var _row = 0; _row < 6; _row++) {
    var _ry = _surface + 70 + _row * 82;
    var _offset = (wave_phase * (0.45 + _row * 0.05)) mod 150;
    for (var _rx = -100; _rx < lake_width; _rx += 150) {
        draw_set_colour(make_color_rgb(132, 158, 105));
        draw_rectangle(x + _rx + _offset, _ry, x + _rx + _offset + 54, _ry + 4, false);
    }
}

draw_set_alpha(0.7);
for (var _b = 0; _b < 12; _b++) {
    var _bx = x + ((_b * 97 + bubble_seed) mod max(1, lake_width - 20));
    var _by = _bottom - ((wave_phase * (0.7 + (_b mod 4) * 0.18) + _b * 53) mod max(1, lake_height - 45));
    var _br = 2 + (_b mod 3);
    draw_set_colour(make_color_rgb(184, 194, 132));
    draw_circle(_bx, _by, _br, true);
}

draw_set_alpha(1);
draw_set_colour(c_white);


var _l = bbox_left;
var _r = bbox_right;
var _t = bbox_top;
var _b = bbox_bottom;
var _pw = max(16, _r - _l);
var _pulse = 0.5 + sin(current_time * 0.006 + x * 0.025) * 0.5;

if (room == BossRoom) {
    // Cada ilha e sustentada por um unico geiser invocado pelo jogador:
    // base comprimida, jato ascendente e uma coroa de agua ao atingir a pedra.
    var _source_y = room_height + 20;
    var _center = (_l + _r) * 0.5;
    var _top_y = _b + 17;
    var _bottom_sway = sin(current_time * 0.004 + x * 0.013) * 10;
    var _top_sway = sin(current_time * 0.007 + y * 0.019) * 5;
    var _body_w = clamp(_pw * 0.20, 32, 58);
    var _crown_w = clamp(_pw * 0.68, 88, 170);
    var _bottom_x = _center + _bottom_sway;
    var _top_x = _center + _top_sway;

    // Halo espiritual verde envolve o jato, sem transformar a agua em energia solida.
    draw_set_alpha(0.14 + _pulse * 0.08);
    draw_line_width_color(_bottom_x, _source_y, _top_x, _top_y + 12, _body_w + 18,
        make_color_rgb(45, 255, 142), make_color_rgb(35, 220, 160));
    draw_set_alpha(0.62);
    draw_line_width_color(_bottom_x, _source_y, _top_x, _top_y + 12, _body_w,
        make_color_rgb(10, 92, 186), make_color_rgb(42, 198, 242));
    draw_set_alpha(0.78);
    draw_line_width_color(_bottom_x + 5, _source_y, _top_x + 2, _top_y + 12, max(5, _body_w * 0.18),
        make_color_rgb(70, 203, 255), c_white);

    // Filetes internos sobem em velocidades diferentes, reforcando o sentido do geiser.
    for (var _s = 0; _s < 4; _s++) {
        var _off = (_s - 1.5) * (_body_w * 0.18);
        var _wiggle = sin(current_time * (0.006 + _s * 0.0007) + _s * 2.1) * 5;
        draw_set_alpha(0.34 + (_s mod 2) * 0.12);
        draw_set_colour((_s mod 2) == 0 ? make_color_rgb(70, 230, 255) : make_color_rgb(35, 150, 230));
        draw_line(_bottom_x + _off - _wiggle, _source_y, _top_x + _off + _wiggle, _top_y + 16);
    }

    draw_self();

    // Coroa em formato de cogumelo, inspirada no efeito enviado: a agua abre
    // para os lados quando encontra a plataforma e respinga nas extremidades.
    draw_set_alpha(0.74);
    draw_set_colour(make_color_rgb(29, 150, 228));
    draw_triangle(_top_x, _top_y + 31, _top_x - _crown_w * 0.50, _top_y + 8, _top_x + _crown_w * 0.50, _top_y + 8, false);
    draw_set_colour(make_color_rgb(64, 213, 250));
    draw_circle(_top_x, _top_y + 8, clamp(_crown_w * 0.17, 15, 28), false);
    draw_circle(_top_x - _crown_w * 0.25, _top_y + 11, clamp(_crown_w * 0.11, 10, 20), false);
    draw_circle(_top_x + _crown_w * 0.25, _top_y + 11, clamp(_crown_w * 0.11, 10, 20), false);
    draw_set_alpha(0.78);
    draw_set_colour(make_color_rgb(174, 247, 255));
    draw_line(_top_x - _crown_w * 0.36, _top_y + 4, _top_x + _crown_w * 0.36, _top_y + 4);
    draw_line(_top_x - _crown_w * 0.20, _top_y + 10, _top_x + _crown_w * 0.18, _top_y + 10);

    // Respingo lateral e gotas que sobem ao redor do impacto.
    for (var _d = 0; _d < 8; _d++) {
        var _side = ((_d mod 2) == 0) ? -1 : 1;
        var _rank = floor(_d * 0.5);
        var _phase = (current_time * 0.00045 + _rank * 0.23) mod 1;
        var _dx = _top_x + _side * (_crown_w * (0.28 + _phase * 0.22));
        var _dy = _top_y + 14 - sin(_phase * pi) * (25 + _rank * 5);
        draw_set_alpha(0.70 * (1 - _phase * 0.45));
        draw_set_colour((_rank mod 2) == 0 ? c_aqua : make_color_rgb(82, 255, 183));
        draw_circle(_dx, _dy, 2 + (_rank mod 3), false);
    }

    // A borda verde deixa claro que o geiser esta sendo mantido pelo espirito.
    draw_set_alpha(0.58 + _pulse * 0.22);
    draw_set_colour(make_color_rgb(74, 255, 158));
    draw_line(_top_x - _crown_w * 0.52, _top_y + 2, _top_x + _crown_w * 0.52, _top_y + 2);
    draw_set_alpha(0.28 + _pulse * 0.15);
    draw_circle(_top_x - _crown_w * 0.52, _top_y + 2, 5 + _pulse * 2, false);
    draw_circle(_top_x + _crown_w * 0.52, _top_y + 2, 5 + _pulse * 2, false);
} else {
    draw_self();

    if (room == Fase2Boss) {
        // Na fabrica nao ha lago: as plataformas ficam presas por telecinese pura.
        draw_set_alpha(0.22 + _pulse * 0.12);
        draw_set_colour(make_color_rgb(50, 255, 150));
        draw_rectangle(_l - 8, _t - 8, _r + 8, _b + 8, true);
        draw_set_alpha(0.75);
        var _c = make_color_rgb(74, 255, 174);
        draw_set_colour(_c);
        draw_line(_l - 12, _t - 5, _l + 12, _t - 5);
        draw_line(_r - 12, _t - 5, _r + 12, _t - 5);
        draw_line(_l - 12, _b + 5, _l + 12, _b + 5);
        draw_line(_r - 12, _b + 5, _r + 12, _b + 5);
        for (var _j = 0; _j < 5; _j++) {
            var _ang = current_time * 0.08 + _j * 72;
            var _cx = (_l + _r) * 0.5 + lengthdir_x((_r - _l) * 0.55, _ang);
            var _cy = (_t + _b) * 0.5 + lengthdir_y(18 + _pulse * 7, _ang);
            draw_set_alpha(0.42 + _pulse * 0.38);
            draw_circle(_cx, _cy, 2 + (_j mod 2), false);
        }
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);

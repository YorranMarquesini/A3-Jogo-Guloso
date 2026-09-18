var _t = 1 - (timer / duration); // 0 no início, 1 no fim
var _ease = 1 - power(1 - _t, 2); // ease-out: expande rápido, desacelera
var _ring_radius = lerp(2, max_radius, _ease);
var _alpha = (1 - _t) * 0.9;

// --- ANEL ACHATADO (tipo "portal" horizontal) ---
draw_set_alpha(_alpha);
draw_set_color(color_b);
draw_ellipse(x - _ring_radius, y - _ring_radius * 0.35, x + _ring_radius, y + _ring_radius * 0.35, true);

// --- ESPIGÕES IRRADIANDO ---
for (var _i = 0; _i < spike_count; _i++) {
    var _ang = (_i / spike_count) * 360 + (_i * 7);
    var _spike_len = lerp(max_radius * 0.9, 2, _t); // encolhe conforme desaparece

    var _sx1 = x + lengthdir_x(_ring_radius * 0.6, _ang);
    var _sy1 = y + lengthdir_y(_ring_radius * 0.6, _ang) * 0.35;
    var _sx2 = x + lengthdir_x(_ring_radius * 0.6 + _spike_len, _ang);
    var _sy2 = y + lengthdir_y(_ring_radius * 0.6 + _spike_len, _ang) * 0.35;

    draw_set_color(_i mod 2 == 0 ? color_a : color_b);
    draw_line_width(_sx1, _sy1, _sx2, _sy2, 2);
}

draw_set_alpha(1);
draw_set_color(c_white);
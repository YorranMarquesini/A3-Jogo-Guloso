var _pollution = clamp(global.pollution_pct / 100, 0, 1);
var _purified = 1 - _pollution;
var _state_color = merge_color(c_red, c_lime, _purified);

// Fundo verde: conforme a faixa vermelha diminui, a área purificada aparece.
draw_set_alpha(0.9);
draw_set_color(c_black);
draw_rectangle(bar_x - 3, bar_y - 3, bar_x + bar_width + 3, bar_y + bar_height + 3, false);

draw_set_color(make_color_rgb(20, 125, 45));
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

// Parte que ainda está poluída. Ela encolhe a cada coletável.
if (_pollution > 0) {
    draw_set_color(_state_color);
    draw_rectangle(bar_x, bar_y, bar_x + bar_width * _pollution, bar_y + bar_height, false);
}

draw_set_alpha(1);
draw_set_color(_state_color);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
var _boss_speed = scr_get_pollution_speed_bonus(global.pollution_pct);
draw_text(
    bar_x,
    bar_y - 3,
    "POLUICAO " + string(round(global.pollution_pct))
    + "%   BOSS " + string_format(_boss_speed, 1, 2) + "x"
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);

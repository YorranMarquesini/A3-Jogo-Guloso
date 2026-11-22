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
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);

// Texto dentro da própria barra, usando a mesma fonte do menu.
var _label = "POLUICAO " + string(round(global.pollution_pct)) + "%";
var _text_x = bar_x + bar_width * 0.5;
var _text_y = bar_y + bar_height * 0.5;

draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Sombra curta para continuar legível tanto no vermelho quanto no verde.
draw_set_color(c_black);
draw_text(_text_x + 2, _text_y + 2, _label);
draw_set_color(c_white);
draw_text(_text_x, _text_y, _label);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);

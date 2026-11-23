var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _accent = menu_accent[menu_variant];

// Fundo cinematografico com respiracao e deslocamento quase imperceptiveis.
if (sprite_exists(menu_background)) {
    var _sw = sprite_get_width(menu_background);
    var _sh = sprite_get_height(menu_background);
    var _zoom = max(_gui_w / _sw, _gui_h / _sh) * (1.025 + sin(menu_time * 0.35) * 0.004);
    var _dw = _sw * _zoom;
    var _dh = _sh * _zoom;
    var _bx = (_gui_w - _dw) * 0.5 + sin(menu_time * 0.18) * 5;
    var _by = (_gui_h - _dh) * 0.5 + cos(menu_time * 0.21) * 3;
    draw_sprite_ext(menu_background, 0, _bx, _by, _zoom, _zoom, 0, c_white, 1);
}

// Vinheta em camadas: preserva a arte e da leitura ao titulo.
draw_set_alpha(0.72);
draw_rectangle_color(0, 0, _gui_w * 0.43, _gui_h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(0.32);
draw_rectangle_color(_gui_w * 0.43, 0, _gui_w * 0.60, _gui_h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(0.22);
draw_rectangle_color(0, 0, _gui_w, 64, c_black, c_black, c_black, c_black, false);
draw_rectangle_color(0, _gui_h - 70, _gui_w, _gui_h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

// Pequenos motes espirituais; as posicoes se repetem de modo suave.
for (var p = 0; p < 18; p++) {
    var _px = ((_gui_w * 0.47) + p * 83) mod _gui_w;
    var _py = _gui_h + 80 - ((menu_time * (11 + (p mod 5) * 3) + p * 71) mod (_gui_h + 150));
    var _pa = 0.18 + 0.32 * (0.5 + 0.5 * sin(menu_time * 1.7 + p));
    var _ps = 2 + (p mod 3);
    draw_set_alpha(_pa);
    draw_set_color(_accent);
    draw_rectangle(_px, _py, _px + _ps, _py + _ps, false);
}
draw_set_alpha(1);

// Titulo com sombra pixelada, contorno verde e luz interna.
draw_set_font(fnt_menu);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _title_x = _gui_w * 0.055;
var _title_y = _gui_h * 0.085;
var _title_scale = min(_gui_w / 1366, _gui_h / 768) * 2.15;
var _glow = 0.55 + 0.15 * sin(menu_time * 1.5);

draw_set_color(c_black);
draw_text_transformed(_title_x + 8, _title_y + 10, "SPIRIT", _title_scale, _title_scale, 0);
draw_text_transformed(_title_x + 8, _title_y + 80, "AWAKEN", _title_scale, _title_scale, 0);
draw_set_alpha(_glow);
draw_set_color(_accent);
draw_text_transformed(_title_x - 3, _title_y - 2, "SPIRIT", _title_scale, _title_scale, 0);
draw_text_transformed(_title_x - 3, _title_y + 68, "AWAKEN", _title_scale, _title_scale, 0);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text_transformed(_title_x, _title_y, "SPIRIT", _title_scale, _title_scale, 0);
draw_text_transformed(_title_x, _title_y + 70, "AWAKEN", _title_scale, _title_scale, 0);

draw_set_color(_accent);
draw_rectangle(_title_x, _title_y + 160, _title_x + 255, _title_y + 164, false);
draw_set_font(fnt_dialogo);
draw_set_color(make_color_rgb(210, 225, 211));
draw_text(_title_x, _title_y + 174, "A NATUREZA VAI DESPERTAR");

// Botoes pixelados com brilho espiritual na selecao.
var _menu_x = _gui_w * 0.185;
var _menu_y = _gui_h * 0.605;
var _espaco = max(50, _gui_h * 0.072);
draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = 0; i < total_opcoes; i++) {
    var _pos_y = _menu_y + (i * _espaco);
    var _selected = (i == opcao_selecionada);
    var _pulse = _selected ? (0.82 + sin(menu_time * 5) * 0.08) : 0.58;
    var _half_w = largura_opcao * 0.5 + (_selected ? 8 : 0);
    var _half_h = altura_opcao * 0.5;

    draw_set_alpha(_pulse);
    draw_set_color(c_black);
    draw_rectangle(_menu_x - _half_w - 4, _pos_y - _half_h - 4, _menu_x + _half_w + 4, _pos_y + _half_h + 4, false);
    draw_set_alpha(_selected ? 0.90 : 0.68);
    draw_set_color(make_color_rgb(24, 31, 29));
    draw_rectangle(_menu_x - _half_w, _pos_y - _half_h, _menu_x + _half_w, _pos_y + _half_h, false);
    draw_set_alpha(_selected ? 1 : 0.42);
    draw_set_color(_selected ? _accent : make_color_rgb(112, 128, 118));
    draw_rectangle(_menu_x - _half_w, _pos_y - _half_h, _menu_x + _half_w, _pos_y - _half_h + 3, false);
    draw_rectangle(_menu_x - _half_w, _pos_y + _half_h - 3, _menu_x + _half_w, _pos_y + _half_h, false);

    if (_selected) {
        var _arrow_x = _menu_x - _half_w - 24 - sin(menu_time * 5) * 4;
        draw_rectangle(_arrow_x, _pos_y - 4, _arrow_x + 8, _pos_y + 4, false);
        draw_rectangle(_arrow_x + 8, _pos_y - 2, _arrow_x + 14, _pos_y + 2, false);
    }

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_text(_menu_x + 3, _pos_y + 3, opcoes[i]);
    draw_set_color(_selected ? c_white : make_color_rgb(196, 202, 194));
    draw_text(_menu_x, _pos_y, opcoes[i]);
}

draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_font(fnt_dialogo);
draw_set_color(make_color_rgb(170, 184, 175));
draw_text(24, _gui_h - 18, "W/S OU SETAS  -  ENTER PARA CONFIRMAR");

// Fade inicial esconde o carregamento dos PNGs e revela a tela suavemente.
var _fade = clamp(1 - menu_time / 0.85, 0, 1);
if (_fade > 0) {
    draw_set_alpha(_fade);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx = _gui_w * 0.5;

// Mesmo fundo sorteado da tela inicial, com movimento discreto.
if (sprite_exists(ui_background)) {
    var _sw = sprite_get_width(ui_background);
    var _sh = sprite_get_height(ui_background);
    var _zoom = max(_gui_w / _sw, _gui_h / _sh) * (1.03 + sin(ui_time * 0.3) * 0.004);
    var _dw = _sw * _zoom;
    var _dh = _sh * _zoom;
    draw_sprite_ext(ui_background, 0, (_gui_w - _dw) * 0.5 + sin(ui_time * 0.2) * 4,
        (_gui_h - _dh) * 0.5, _zoom, _zoom, 0, c_white, 1);
}

draw_set_alpha(0.64);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Painel principal em camadas, inspirado em pedra escura e energia espiritual.
draw_set_alpha(0.86);
draw_set_color(make_color_rgb(11, 19, 18));
draw_rectangle(_cx - 365, 112, _cx + 365, _gui_h - 72, false);
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(_cx - 369, 108, _cx + 369, _gui_h - 68, true);
draw_set_color(ui_accent);
draw_rectangle(_cx - 365, 112, _cx + 365, 116, false);
draw_rectangle(_cx - 365, _gui_h - 76, _cx + 365, _gui_h - 72, false);

// Titulo.
draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_text_transformed(_cx + 4, 42 + 5, "OPCOES", 1.8, 1.8, 0);
draw_set_alpha(0.65 + sin(ui_time * 1.8) * 0.12);
draw_set_color(ui_accent);
draw_text_transformed(_cx - 2, 40, "OPCOES", 1.8, 1.8, 0);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text_transformed(_cx, 42, "OPCOES", 1.8, 1.8, 0);

draw_set_font(fnt_dialogo);
draw_set_color(make_color_rgb(190, 210, 198));
draw_text(_cx, 91, "AJUSTE SUA EXPERIENCIA");

var _base_y = _gui_h * 0.40;
var _espaco = _gui_h * 0.105;
var _barra_w = 260;
var _barra_h = 20;
var _x_barra = _cx - 70;

draw_set_font(fnt_menu);
draw_set_valign(fa_middle);
for (var i = 0; i < total_opcoes; i++) {
    var _pos_y = _base_y + i * _espaco;
    var _selected = (i == opcao_selecionada);
    var _half_w = largura_opcao * 0.5 + (_selected ? 6 : 0);
    var _half_h = altura_opcao * 0.5;

    draw_set_alpha(_selected ? 0.88 : 0.46);
    draw_set_color(make_color_rgb(27, 38, 35));
    draw_rectangle(_cx - _half_w, _pos_y - _half_h, _cx + _half_w, _pos_y + _half_h, false);
    draw_set_alpha(_selected ? 1 : 0.32);
    draw_set_color(_selected ? ui_accent : make_color_rgb(105, 126, 113));
    draw_rectangle(_cx - _half_w, _pos_y - _half_h, _cx + _half_w, _pos_y - _half_h + 3, false);
    draw_rectangle(_cx - _half_w, _pos_y + _half_h - 3, _cx + _half_w, _pos_y + _half_h, false);
    draw_set_alpha(1);

    if (_selected) {
        var _marker_x = _cx - _half_w - 22 - sin(ui_time * 5) * 3;
        draw_rectangle(_marker_x, _pos_y - 5, _marker_x + 12, _pos_y + 5, false);
    }

    draw_set_color(_selected ? c_white : make_color_rgb(198, 207, 201));
    if (i == 0) {
        var _res = lista_resolucoes[res_index];
        draw_set_halign(fa_left);
        draw_text(_cx - 270, _pos_y, "RESOLUCAO");
        draw_set_halign(fa_right);
        draw_set_color(_selected ? ui_accent : c_white);
        draw_text(_cx + 270, _pos_y, string(_res[0]) + " x " + string(_res[1]));
    } else if (i == 1) {
        draw_set_halign(fa_left);
        draw_text(_cx - 270, _pos_y, "TELA CHEIA");
        draw_set_halign(fa_right);
        draw_set_color(_selected ? ui_accent : c_white);
        draw_text(_cx + 270, _pos_y, fullscreen ? "LIGADO" : "DESLIGADO");
    } else if (i == 2) {
        draw_set_halign(fa_left);
        draw_text(_cx - 270, _pos_y, "VOLUME");
        draw_set_color(make_color_rgb(8, 13, 12));
        draw_rectangle(_x_barra, _pos_y - _barra_h * 0.5, _x_barra + _barra_w, _pos_y + _barra_h * 0.5, false);
        draw_set_color(ui_accent);
        draw_rectangle(_x_barra + 3, _pos_y - _barra_h * 0.5 + 3,
            _x_barra + 3 + (_barra_w - 6) * volume_level / 100,
            _pos_y + _barra_h * 0.5 - 3, false);
        draw_set_color(c_white);
        draw_rectangle(_x_barra, _pos_y - _barra_h * 0.5, _x_barra + _barra_w, _pos_y + _barra_h * 0.5, true);
        draw_set_halign(fa_right);
        draw_text(_cx + 270, _pos_y, string(volume_level) + "%");
    } else {
        draw_set_halign(fa_center);
        draw_text(_cx, _pos_y, "VOLTAR");
    }
}

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(166, 183, 172));
draw_text(_cx, _gui_h - 22, "A/D OU SETAS PARA ALTERAR   -   ESC PARA VOLTAR");
draw_set_alpha(1);
draw_set_color(c_white);

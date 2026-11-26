if (bindings_open) { controls_editor_draw(); exit; }
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx = _gui_w * 0.5;

if (sprite_exists(ui_background)) {
    var _sw = sprite_get_width(ui_background);
    var _sh = sprite_get_height(ui_background);
    var _zoom = max(_gui_w / _sw, _gui_h / _sh) * (1.03 + sin(ui_time * 0.3) * 0.004);
    var _dw = _sw * _zoom;
    var _dh = _sh * _zoom;
    draw_sprite_ext(ui_background, 0, (_gui_w - _dw) * 0.5 + sin(ui_time * 0.2) * 4,
        (_gui_h - _dh) * 0.5, _zoom, _zoom, 0, c_white, 1);
}

draw_set_alpha(0.38);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Tabua de pedra antiga com borda grossa, musgo e cantos quebrados.
var _x1 = _cx - 350;
var _x2 = _cx + 350;
var _y1 = 126;
var _y2 = _gui_h - 68;
var _stone0 = make_color_rgb(22, 27, 24);
var _stone1 = make_color_rgb(45, 49, 41);
var _stone2 = make_color_rgb(70, 70, 53);

draw_set_alpha(0.88);
draw_set_color(c_black);
draw_rectangle(_x1 + 9, _y1 + 12, _x2 + 11, _y2 + 12, false);
draw_set_color(_stone0);
draw_rectangle(_x1 + 8, _y1 - 8, _x2 - 8, _y2 + 8, false);
draw_rectangle(_x1 - 8, _y1 + 8, _x2 + 8, _y2 - 8, false);
draw_set_color(_stone1);
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_color(_stone2);
draw_rectangle(_x1 + 7, _y1 + 7, _x2 - 7, _y1 + 11, false);
draw_rectangle(_x1 + 7, _y1 + 7, _x1 + 11, _y2 - 7, false);
draw_set_color(make_color_rgb(15, 20, 18));
draw_rectangle(_x1 + 14, _y1 + 16, _x2 - 14, _y2 - 14, false);
draw_set_alpha(1);

// Musgo quebrado sobre a moldura.
draw_set_color(ui_accent);
draw_rectangle(_x1 + 18, _y1 - 10, _x1 + 102, _y1 - 5, false);
draw_rectangle(_x1 + 49, _y1 - 5, _x1 + 137, _y1, false);
draw_rectangle(_x2 - 152, _y1 - 9, _x2 - 48, _y1 - 4, false);
draw_rectangle(_x2 - 82, _y1 - 4, _x2 - 22, _y1 + 1, false);
draw_set_color(make_color_rgb(55, 83, 48));
draw_rectangle(_x1 + 23, _y1, _x1 + 29, _y1 + 21, false);
draw_rectangle(_x2 - 64, _y1, _x2 - 58, _y1 + 17, false);

// Titulo de bitmap, sem contorno neon.
draw_set_font(fnt_tutoras);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_text_transformed(_cx + 6, 43 + 6, "OPCOES", 3.35, 3.35, 0);
draw_set_color(ui_accent);
draw_text_transformed(_cx - 2, 41 - 2, "OPCOES", 3.35, 3.35, 0);
draw_set_color(make_color_rgb(235, 225, 185));
draw_text_transformed(_cx, 43, "OPCOES", 3.35, 3.35, 0);
draw_set_font(fnt_dialogo);
draw_set_color(make_color_rgb(171, 178, 145));
draw_text(_cx, 96, "AJUSTE SUA EXPERIENCIA");

var _base_y = _gui_h * 0.40;
var _espaco = _gui_h * 0.105;
var _barra_w = 260;
var _barra_h = 20;
var _x_barra = _cx - 70;

draw_set_font(fnt_tutoras);
draw_set_valign(fa_middle);
for (var i = 0; i < total_opcoes; i++) {
    var _y = _base_y + i * _espaco;
    var _selected = (i == opcao_selecionada);
    var _hw = 286 + (_selected ? 7 : 0);
    var _hh = 27;

    draw_set_alpha(_selected ? 0.96 : 0.74);
    draw_set_color(make_color_rgb(29, 35, 30));
    draw_rectangle(_cx - _hw + 6, _y - _hh, _cx + _hw - 6, _y + _hh, false);
    draw_rectangle(_cx - _hw, _y - _hh + 6, _cx + _hw, _y + _hh - 6, false);
    draw_set_color(_selected ? make_color_rgb(62, 67, 47) : make_color_rgb(43, 47, 39));
    draw_rectangle(_cx - _hw + 6, _y - _hh + 7, _cx + _hw - 6, _y + _hh - 7, false);
    draw_set_alpha(1);

    draw_set_color(_selected ? ui_accent : make_color_rgb(74, 84, 61));
    draw_rectangle(_cx - _hw + 15, _y - _hh + 2, _cx - _hw + 80, _y - _hh + 6, false);
    draw_rectangle(_cx + _hw - 116, _y - _hh + 2, _cx + _hw - 18, _y - _hh + 6, false);

    if (_selected) {
        var _mx = _cx - _hw - 20;
        var _bob = sin(ui_time * 6) * 3;
        draw_set_color(ui_accent);
        draw_rectangle(_mx - 2, _y - 8 + _bob, _mx + 3, _y + 5 + _bob, false);
        draw_rectangle(_mx, _y + 6 + _bob, _mx + 5, _y + 10 + _bob, false);
    }

    draw_set_color(_selected ? make_color_rgb(239, 228, 186) : make_color_rgb(188, 188, 155));
    if (i == 0) {
        var _res = lista_resolucoes[res_index];
        draw_set_halign(fa_left);
        draw_text_transformed(_cx - 255, _y, "RESOLUCAO", 1.35, 1.35, 0);
        draw_set_halign(fa_right);
        draw_set_color(_selected ? ui_accent : make_color_rgb(211, 207, 173));
        draw_text_transformed(_cx + 255, _y, string(_res[0]) + " x " + string(_res[1]), 1.35, 1.35, 0);
    } else if (i == 1) {
        draw_set_halign(fa_left);
        draw_text_transformed(_cx - 255, _y, "TELA CHEIA", 1.35, 1.35, 0);
        draw_set_halign(fa_right);
        draw_set_color(_selected ? ui_accent : make_color_rgb(211, 207, 173));
        draw_text_transformed(_cx + 255, _y, fullscreen ? "LIGADO" : "DESLIGADO", 1.35, 1.35, 0);
    } else if (i == 2) {
        draw_set_halign(fa_left);
        draw_text_transformed(_cx - 255, _y, "VOLUME", 1.35, 1.35, 0);
        draw_set_color(make_color_rgb(11, 16, 13));
        draw_rectangle(_x_barra - 3, _y - _barra_h * 0.5 - 3, _x_barra + _barra_w + 3, _y + _barra_h * 0.5 + 3, false);
        draw_set_color(make_color_rgb(63, 67, 48));
        draw_rectangle(_x_barra, _y - _barra_h * 0.5, _x_barra + _barra_w, _y + _barra_h * 0.5, false);
        draw_set_color(ui_accent);
        draw_rectangle(_x_barra + 4, _y - _barra_h * 0.5 + 4,
            _x_barra + 4 + (_barra_w - 8) * volume_level / 100,
            _y + _barra_h * 0.5 - 4, false);
        draw_set_halign(fa_right);
        draw_set_color(make_color_rgb(225, 218, 181));
        draw_text_transformed(_cx + 255, _y, string(volume_level) + "%", 1.35, 1.35, 0);
    } else {
        draw_set_halign(fa_center);
        draw_text_transformed(_cx, _y, string_upper(opcoes[i]), 1.35, 1.35, 0);
    }
}

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(make_color_rgb(151, 159, 130));
draw_text(_cx, _gui_h - 22, controls_label(Bind.left) + "/" + controls_label(Bind.right) + " ALTERAR   -   " + controls_label(Bind.back) + " VOLTAR");
draw_set_alpha(1);
draw_set_color(c_white);

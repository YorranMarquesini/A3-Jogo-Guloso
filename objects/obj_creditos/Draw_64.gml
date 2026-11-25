var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx = _gui_w * 0.5;

if (sprite_exists(ui_background)) {
    var _sw = sprite_get_width(ui_background);
    var _sh = sprite_get_height(ui_background);
    var _zoom = max(_gui_w / _sw, _gui_h / _sh) * (1.035 + sin(ui_time * 0.28) * 0.004);
    var _dw = _sw * _zoom;
    var _dh = _sh * _zoom;
    draw_sprite_ext(ui_background, 0, (_gui_w - _dw) * 0.5 + cos(ui_time * 0.18) * 4,
        (_gui_h - _dh) * 0.5, _zoom, _zoom, 0, c_white, 1);
}

draw_set_alpha(0.40);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Estela antiga: menor, irregular e integrada ao templo.
var _x1 = _cx - 330;
var _x2 = _cx + 330;
var _y1 = 126;
var _y2 = _gui_h - 62;
draw_set_alpha(0.90);
draw_set_color(c_black);
draw_rectangle(_x1 + 10, _y1 + 12, _x2 + 12, _y2 + 12, false);
draw_set_color(make_color_rgb(24, 29, 25));
draw_rectangle(_x1 + 8, _y1 - 8, _x2 - 8, _y2 + 8, false);
draw_rectangle(_x1 - 8, _y1 + 8, _x2 + 8, _y2 - 8, false);
draw_set_color(make_color_rgb(49, 51, 42));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_color(make_color_rgb(78, 74, 54));
draw_rectangle(_x1 + 7, _y1 + 7, _x2 - 7, _y1 + 11, false);
draw_rectangle(_x1 + 7, _y1 + 7, _x1 + 11, _y2 - 7, false);
draw_set_color(make_color_rgb(13, 19, 16));
draw_rectangle(_x1 + 15, _y1 + 17, _x2 - 15, _y2 - 15, false);
draw_set_alpha(1);

// Musgo e pequenas raizes sobre a borda.
draw_set_color(ui_accent);
draw_rectangle(_x1 + 22, _y1 - 10, _x1 + 114, _y1 - 5, false);
draw_rectangle(_x1 + 70, _y1 - 5, _x1 + 167, _y1, false);
draw_rectangle(_x2 - 139, _y1 - 8, _x2 - 25, _y1 - 3, false);
draw_set_color(make_color_rgb(51, 79, 45));
draw_rectangle(_x1 + 35, _y1, _x1 + 41, _y1 + 19, false);
draw_rectangle(_x2 - 96, _y1, _x2 - 90, _y1 + 24, false);

draw_set_font(fnt_tutoras);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_text_transformed(_cx + 6, 43 + 6, "CREDITOS", 3.15, 3.15, 0);
draw_set_color(ui_accent);
draw_text_transformed(_cx - 2, 41 - 2, "CREDITOS", 3.15, 3.15, 0);
draw_set_color(make_color_rgb(235, 225, 185));
draw_text_transformed(_cx, 43, "CREDITOS", 3.15, 3.15, 0);

// Conteudo rolante com hierarquia de fonte de bitmap.
var _y = pos_y;
var _clip_top = 194;
var _clip_bottom = _gui_h - 126;
for (var s = 0; s < array_length(credit_sections); s++) {
    var _section = credit_sections[s];
    draw_set_font(fnt_tutoras);
    draw_set_color(ui_accent);
    if (_y >= _clip_top - 34 && _y <= _clip_bottom) {
        draw_text_transformed(_cx, _y, _section[0], 1.18, 1.18, 0);
    }
    _y += 50;
    draw_set_font(fnt_dialogo);
    draw_set_color(make_color_rgb(218, 213, 178));
    var _people = _section[1];
    for (var n = 0; n < array_length(_people); n++) {
        if (_y >= _clip_top && _y <= _clip_bottom) draw_text(_cx, _y, _people[n]);
        _y += 36;
    }
    _y += 62;
}

draw_set_font(fnt_tutoras);
draw_set_color(make_color_rgb(234, 224, 184));
if (_y >= _clip_top - 34 && _y <= _clip_bottom) {
    draw_text_transformed(_cx, _y, "SPIRIT AWAKEN", 1.22, 1.22, 0);
}
_y += 51;
draw_set_color(ui_accent);
if (_y >= _clip_top - 30 && _y <= _clip_bottom) {
    draw_text_transformed(_cx, _y, "OBRIGADO POR JOGAR", 0.94, 0.94, 0);
}

// Pedra opaca mascara a rolagem no topo e no rodape.
draw_set_alpha(0.98);
draw_set_color(make_color_rgb(13, 19, 16));
draw_rectangle(_x1 + 15, _y1 + 16, _x2 - 15, 184, false);
draw_rectangle(_x1 + 15, _gui_h - 116, _x2 - 15, _y2 - 15, false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(63, 72, 50));
draw_rectangle(_x1 + 35, 181, _x2 - 35, 186, false);
draw_set_color(ui_accent);
draw_rectangle(_x1 + 52, 179, _x1 + 166, 183, false);
draw_rectangle(_x2 - 198, 181, _x2 - 55, 185, false);

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(161, 167, 136));
draw_text(_cx, _gui_h - 88, "ESC, ENTER OU CLIQUE PARA VOLTAR");
draw_set_color(c_white);

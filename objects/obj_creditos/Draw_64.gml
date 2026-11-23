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

draw_set_alpha(0.69);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// Moldura central com a mesma linguagem das outras telas.
draw_set_alpha(0.84);
draw_set_color(make_color_rgb(10, 18, 17));
draw_rectangle(_cx - 380, 118, _cx + 380, _gui_h - 64, false);
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(_cx - 384, 114, _cx + 384, _gui_h - 60, true);
draw_set_color(ui_accent);
draw_rectangle(_cx - 380, 118, _cx + 380, 122, false);
draw_rectangle(_cx - 380, _gui_h - 68, _cx + 380, _gui_h - 64, false);

draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_text_transformed(_cx + 4, 40 + 5, "CREDITOS", 1.75, 1.75, 0);
draw_set_alpha(0.62 + sin(ui_time * 1.7) * 0.12);
draw_set_color(ui_accent);
draw_text_transformed(_cx - 2, 38, "CREDITOS", 1.75, 1.75, 0);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text_transformed(_cx, 40, "CREDITOS", 1.75, 1.75, 0);

// Conteudo rolante.
var _y = pos_y;
draw_set_font(fnt_dialogo);
for (var s = 0; s < array_length(credit_sections); s++) {
    var _section = credit_sections[s];
    draw_set_color(ui_accent);
    draw_text_transformed(_cx, _y, _section[0], 1.18, 1.18, 0);
    _y += 52;
    draw_set_color(make_color_rgb(226, 235, 229));
    var _people = _section[1];
    for (var n = 0; n < array_length(_people); n++) {
        draw_text(_cx, _y, _people[n]);
        _y += 36;
    }
    _y += 66;
}

draw_set_color(c_white);
draw_text_transformed(_cx, _y, "SPIRIT AWAKEN", 1.25, 1.25, 0);
_y += 54;
draw_set_color(ui_accent);
draw_text(_cx, _y, "OBRIGADO POR JOGAR");

// Mascaras escondem a rolagem atras do titulo e do rodape.
draw_set_alpha(0.96);
draw_set_color(make_color_rgb(9, 16, 15));
draw_rectangle(_cx - 379, 119, _cx + 379, 182, false);
draw_rectangle(_cx - 379, _gui_h - 114, _cx + 379, _gui_h - 65, false);
draw_set_alpha(1);
draw_set_color(ui_accent);
draw_rectangle(_cx - 340, 180, _cx + 340, 183, false);

draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(181, 199, 187));
draw_text(_cx, _gui_h - 88, "ESC, ENTER OU CLIQUE PARA VOLTAR");
draw_set_color(c_white);

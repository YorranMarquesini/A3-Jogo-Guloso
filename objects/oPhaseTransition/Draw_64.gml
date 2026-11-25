var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _cx = _w * 0.5;
var _cy = _h * 0.5;

draw_clear(c_black);

// Desenha uma imagem cobrindo a tela com um zoom cinematografico suave.
var _draw_cover = function(_spr, _zoom, _alpha) {
    if (!sprite_exists(_spr)) return;
    // Funcoes anonimas do GML nao capturam variaveis locais do evento.
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _sw = sprite_get_width(_spr);
    var _sh = sprite_get_height(_spr);
    var _scale = max(_gui_w / _sw, _gui_h / _sh) * _zoom;
    var _dw = _sw * _scale;
    var _dh = _sh * _scale;
    draw_sprite_ext(_spr, 0, (_gui_w - _dw) * 0.5, (_gui_h - _dh) * 0.5, _scale, _scale, 0, c_white, _alpha);
};

// Corpo espiritual reutilizado nos dois momentos com o personagem.
var _draw_spirit = function(_x, _y, _scale, _alpha) {
    for (var _s = 0; _s < 9; _s++) {
        var _t = _s / 8;
        var _rad = lerp(17, 2, _t) * _scale;
        var _sy = _y + 42 * _scale - _t * 54 * _scale;
        var _sx = _x + sin(timer * 0.11 + _s) * (5 + _t * 5) * _scale;
        draw_set_alpha(_alpha * (0.55 - _t * 0.18));
        draw_set_colour(merge_color(c_lime, c_aqua, _t));
        draw_ellipse(_sx - _rad, _sy - _rad * 0.28, _sx + _rad, _sy + _rad * 0.28, false);
    }
    draw_set_alpha(_alpha);
    draw_sprite_ext(player_sprite, 0, _x, _y - 18 * _scale + sin(timer * 0.08) * 5, _scale, _scale, 0, c_white, _alpha);
};

if (timer < 180) {
    // O poder verde explode para fora do jogador derrotando a escuridao.
    var _p = clamp(timer / 180, 0, 1);
    _draw_spirit(_cx, _cy + 55, 2.5, 1);
    for (var _r = 0; _r < 8; _r++) {
        var _radius = max(0, (timer - _r * 10)) * (2.0 + _r * 0.25);
        draw_set_alpha((1 - _p) * (0.48 - _r * 0.035));
        draw_set_colour(merge_color(c_lime, c_aqua, _r / 8));
        draw_circle(_cx, _cy + 25, _radius, true);
    }
    draw_set_alpha(clamp((timer - 105) / 75, 0, 1));
    draw_set_colour(c_white);
    draw_rectangle(0, 0, _w, _h, false);
} else if (timer < 420) {
    var _local1 = (timer - 180) / 240;
    _draw_cover(forest_sprite, 1 + _local1 * 0.07, 1);
    var _caption_alpha1 = min(1, (timer - 180) / 35);
    draw_set_alpha(_caption_alpha1 * 0.78);
    draw_set_colour(make_color_rgb(4, 20, 16));
    draw_rectangle(_cx - 440, _h - 146, _cx + 440, _h - 66, false);
    draw_set_alpha(_caption_alpha1);
    draw_set_colour(make_color_rgb(89, 198, 132));
    draw_rectangle(_cx - 440, _h - 146, _cx + 440, _h - 140, false);
    draw_set_font(fnt_tutoras);
    draw_set_halign(fa_center);
    draw_set_colour(c_black);
    draw_text_transformed(_cx + 3, _h - 103 + 3, "A VIDA SEMPRE ENCONTRA UM CAMINHO", 1.05, 1.05, 0);
    draw_set_colour(make_color_rgb(232, 247, 217));
    draw_text_transformed(_cx, _h - 103, "A VIDA SEMPRE ENCONTRA UM CAMINHO", 1.05, 1.05, 0);
} else if (timer < 660) {
    var _local2 = (timer - 420) / 240;
    _draw_cover(lake_sprite, 1.06 - _local2 * 0.04, 1);
    if (timer < 470) {
        _draw_cover(forest_sprite, 1.07, 1 - (timer - 420) / 50);
    }
    var _caption_alpha2 = min(1, (timer - 430) / 45);
    draw_set_alpha(_caption_alpha2 * 0.78);
    draw_set_colour(make_color_rgb(4, 20, 16));
    draw_rectangle(_cx - 400, _h - 146, _cx + 400, _h - 66, false);
    draw_set_alpha(_caption_alpha2);
    draw_set_colour(make_color_rgb(89, 198, 132));
    draw_rectangle(_cx - 400, _h - 146, _cx + 400, _h - 140, false);
    draw_set_font(fnt_tutoras);
    draw_set_halign(fa_center);
    draw_set_colour(c_black);
    draw_text_transformed(_cx + 3, _h - 103 + 3, "E O ESPIRITO SEGUE ADIANTE", 1.05, 1.05, 0);
    draw_set_colour(make_color_rgb(232, 247, 217));
    draw_text_transformed(_cx, _h - 103, "E O ESPIRITO SEGUE ADIANTE", 1.05, 1.05, 0);
} else {
    // O personagem cruza o lago voando por telecinese.
    var _flight = clamp((timer - 660) / 180, 0, 1);
    _draw_cover(lake_sprite, 1.03 + _flight * 0.05, 0.58);
    draw_set_alpha(0.4);
    draw_rectangle_colour(0, 0, _w, _h, make_color_rgb(2, 20, 18), make_color_rgb(2, 20, 18), c_black, c_black, false);
    var _fx = lerp(-100, _w + 120, _flight);
    var _fy = _cy + sin(_flight * pi * 2) * 80;
    for (var _trail = 1; _trail <= 8; _trail++) {
        draw_set_alpha((9 - _trail) * 0.035);
        _draw_spirit(_fx - _trail * 30, _fy + _trail * 2, 1.6, (9 - _trail) * 0.055);
    }
    _draw_spirit(_fx, _fy, 1.7, 1);
    draw_set_alpha(clamp((timer - 810) / 30, 0, 1));
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _w, _h, false);
}

// Barras de cinema e dica discreta.
draw_set_alpha(1);
draw_set_colour(c_black);
draw_rectangle(0, 0, _w, 54, false);
draw_rectangle(0, _h - 54, _w, _h, false);
draw_set_font(fnt_dialogo);
draw_set_halign(fa_right);
draw_set_colour(make_color_rgb(145, 170, 158));
draw_text(_w - 22, _h - 30, "ENTER PARA PULAR");
draw_set_halign(fa_left);
draw_set_colour(c_white);
draw_set_alpha(1);

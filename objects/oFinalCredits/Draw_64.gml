var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _cx = _w * 0.5;

draw_clear(make_color_rgb(2, 10, 8));

// A floresta restaurada fica ao fundo como uma lembranca do final do jogo.
if (sprite_exists(credits_background)) {
    var _bw = sprite_get_width(credits_background);
    var _bh = sprite_get_height(credits_background);
    var _bscale = max(_w / _bw, _h / _bh) * 1.06;
    var _pan = sin(current_time * 0.00022) * 24;
    draw_set_alpha(0.42);
    draw_sprite_ext(credits_background, 0, (_w - _bw * _bscale) * 0.5 + _pan, (_h - _bh * _bscale) * 0.5, _bscale, _bscale, 0, make_color_rgb(105, 150, 120), 1);
}
draw_set_alpha(0.58);
draw_set_colour(make_color_rgb(8, 13, 8));
draw_rectangle(0, 0, _w, _h, false);

// Espiritos em pixels e folhas lentas mantem a tela viva sem parecer uma UI moderna.
gpu_set_blendmode(bm_add);
for (var _m = 0; _m < 18; _m++) {
    var _mx = (_m * 181 + current_time * (0.010 + (_m mod 3) * 0.003)) mod (_w + 100) - 50;
    var _my = (_m * 101 + sin(current_time * 0.002 + _m) * 65 + _h) mod (_h + 100) - 50;
    draw_set_alpha(0.06 + (_m mod 4) * 0.018);
    draw_set_colour(merge_color(make_color_rgb(28, 170, 100), c_aqua, (_m mod 5) / 7));
    var _ms = 2 + (_m mod 3);
    draw_rectangle(_mx - _ms, _my - _ms, _mx + _ms, _my + _ms, false);
}
gpu_set_blendmode(bm_normal);

var _text_block = function(_y, _title, _body, _size) {
    var _gy = _y - scroll_y;
    if (_gy < -260 || _gy > display_get_gui_height() + 260) return;
    var _gw = display_get_gui_width();
    var _panel_w = min(760, _gw * 0.66);
    var _px1 = _gw * 0.5 - _panel_w * 0.5;
    var _px2 = _gw * 0.5 + _panel_w * 0.5;
    draw_set_alpha(0.98);
    draw_set_colour(make_color_rgb(3, 7, 5));
    draw_rectangle(_px1 + 8, _gy - 25, _px2 + 8, _gy + 222, false);
    draw_set_colour(make_color_rgb(43, 48, 32));
    draw_rectangle(_px1 + 10, _gy - 34, _px2 - 10, _gy + 214, false);
    draw_rectangle(_px1, _gy - 24, _px2, _gy + 204, false);
    draw_set_colour(make_color_rgb(121, 103, 58));
    draw_rectangle(_px1 + 7, _gy - 17, _px2 - 7, _gy + 197, true);
    draw_set_colour(make_color_rgb(90, 154, 78));
    draw_rectangle(_px1 + 18, _gy - 28, _px1 + 128, _gy - 22, false);
    draw_rectangle(_px2 - 151, _gy + 200, _px2 - 19, _gy + 206, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(fnt_tutoras);
    draw_set_alpha(1);
    var _title_scale = max(1.30, _size * 1.24);
    draw_set_colour(c_black);
    draw_text_transformed(_gw * 0.5 - 2, _gy, _title, _title_scale, _title_scale, 0);
    draw_text_transformed(_gw * 0.5 + 3, _gy, _title, _title_scale, _title_scale, 0);
    draw_text_transformed(_gw * 0.5, _gy - 2, _title, _title_scale, _title_scale, 0);
    draw_text_transformed(_gw * 0.5, _gy + 3, _title, _title_scale, _title_scale, 0);
    draw_set_colour(make_color_rgb(246, 226, 145));
    draw_text_transformed(_gw * 0.5, _gy, _title, _title_scale, _title_scale, 0);
    draw_set_font(fnt_dialogo);
    draw_set_colour(c_black);
    draw_text_ext_transformed(_gw * 0.5 + 3, _gy + 72 + 3, _body, 34, _panel_w - 96, 1.35, 1.35, 0);
    draw_set_colour(make_color_rgb(250, 246, 218));
    draw_text_ext_transformed(_gw * 0.5, _gy + 72, _body, 34, _panel_w - 96, 1.35, 1.35, 0);
};

var _art_card = function(_spr, _y, _left, _label) {
    var _gy = _y - scroll_y;
    if (_gy < -360 || _gy > display_get_gui_height() + 360 || !sprite_exists(_spr)) return;
    var _gw = display_get_gui_width();
    var _card_w = min(560, _gw * 0.45);
    var _card_h = 286;
    var _center_x = _left ? _gw * 0.34 : _gw * 0.66;
    var _x1 = _center_x - _card_w * 0.5;
    var _x2 = _center_x + _card_w * 0.5;
    var _y1 = _gy;
    var _y2 = _gy + _card_h;

    draw_set_alpha(0.96);
    draw_set_colour(make_color_rgb(13, 18, 11));
    draw_rectangle(_x1 - 13, _y1 - 13, _x2 + 13, _y2 + 42, false);
    draw_set_colour(make_color_rgb(104, 86, 48));
    draw_rectangle(_x1 - 13, _y1 - 13, _x2 + 13, _y2 + 42, true);
    draw_set_colour(make_color_rgb(74, 137, 69));
    draw_rectangle(_x1 - 7, _y1 - 7, _x2 + 7, _y2 + 36, true);

    // Cantos de pedra/energia no estilo das interfaces do jogo.
    var _corner = 34;
    draw_line(_x1 - 13, _y1 + _corner, _x1 - 13, _y1 - 13);
    draw_line(_x1 - 13, _y1 - 13, _x1 + _corner, _y1 - 13);
    draw_line(_x2 + 13, _y2 - _corner, _x2 + 13, _y2 + 42);
    draw_line(_x2 + 13, _y2 + 42, _x2 - _corner, _y2 + 42);

    var _sw = sprite_get_width(_spr);
    var _sh = sprite_get_height(_spr);
    var _sc = min(_card_w / _sw, _card_h / _sh);
    var _dx = _x1 + (_card_w - _sw * _sc) * 0.5;
    var _dy = _y1 + (_card_h - _sh * _sc) * 0.5;
    draw_set_alpha(1);
    draw_sprite_ext(_spr, 0, _dx, _dy, _sc, _sc, 0, c_white, 1);
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(c_black);
    draw_text_transformed(_center_x + 2, _y2 + 12, _label, 1.16, 1.16, 0);
    draw_set_colour(make_color_rgb(241, 228, 176));
    draw_text_transformed(_center_x, _y2 + 10, _label, 1.16, 1.16, 0);
};

var _studio_block = function(_y) {
    var _gy = _y - scroll_y;
    if (_gy < -440 || _gy > display_get_gui_height() + 440 || !sprite_exists(studio_logo)) return;
    var _gw = display_get_gui_width();
    var _sw = sprite_get_width(studio_logo);
    var _sh = sprite_get_height(studio_logo);
    var _sc = min(360 / _sw, 360 / _sh);
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.13 + sin(current_time * 0.005) * 0.03);
    draw_set_colour(make_color_rgb(55, 255, 145));
    draw_circle(_gw * 0.5, _gy + 175, 215, false);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
    draw_sprite_ext(studio_logo, 0, _gw * 0.5 - _sw * _sc * 0.5, _gy, _sc, _sc, 0, c_white, 1);
    draw_set_font(fnt_menu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(c_black);
    draw_text_transformed(_gw * 0.5 + 3, _gy + 365 + 3, "SIGMA ROOM", 1.1, 1.1, 0);
    draw_set_colour(make_color_rgb(231, 245, 232));
    draw_text_transformed(_gw * 0.5, _gy + 365, "SIGMA ROOM", 1.1, 1.1, 0);
    draw_set_font(fnt_dialogo);
    draw_set_colour(make_color_rgb(86, 230, 150));
    draw_text(_gw * 0.5, _gy + 420, "UM ESTUDIO QUASE DE VERDADE");
};

// Cada bloco tem uma faixa vertical exclusiva. Assim nenhuma imagem cruza texto.
_text_block(480, "SPIRIT AWAKEN", "UMA JORNADA FEITA DE IDEIAS E APRENDIZADO", 1.38);
_art_card(art[0], 850, true, "PRIMEIROS INIMIGOS");
_art_card(art[1], 1250, false, "ARMAS DO GUARDIAO");
_text_block(1680, "PROGRAMACAO E SISTEMAS", "Tiago\nYorran\nJoao Pedro", 0.96);
_art_card(art[2], 2070, true, "ESTUDOS DO PERSONAGEM");
_art_card(art[3], 2470, false, "ARENA DA FABRICA");
_text_block(2900, "ARTE E CONCEPT ART", "Carlos\nRayane", 1.0);
_art_card(art[4], 3290, true, "GUARDIAO DAS AGUAS");
_art_card(art[5], 3690, false, "FORMAS DO ESPIRITO");
_text_block(4120, "ASSISTENTE PREMIUM", "Arthur", 0.90);
_art_card(art[6], 4510, true, "O PODER DESPERTA");
_art_card(art[7], 4910, false, "CONCEPT DO PRIMEIRO NPC");
_text_block(5340, "DO RASCUNHO AO JOGO", "Cada inimigo, arma, cenario e personagem comecou com uma ideia no papel.", 0.82);
_art_card(art[8], 5730, true, "ESPIRITO DA FLORESTA");
_art_card(art[9], 6130, false, "PRIMEIRO CAGLIOSTRO");
_text_block(6560, "NOSSO ULTIMO TRABALHO", "Este foi o ultimo trabalho destes alunos na faculdade.\nUma despedida e, ao mesmo tempo, um novo comeco.", 0.88);
_art_card(art[10], 6950, true, "PLANTA DA ARENA");
_art_card(art[11], 7350, false, "MAPA DO LAGO");
_text_block(7780, "AGRADECIMENTOS", "A todos que jogaram, testaram, ensinaram e apoiaram esta jornada:\nNOSSO MUITO OBRIGADO.", 0.94);
_studio_block(8290);
_text_block(8940, "OBRIGADO POR JOGAR", "A NATUREZA VAI DESPERTAR", 1.28);

// Moldura fixa de pedra antiga, musgo e energia espiritual.
draw_set_alpha(0.96);
draw_set_colour(make_color_rgb(14, 18, 11));
draw_rectangle(0, 0, _w, 48, false);
draw_rectangle(0, _h - 48, _w, _h, false);
draw_set_colour(make_color_rgb(107, 91, 52));
draw_rectangle(17, 17, _w - 17, _h - 17, true);
draw_set_colour(make_color_rgb(86, 166, 85));
draw_line(17, 17, 82, 17);
draw_line(17, 17, 17, 82);
draw_line(_w - 17, _h - 17, _w - 82, _h - 17);
draw_line(_w - 17, _h - 17, _w - 17, _h - 82);
draw_set_font(fnt_dialogo);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_colour(make_color_rgb(226, 222, 188));
draw_text(30, _h - 24, controls_label(Bind.dash) + " ACELERA");
draw_set_halign(fa_right);
draw_text(_w - 30, _h - 24, controls_label(Bind.back) + " PARA VOLTAR");
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_colour(c_white);

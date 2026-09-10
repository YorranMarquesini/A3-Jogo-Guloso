draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _gui_w = display_get_gui_width();

// Desenha uma sombra suave preta atrás para dar leitura
draw_set_color(c_black);
draw_text(_gui_w / 2 + 2, pos_y + 2, texto_creditos);

// Desenha o texto principal em amarelo ou branco
draw_set_color(c_yellow);
draw_text(_gui_w / 2, pos_y, texto_creditos);
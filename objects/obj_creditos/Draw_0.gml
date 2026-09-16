

// 1. Configurações de alinhamento
draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _centro_x = display_get_gui_width() / 2;

// 2. Sombra do texto (Deslocada 2 pixels para baixo e para a direita)
draw_set_color(c_black);
draw_text(_centro_x + 2, pos_y + 2, texto_creditos);

// 3. Texto Principal (Amarelo)
draw_set_color(c_yellow);
draw_text(_centro_x, pos_y, texto_creditos);
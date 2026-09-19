draw_set_font(fnt_tutoras);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título (nome da ação)
draw_set_color(title_color);
draw_text_transformed(x, y - 20, title_text, font_scale * 1.3, font_scale * 1.3, 0);

// Descrição (linha de baixo, menor)
draw_set_color(text_color);
draw_text_transformed(x, y + 5, desc_text, font_scale, font_scale, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
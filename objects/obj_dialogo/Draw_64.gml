var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 1. Fonte com acentos
draw_set_font(fnt_dialogo);

// 2. Dimensões da caixa de texto (ajustadas e elevadas)
var box_w = 650;
var box_h = 130;
var box_x = (gui_w - box_w) / 2 + 100;
var box_y = gui_h - 180;

// 3. Desenhar a caixa
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, false);

draw_set_color(c_white);
draw_set_alpha(1.0);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, true);

// 4. Desenhar Nome do Personagem
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(box_x + 20, box_y + 15, nome);

// 5. Desenhar Texto da Fala (Typewriter)
draw_set_color(c_white);
var texto_parcial = string_copy(textos[pagina], 1, floor(caractere_atual));
draw_text_ext(box_x + 20, box_y + 45, texto_parcial, 22, box_w - 40);

// 6. Desenhar Retrato do Personagem (Posicionado junto à caixa)
if (portrait != noone) {
    var portrait_x = box_x - 160; 
    var portrait_y = box_y + box_h; 
    
    draw_sprite_ext(portrait, 0, portrait_x, portrait_y, 0.25, 0.25, 0, c_white, 1);
}

// 7. DESENHAR DICA DE AVANÇAR (Canto Inferior Direito)

var dica_x = box_x + box_w - 30;
var dica_y = box_y + box_h - 25;

var _alpha_pisca = 0.6 + sin(current_time / 200) * 0.4;
draw_set_alpha(_alpha_pisca);

// Posição base do ícone do mouse
var mx = dica_x - 110;
var my = dica_y - 18;

// 1. Corpo do Mouse (Cinza Escuro)
draw_set_color(c_dkgray);
draw_roundrect_ext(mx, my, mx + 16, my + 24, 6, 6, false);
draw_set_color(c_white);
draw_roundrect_ext(mx, my, mx + 16, my + 24, 6, 6, true);

// 2. Botão Esquerdo Destacado (Amarelo)
draw_set_color(c_yellow);
draw_roundrect_ext(mx + 1, my + 1, mx + 7, my + 10, 3, 3, false);

// 3. Linha Divisória Central e da Rodinha
draw_set_color(c_white);
draw_line(mx + 8, my + 2, mx + 8, my + 11); // Linha vertical do topo
draw_line(mx + 2, my + 11, mx + 14, my + 11); // Linha horizontal dos botões

// 4. Texto "ou [E] >"
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_set_font(fnt_dialogo);
draw_set_color(c_yellow);
draw_text(dica_x, dica_y, " ou [E] >");

// Reseta padrões
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);

var _w = display_get_gui_width();
var _h = display_get_gui_height();


// ---- a última imagem do jogo, congelada ----
if (surface_exists(tela)) {
    draw_surface_stretched(tela, 0, 0, _w, _h);
}


// ---- escurece ----
draw_set_alpha(fade * 0.78);
draw_rectangle_colour(0, 0, _w, _h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(fade);


// ---- textos ----
// Sem acentos de propósito: a fnt_menu do projeto não tem os glifos
// acentuados (repare que o menu escreve "Opcoes" e "Credito").
draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _cx = _w * 0.5;
var _cy = _h * 0.5;

draw_set_colour(c_black);
draw_text(_cx + 3, _cy - 57, "VOCE MORREU");
draw_set_colour(c_red);
draw_text(_cx, _cy - 60, "VOCE MORREU");

draw_set_colour(c_white);
draw_text(_cx, _cy + 20, "R  -  RECOMECAR A FASE");
draw_text(_cx, _cy + 60, "ESC  -  VOLTAR AO MENU");

// devolve o estado do desenho pro padrão
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

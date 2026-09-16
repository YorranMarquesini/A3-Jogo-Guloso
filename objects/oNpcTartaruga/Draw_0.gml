// Desenha a sprite normal do NPC na sala
draw_self();

var player = instance_find(oPlayer, 0);

if (player != noone) {
    var dist = point_distance(x, y, player.x, player.y);
    
    // [REQUISITO 4] Mostra o indicador "Aperte E" perto do NPC se o diálogo estiver fechado
    if (dist <= distancia_interacao && !instance_exists(obj_dialogo)) {
        draw_set_font(fnt_dialogo);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        
        var texto_x = x;
        var texto_y = bbox_top - 10;
        
        // Fundo escuro para a dica
        draw_set_color(c_black);
        draw_set_alpha(0.7);
        draw_roundrect(texto_x - 75, texto_y - 20, texto_x + 75, texto_y + 2, false);
        
        // Texto amarelo
        draw_set_alpha(1.0);
        draw_set_color(c_yellow);
        draw_text(texto_x, texto_y, "[E]");
    }
}
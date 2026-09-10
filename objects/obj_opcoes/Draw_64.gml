draw_set_font(fnt_menu);
draw_set_valign(fa_middle);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

for (var i = 0; i < total_opcoes; i++) {
    var _pos_y = (_gui_h / 2) - 60 + (i * 50);
    var _cor = (i == opcao_selecionada) ? c_yellow : c_white;
    
    // --- 0: RESOLUÇÃO ---
    if (i == 0) {
        draw_set_halign(fa_center);
        draw_set_color(_cor);
        var _res_atual = lista_resolucoes[res_index];
        draw_text(_gui_w / 2, _pos_y, "Resolucao: " + string(_res_atual[0]) + "x" + string(_res_atual[1]));
    } 
    
    // --- 2: VOLUME COM BARRA GRÁFICA + PORCENTAGEM ---
    else if (i == 2) {
        var _barra_w = 160;
        var _barra_h = 16;
        
        var _x_texto = (_gui_w / 2) - 140;
        var _x_barra = (_gui_w / 2) - 30;
        var _x_porcentagem = _x_barra + _barra_w + 25;
        
        // 1. Texto "Volume"
        draw_set_halign(fa_left);
        draw_set_color(_cor);
        draw_text(_x_texto, _pos_y, "Volume");
        
        // 2. Fundo da Barra (Cinza Escuro)
        var _y1 = _pos_y - (_barra_h / 2);
        var _y2 = _pos_y + (_barra_h / 2);
        draw_set_color(c_dkgray);
        draw_rectangle(_x_barra, _y1, _x_barra + _barra_w, _y2, false);
        
        // 3. Preenchimento da Barra
        var _preenchimento_w = (_barra_w * (volume_level / 100));
        draw_set_color(_cor);
        draw_rectangle(_x_barra, _y1, _x_barra + _preenchimento_w, _y2, false);
        
        // 4. Borda Externa da Barra
        draw_set_color(c_white);
        draw_rectangle(_x_barra, _y1, _x_barra + _barra_w, _y2, true);
        
        // 5. Porcentagem à Direita
        draw_set_color(_cor);
        draw_text(_x_porcentagem, _pos_y, string(volume_level) + "%");
    } 
    
    // --- DEMAIS OPÇÕES (Tela Cheia, Voltar) ---
    else {
        draw_set_halign(fa_center);
        draw_set_color(_cor);
        draw_text(_gui_w / 2, _pos_y, opcoes[i]);
    }
}
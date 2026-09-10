draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

for (var i = 0; i < total_opcoes; i++) {
    var _pos_y = (_gui_h / 2) - 60 + (i * 50);

    if (i == opcao_selecionada) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_white);
    }

    draw_text(_gui_w / 2, _pos_y, opcoes[i]);
}
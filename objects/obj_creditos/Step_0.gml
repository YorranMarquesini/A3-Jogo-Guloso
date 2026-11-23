ui_time += delta_time / 1000000;
pos_y -= velocidade * (delta_time / 16666.6667);

var _voltar_esc = keyboard_check_pressed(vk_escape);
var _voltar_enter = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _voltar_clique = mouse_check_button_pressed(mb_left);
var _texto_sumiu = (pos_y < -credit_height);

if (_voltar_esc || _voltar_enter || _voltar_clique || _texto_sumiu) {
    room_goto(rm_menu);
}

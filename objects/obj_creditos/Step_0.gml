var _pad = scr_gamepad_slot();

ui_time += delta_time / 1000000;
pos_y -= velocidade * (delta_time / 16666.6667);

var _voltar_esc = controls_read(Bind.back, _pad);
var _voltar_enter = controls_read(Bind.confirm, _pad) || controls_menu_space();
var _voltar_clique = mouse_check_button_pressed(mb_left);
var _texto_sumiu = (pos_y < -credit_height);

if (_voltar_esc || _voltar_enter || _voltar_clique || _texto_sumiu) {
    room_goto(rm_menu);
}

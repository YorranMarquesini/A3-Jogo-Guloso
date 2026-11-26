var _pad = scr_gamepad_slot();
var _pad_dir = pad_directions(_pad);

fade = min(fade + 0.07, 1);
pulso += 0.06;

if (eh_chefe && !musica_parada) {
    musica_timer--;
    if (musica_timer <= 0) {
        musica_parada = true;
        if (variable_global_exists("cagliostro_music")
        &&  global.cagliostro_music != noone
        &&  audio_is_playing(global.cagliostro_music)) {
            audio_stop_sound(global.cagliostro_music);
        }
    }
}

// pequena carência pra não reiniciar com uma tecla que ainda estava apertada
if (atraso > 0) {
    atraso--;
    exit;
}


if ((_pad_dir.press_y < 0)
||  (_pad_dir.press_y > 0)) {
    opcao = 1 - opcao;
}

var _retry = keyboard_check_pressed(ord("R")) && global.controls_keyboard[Bind.confirm] != ord("R") && global.controls_keyboard[Bind.back] != ord("R") && _pad_dir.press_y == 0;
if (_retry) opcao = 0;
if (controls_read(Bind.back, _pad)) opcao = 1;

if (controls_read(Bind.confirm, _pad)
||  controls_menu_space()
||  _retry
||  controls_read(Bind.back, _pad)) {

    if (surface_exists(tela)) surface_free(tela);
    if (opcao == 0) scr_reiniciar_fase();
    else scr_voltar_ao_menu();
    exit;
}

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


if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))
||  keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    opcao = 1 - opcao;
}

if (keyboard_check_pressed(ord("R"))) opcao = 0;
if (keyboard_check_pressed(vk_escape)) opcao = 1;

if (keyboard_check_pressed(vk_enter)
||  keyboard_check_pressed(vk_space)
||  keyboard_check_pressed(ord("R"))
||  keyboard_check_pressed(vk_escape)) {

    if (surface_exists(tela)) surface_free(tela);
    if (opcao == 0) scr_reiniciar_fase();
    else scr_voltar_ao_menu();
    exit;
}

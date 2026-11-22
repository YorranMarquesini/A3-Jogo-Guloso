fade = min(fade + 0.07, 1);

// pequena carência pra não reiniciar com uma tecla que ainda estava apertada
if (atraso > 0) {
    atraso--;
    exit;
}


// ---- R / ENTER / ESPAÇO: recomeça a fase do zero ----
if (keyboard_check_pressed(ord("R"))
 || keyboard_check_pressed(vk_enter)
 || keyboard_check_pressed(vk_space)) {

    if (surface_exists(tela)) surface_free(tela);
    scr_reiniciar_fase();
    exit;
}


// ---- ESC: volta pro menu ----
if (keyboard_check_pressed(vk_escape)) {
    if (surface_exists(tela)) surface_free(tela);
    scr_voltar_ao_menu();
    exit;
}

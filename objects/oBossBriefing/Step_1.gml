if (deadline == 0) {
    // Todas as instancias da sala ja existem; suspenda antes do primeiro Step de combate.
    instance_deactivate_all(true);
    // O controlador desenha a agua, a nevoa e o oleo da arena.
    instance_activate_object(oGameController);
    deadline = get_timer() + 10000000;
}
var _pad = scr_gamepad_slot();
// Retome no proximo Step para o mesmo toque nao pular ou pausar a luta.
if (controls_read(Bind.confirm, _pad)) {
    deadline = get_timer();
} else if (get_timer() >= deadline) {
    instance_activate_all();
    instance_destroy();
}

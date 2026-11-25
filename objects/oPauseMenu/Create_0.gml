depth = -10000;
tela = -1;
if (surface_exists(application_surface)) {
    tela = surface_create(surface_get_width(application_surface), surface_get_height(application_surface));
    surface_copy(tela, 0, 0, application_surface);
}

instance_deactivate_all(true);

pagina = 0; // 0 menu principal, 1 opcoes
opcao = 0;
atraso = 12;
fade = 0;
ui_time = 0;
volume_level = round(audio_get_master_gain(0) * 100);
fullscreen = window_get_fullscreen();
// 0: menu aberto, 1: retomar, 2: voltar ao menu principal.
pause_exit = 0;

lista_resolucoes = [[800, 600], [1024, 768], [1280, 720], [1366, 768], [1600, 900], [1920, 1080]];
res_index = 0;
var _current_w = window_get_width();
for (var _r = 0; _r < array_length(lista_resolucoes); _r++) {
    if (lista_resolucoes[_r][0] == _current_w) res_index = _r;
}

function pause_close(_destination) {
    pause_exit = _destination;
    instance_activate_all();
}

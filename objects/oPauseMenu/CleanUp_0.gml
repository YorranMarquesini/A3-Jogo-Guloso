if (surface_exists(tela)) surface_free(tela);
// Tambem protege o jogo caso a sala seja trocada por outro caminho.
if (pause_exit == 0) instance_activate_all();

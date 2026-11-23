// ============================================================
//  Vigia da tela.
//
//  Sempre que a janela muda de tamanho (tela cheia, arrastar a borda,
//  trocar resolução no menu de opções), o GameMaker redimensiona a
//  application_surface por conta própria. Isso desmancharia tudo.
//
//  Como este objeto é Persistent, ele existe em TODAS as salas e
//  conserta a resolução no frame seguinte.
// ============================================================

if (screen_needs_fix()) {
    screen_apply_base();
}

// Insiste no tamanho de janela pedido até o Windows obedecer.
// (sair da tela cheia demora alguns frames e o Windows restaura o
//  tamanho antigo no caminho — por isso precisa insistir)
window_apply_pending();

// A trilha acompanha Menu e Opcoes, mas silencia no jogo e nos Creditos.
var _menu_music_allowed = (room == rm_menu || room == rm_opcoes);
if (_menu_music_allowed) {
    if (!audio_is_playing(menu_music_handle)) {
        menu_music_handle = audio_play_sound(snd_menu_fantasy, 0, true);
        audio_sound_gain(menu_music_handle, 0.62, 0);
    }
} else if (audio_is_playing(menu_music_handle)) {
    audio_stop_sound(menu_music_handle);
}

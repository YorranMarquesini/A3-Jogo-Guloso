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

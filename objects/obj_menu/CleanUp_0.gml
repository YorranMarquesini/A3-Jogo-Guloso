// Sprites carregados de Included Files precisam ser liberados ao sair do menu.
for (var i = 0; i < array_length(menu_sprites); i++) {
    if (sprite_exists(menu_sprites[i])) sprite_delete(menu_sprites[i]);
}

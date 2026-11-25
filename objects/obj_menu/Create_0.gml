sala_inicial = IntroCutscene;
opcoes = ["JOGAR", "OPCOES", "CREDITOS", "SAIR"];
total_opcoes = array_length(opcoes);
opcao_selecionada = 0;
largura_opcao = 300;
altura_opcao = 46;

// Cada abertura do jogo escolhe uma paisagem e a mantem ao voltar de outras salas.
var _menu_path = working_directory + "menu/";
menu_sprites = [
    sprite_add(_menu_path + "menu_dawn_clean.png", 1, false, false, 0, 0),
    sprite_add(_menu_path + "menu_temple_clean.png", 1, false, false, 0, 0),
    sprite_add(_menu_path + "menu_wasteland_clean.png", 1, false, false, 0, 0)
];
if (!variable_global_exists("menu_variant")) {
    randomize();
    global.menu_variant = irandom(array_length(menu_sprites) - 1);
}
menu_variant = global.menu_variant;
menu_background = menu_sprites[menu_variant];
menu_time = 0;
menu_selection_time = 0;

// Cor ambiental de cada tela: amanhecer, templo e mundo poluido.
menu_accent = [make_color_rgb(147, 190, 88), make_color_rgb(87, 181, 132), make_color_rgb(190, 145, 61)];

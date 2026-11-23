ui_time = 0;
var _variant = variable_global_exists("menu_variant") ? global.menu_variant : 0;
var _names = ["menu_dawn.png", "menu_temple.png", "menu_wasteland.png"];
var _colors = [make_color_rgb(147, 190, 88), make_color_rgb(87, 181, 132), make_color_rgb(190, 145, 61)];
ui_accent = _colors[_variant];
ui_background = sprite_add(working_directory + "menu/" + _names[_variant], 1, false, false, 0, 0);

credit_sections = [
    ["PROGRAMACAO", ["Tiago", "Yorran", "Joao Pedro"]],
    ["ARTE", ["Joao Pedro", "Rayane"]],
    ["ASSISTENTE PREMIUM", ["Arthur"]]
];

pos_y = display_get_gui_height() * 0.58;
velocidade = 0.58;
credit_height = 620;

credits_music_handle = audio_play_sound(snd_creditos_musica, 5, true);
audio_sound_gain(credits_music_handle, 0.72, 250);

scroll_y = 0;
scroll_speed = 0.88;
finished = false;
var _path = working_directory + "credits_concept/";
art = array_create(12, -1);
art[0] = sprite_add(_path + "01_enemies.png", 1, false, false, 0, 0);
art[1] = sprite_add(_path + "02_weapons.png", 1, false, false, 0, 0);
art[2] = sprite_add(_path + "03_player_concept.png", 1, false, false, 0, 0);
art[3] = sprite_add(_path + "04_factory_boss_sketch.jpg", 1, false, false, 0, 0);
art[4] = sprite_add(_path + "05_water_boss_sketch.jpg", 1, false, false, 0, 0);
art[5] = sprite_add(_path + "06_player_studies.png", 1, false, false, 0, 0);
art[6] = sprite_add(_path + "07_player_power.png", 1, false, false, 0, 0);
art[7] = sprite_add(_path + "08_water_boss_colored.png", 1, false, false, 0, 0);
art[8] = sprite_add(_path + "09_fairy_concept.png", 1, false, false, 0, 0);
art[9] = sprite_add(_path + "10_cagliostro_sketch.jpg", 1, false, false, 0, 0);
art[10] = sprite_add(_path + "11_boss_arena.png", 1, false, false, 0, 0);
art[11] = sprite_add(_path + "12_lake_map.png", 1, false, false, 0, 0);
credits_background = sprite_add(working_directory + "final/final_forest_restored.png", 1, false, false, 0, 0);
studio_logo = sprite_add(working_directory + "startup/sigma_room_mark.png", 1, false, false, 0, 0);
music_handle = audio_play_sound(snd_creditos_musica, 5, true);
audio_sound_gain(music_handle, 0.62, 700);

function finish_credits() {
    if (finished) return;
    finished = true;
    room_goto(rm_menu);
}

bad_ending = variable_global_exists("cagliostro_bad_ending") && global.cagliostro_bad_ending;
global.cagliostro_bad_ending = false;
timer = 0;
finished = false;
var _path = working_directory + "final/";
factory_sprite = -1;
forest_sprite = -1;
animals_sprite = -1;
bad_scenes = [];
if (bad_ending) {
    bad_voices = [snd_bad_ending_01, snd_bad_ending_02, snd_bad_ending_03, snd_bad_ending_04];
    bad_shot = 0;
    bad_clock = 0;
    bad_voice = -1;
    bad_voice_started = false;
    var _files = ["bad_construction.png", "bad_profits.png", "bad_guardian.png"];
    for (var i = 0; i < array_length(_files); i++) bad_scenes[i] = sprite_add(_path + _files[i], 1, false, false, 0, 0);
} else {
    factory_sprite = sprite_add(_path + "final_factory_destroyed.png", 1, false, false, 0, 0);
    forest_sprite = sprite_add(_path + "final_forest_restored.png", 1, false, false, 0, 0);
    animals_sprite = sprite_add(_path + "final_animals_clearing.png", 1, false, false, 0, 0);
}
player_sprite = player_right_idle;
music_handle = audio_play_sound(snd_theme_transition, 3, true);
audio_sound_gain(music_handle, 0.45, 900);

// Dublagens na mesma ordem das tres frases mostradas na tela.
final_voices = [snd_final_voice_01, snd_final_voice_02, snd_final_voice_03];
final_voice_instances = [-1, -1, -1];
final_voice_started = [false, false, false];
final_voice_frames = [38, 368, 698];
final_voice_end_frames = [236, 570, 938];
final_voice_ducking = false;
final_voice_duck_until = -1;

function finish_final_cutscene() {
    if (finished) return;
    finished = true;
    room_goto(FinalCredits);
}

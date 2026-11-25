target_room = noone;
stage_transition_type = 0; // 1: floresta/fase 1
timer = 0;
duration_out = 72;
duration_in = 72;
room_switched = false;

global.player_cutscene_locked = true;

transition_path = working_directory + "transition/";
forest_sprite = sprite_add(transition_path + "phase_transition_forest_polluted.png", 1, false, false, 0, 0);
lake_sprite = sprite_add(transition_path + "phase_transition_lake_polluted.png", 1, false, false, 0, 0);

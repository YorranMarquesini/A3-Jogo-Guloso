timer++;

// A cutscene pode ser adiantada depois que a primeira paisagem apareceu.
if (stage_transition_type == 1 && !room_switched && timer > 75
&& keyboard_check_pressed(vk_escape)) {
    timer = max(timer, duration_out - 45);
}

if (!room_switched && timer >= duration_out && target_room != noone) {
    room_switched = true;
    room_goto(target_room);
}

if (room_switched && timer >= duration_out + duration_in) {
    global.player_cutscene_locked = false;
    persistent = false;
    instance_destroy();
}

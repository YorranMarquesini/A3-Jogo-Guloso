timer++;

if (!started && instance_exists(oPlayer)) {
    player = instance_find(oPlayer, 0);
    target_y = player.y;
    start_y = target_y - 360;
    player.y = start_y;
    player.hsp = 0;
    player.vsp = 0;
    started = true;
}

if (started && instance_exists(player)) {
    var _p = clamp((timer - 10) / 145, 0, 1);
    var _ease = 1 - power(1 - _p, 3);
    player.y = lerp(start_y, target_y, _ease);
    player.spirit_bob_timer += 0.1;

    if (timer >= 175) {
        player.y = target_y;
        global.player_cutscene_locked = false;
        instance_destroy();
    }
}

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (started && instance_exists(player)) player.y = target_y;
    global.player_cutscene_locked = false;
    instance_destroy();
}

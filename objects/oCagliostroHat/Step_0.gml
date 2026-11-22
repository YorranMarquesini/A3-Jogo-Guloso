if (hit_lock > 0) hit_lock--;
image_angle += 18;

if (!returning) {
    travel_timer--;
    x += lengthdir_x(move_speed, direction);
    y += lengthdir_y(move_speed, direction);
    move_speed = max(5.5, move_speed - 0.025);
    if (travel_timer <= 0) returning = true;
} else if (instance_exists(owner)) {
    var _return_y = owner.y - (28 * abs(owner.image_yscale));
    direction = point_direction(x, y, owner.x, _return_y);
    move_speed = min(13, move_speed + 0.25);
    x += lengthdir_x(move_speed, direction);
    y += lengthdir_y(move_speed, direction);
    if (point_distance(x, y, owner.x, _return_y) < 70) instance_destroy();
} else {
    instance_destroy();
}

if (hit_lock <= 0 && place_meeting(x, y, oPlayer)) {
    scr_damage_player(1, x);
    hit_lock = 30;
}

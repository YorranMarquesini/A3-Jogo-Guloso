life--;
image_angle += 1.5;
var _pulse = sin(current_time / 120) * 0.14;
image_xscale = base_scale + _pulse;
image_yscale = base_scale + _pulse;

if (place_meeting(x, y, oPlayer)) {
    scr_damage_player(1, x);
    instance_destroy();
    exit;
}

if (life <= 0 || x < -256 || x > room_width + 256 || y < -256 || y > room_height + 256) instance_destroy();

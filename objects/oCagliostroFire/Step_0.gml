life--;
image_angle = direction + sprite_angle_offset;

// Rastro de faíscas.
if (life mod 3 == 0) {
    var _spark = instance_create_depth(
        x + random_range(-10, 10),
        y + random_range(-10, 10),
        depth + 1,
        oHitParticle
    );
    _spark.dir_x = lengthdir_x(random_range(0.4, 1.4), direction + 180 + random_range(-30, 30));
    _spark.dir_y = lengthdir_y(random_range(0.4, 1.4), direction + 180 + random_range(-30, 30));
    _spark.color = choose(c_orange, c_yellow, c_red);
    _spark.radius = random_range(3, 7);
    _spark.fade_speed = 0.06;
}

if (place_meeting(x, y, oPlayer)) {
    // Dano + knockback (empurra para longe da bola de fogo).
    scr_damage_player(1, x);

    repeat (10) {
        var _p = instance_create_depth(x, y, depth - 1, oHitParticle);
        var _a = random(360);
        var _s = random_range(1.5, 4);
        _p.dir_x = lengthdir_x(_s, _a);
        _p.dir_y = lengthdir_y(_s, _a);
        _p.color = choose(c_orange, c_yellow, c_red);
        _p.radius = random_range(5, 10);
    }

    instance_destroy();
    exit;
}

if (life <= 0 || x < -256 || x > room_width + 256 || y < -256 || y > room_height + 256) instance_destroy();

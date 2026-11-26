life--;
sway_phase += sway_speed;

y += fall_speed;
x += sin(sway_phase) * sway_amount;
image_angle += spin_speed;

// Some ao bater numa plataforma, soltando umas faíscas verdes.
if (place_meeting(x, y, oGround)) {
    repeat (5) {
        var _p = instance_create_depth(x, y, depth, oHitParticle);
        var _a = random_range(20, 160);
        var _s = random_range(1, 2.5);
        _p.dir_x = lengthdir_x(_s, _a);
        _p.dir_y = lengthdir_y(_s, _a);
        _p.color = choose(make_color_rgb(76, 255, 151), c_lime, c_white);
        _p.radius = random_range(3, 6);
        _p.fade_speed = 0.06;
    }
    instance_destroy();
    exit;
}

// Para de cair se o boss morreu.
if (instance_exists(oCagliostro) && oCagliostro.state == "dying") {
    image_alpha -= 0.08;
    if (image_alpha <= 0) { instance_destroy(); exit; }
}

if (life <= 0 || y > room_height + 64) instance_destroy();

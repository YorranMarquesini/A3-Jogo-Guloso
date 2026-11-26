life--;
sway_phase += sway_speed;

y += fall_speed;
x += sin(sway_phase) * sway_amount;
image_angle += spin_speed;

if (instance_exists(oPlayer) && instance_exists(oCagliostro) && oCagliostro.state != "dying") {
    if (!proximity_checked && distance_to_object(oPlayer) <= 200) {
        proximity_checked = true;
        explosive = (random(1) < 0.35);
    }

    if (explosive) {
        var _flash = (blink_steps div 5) mod 2 == 0;
        image_blend = _flash ? c_red : c_white;
        image_alpha = _flash ? 1 : 0.55;
        blink_steps++;

        // Dá tempo de ver um ciclo do aviso antes de poder explodir.
        if (blink_steps > 10 && place_meeting(x, y, oPlayer)) {
            audio_play_sound(snd_cagliostro_explosion, 2, false, 0.4);
            repeat (14) {
                var _spark = instance_create_depth(x, y, depth - 1, oHitParticle);
                var _angle = random(360);
                var _speed = random_range(2, 6);
                _spark.dir_x = lengthdir_x(_speed, _angle);
                _spark.dir_y = lengthdir_y(_speed, _angle);
                _spark.color = choose(c_red, c_orange, c_yellow);
                _spark.radius = random_range(5, 10);
            }
            scr_damage_player(1, x);
            instance_destroy();
            exit;
        }
    }
}

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

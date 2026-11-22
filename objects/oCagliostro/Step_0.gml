if (invuln_timer > 0) invuln_timer--;
if (hit_flash_timer > 0) hit_flash_timer--;
image_blend = (hit_flash_timer > 0) ? c_red : c_white;

switch (state) {
    case "cutscene":
        // Sprites e ritmo são dirigidos por oCagliostroCutscene.
    break;

    case "combat":
        sprite_index = spr_cagliostro_idle;
        image_speed = 0.12;
        attack_timer--;
        if (attack_timer <= 0) {
            var _next_attack;

            if (last_attack_kind == -1) {
                // Primeiro ataque: fumaça ou chapéu com chances iguais.
                _next_attack = irandom(1);
            } else if (attack_repeat_count >= max_attack_repeats) {
                // Nunca permite quatro ataques iguais seguidos.
                _next_attack = 1 - last_attack_kind;
            } else {
                // Pode repetir ou trocar livremente; repetição levemente favorecida
                // para evitar uma alternância previsível fumaça/chapéu.
                _next_attack = (random(1) < 0.55) ? last_attack_kind : 1 - last_attack_kind;
            }

            if (_next_attack == last_attack_kind) {
                attack_repeat_count++;
            } else {
                last_attack_kind = _next_attack;
                attack_repeat_count = 1;
            }

            attack_kind = _next_attack;
            attack_fired = false;
            attack_timer = 48;
            state = (attack_kind == 0) ? "smoke_attack" : "hat_attack";
        }
    break;

    case "smoke_attack":
        sprite_index = spr_cagliostro_idle;
        image_speed = 0.18;
        attack_timer--;

        if (!attack_fired && attack_timer <= 28) {
            attack_fired = true;
            if (instance_exists(oPlayer)) {
                // Boca/charuto acompanhando a escala gigante definida na room.
                var _smoke_x = x - (20 * abs(image_xscale));
                var _smoke_y = y + (9 * abs(image_yscale));
                var _base = point_direction(_smoke_x, _smoke_y, oPlayer.x, oPlayer.y - 20);
                for (var _i = -1; _i <= 1; _i++) {
                    var _ring = instance_create_depth(_smoke_x, _smoke_y, depth - 1, oCagliostroSmoke);
                    _ring.direction = _base + (_i * 11);
                    _ring.speed = 5.0;
                }
            }
        }

        if (attack_timer <= 0) {
            state = "combat";
            attack_timer = irandom_range(attack_cooldown_min, attack_cooldown_max);
        }
    break;

    case "hat_attack":
        sprite_index = spr_cagliostro_no_hat;
        image_speed = 0;
        attack_timer--;

        if (!attack_fired && attack_timer <= 34) {
            attack_fired = true;
            var _hat_x = x;
            var _hat_y = y - (28 * abs(image_yscale));
            var _hat = instance_create_depth(_hat_x, _hat_y, depth - 2, oCagliostroHat);
            _hat.owner = id;
        }

        if (attack_timer <= 0 && !instance_exists(oCagliostroHat)) {
            state = "combat";
            attack_timer = irandom_range(attack_cooldown_min, attack_cooldown_max);
        }
    break;

    case "dying":
        hittable = false;
        image_speed = 0;
        death_timer--;
        image_blend = (death_timer mod 8 < 4) ? c_white : c_red;

        if (death_timer mod 8 == 0) {
            repeat (12) {
                var _p = instance_create_depth(x + random_range(-100, 100), y + random_range(-130, 70), depth - 10, oHitParticle);
                var _a = random(360);
                var _s = random_range(2, 7);
                _p.dir_x = lengthdir_x(_s, _a);
                _p.dir_y = lengthdir_y(_s, _a);
                _p.color = choose(c_red, c_orange, c_white, c_gray);
                _p.radius = random_range(8, 18);
            }
        }

        if (death_timer <= 0) {
            if (variable_global_exists("cagliostro_music")) {
                audio_sound_gain(global.cagliostro_music, 0, 900);
            }
            instance_destroy();
        }
    break;
}

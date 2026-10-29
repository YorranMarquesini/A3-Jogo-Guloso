// ============================================================
//  GARRAFA — ciclo de ataque
// ============================================================

// ---- timers do sistema de dano ----
if (invuln_timer > 0)    invuln_timer--;
if (hit_flash_timer > 0) hit_flash_timer--;


// ============================================================
//  MORRENDO
//  Quem liga isso é o scr_try_hit_enemy, quando a vida chega a zero.
// ============================================================
if (state == "dying") {
    death_timer--;
    image_index = 3;                              // congela no frame do disparo
    image_alpha = max(death_timer / death_duration, 0);

    if (death_timer <= 0) instance_destroy();
    exit;
}


// ============================================================
//  ONDE ESTÁ O PLAYER
// ============================================================
var _ve_player = false;
var _meu_cx    = (bbox_left + bbox_right) * 0.5;
var _meu_cy    = (bbox_top  + bbox_bottom) * 0.5;

if (instance_exists(oPlayer)) {
    var _plr_cx = (oPlayer.bbox_left + oPlayer.bbox_right) * 0.5;
    var _plr_cy = (oPlayer.bbox_top  + oPlayer.bbox_bottom) * 0.5;

    _ve_player = (abs(_plr_cx - _meu_cx) < sight_range)
              && (abs(_plr_cy - _meu_cy) < sight_height);

    // só gira de lado quando NÃO está no meio do ataque —
    // senão ela viraria com a tampa já na boca, e ficaria estranho
    if (state == "idle" || state == "cooldown") {
        facing = (_plr_cx < _meu_cx) ? -1 : 1;
    }
}


// ============================================================
//  CICLO DE ATAQUE
// ============================================================
var _mx = 0;
var _my = 0;
var _tampa = noone;

state_timer--;

switch (state) {

    case "idle":                      // === Garrafa_1 ===
        image_index = 0;
        if (_ve_player) {
            state       = "windup";
            state_timer = windup_time;
        }
        break;

    case "windup":                    // === Garrafa_2 ===
        image_index = 1;
        if (state_timer <= 0) {
            state       = "aim";
            state_timer = aim_time;
        }
        break;

    case "aim":                       // === Garrafa_3 ===
        image_index = 2;
        if (state_timer <= 0) {
            // a tampa nasce na boca da garrafa e mira sozinha no player
            _mx = x + muzzle_dx * facing;
            _my = y + muzzle_dy;

            _tampa = instance_create_depth(_mx, _my, depth, oTampaProjetil);
            _tampa.move_spd = tampa_speed;
            _tampa.dono     = id;

            state       = "shoot";
            state_timer = shoot_hold;
        }
        break;

    case "shoot":                     // === Garrafa_4 ===
        image_index = 3;
        if (state_timer <= 0) {
            state       = "cooldown";
            state_timer = cooldown_time;
        }
        break;

    case "cooldown":                  // volta pro Garrafa_1 e espera
        image_index = 0;
        if (state_timer <= 0) {
            state = "idle";
        }
        break;
}


// ============================================================
//  ENCOSTOU NO PLAYER -> dano por contato
//  (o scr_damage_player já respeita i-frames e dash, então pode chamar)
// ============================================================
if (instance_exists(oPlayer) && place_meeting(x, y, oPlayer)) {
    scr_damage_player(contact_damage, x);
}


// A arte aponta pra esquerda, então o espelhamento é ao contrário
image_xscale = -facing;

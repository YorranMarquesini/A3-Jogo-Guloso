if (cooldown > 0) cooldown--;

if (!instance_exists(oPlayer)) exit;
if (cooldown > 0)              exit;

if (!place_meeting(x, y, oPlayer)) exit;


// ---- ARREMESSA ----
with (oPlayer) {
    vsp = other.forca;

    // devolve o pulo duplo e o dash: o player precisa conseguir
    // se ajeitar no ar pra escolher em qual plataforma cair
    jump_count = 0;
    can_dash   = true;

    // cancela um dash que estivesse rolando, senão ele anula o arremesso
    is_dashing = false;
    dash_timer = 0;
}

// ---- efeito ----
scr_spawn_jump_burst(oPlayer.x, oPlayer.y, true);

if (instance_exists(oCameraController_boss)) {
    oCameraController_boss.shake_amount = 5;
}

cooldown = 20;

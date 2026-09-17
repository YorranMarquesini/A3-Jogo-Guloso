// --- Animação / Sprite ---
facing = "right";
state = "idle";

// ============================
// MOVIMENTO HORIZONTAL
// ============================
hsp = 0;
move_speed = 4;
acc = 0.5;
dec = 0.5;
air_acc = 0.35;

// ============================
// VERTICAL / PULO
// ============================
vsp = 0;
grav = 0.25;
jump_force = -8;
max_fall = 10;

coyote_time = 6;
coyote_counter = 0;

jump_buffer = 6;
jump_buffer_counter = 0;

jump_cut_multiplier = 0.5;

max_jumps = 2;
jump_count = 0;

// ============================
// DASH
// ============================
can_dash = true;
is_dashing = false;
dash_speed = 12;
dash_time = 8;
dash_timer = 0;
dash_cooldown = 0;
dash_cooldown_max = 60; //Frames ou seja 1s
dash_dir_x = 0;
dash_dir_y = 0;
dash_invuln_time = 40; // 0.5s a 60fps
invuln_timer = 0;
// --- AFTERIMAGE (rastro do dash) ---
afterimage_timer = 0;
afterimage_interval = 2; // cria uma cópia a cada N frames durante o dash

// ============================
// DIRECTION BUFFER (pro wall jump)
// ============================
dir_buffer_time = 8;      // frames que o input de direção "conta" depois de apertado
dir_buffer_counter = 0;
dir_buffer_dir = 0;       // -1 esquerda, 1 direita, 0 nenhum

// ============================
// WALL INTERACTION
// ============================
wall_check_dist = 2;
wall_check_yoffset = 8;   // altura acima dos pés pra checar parede (evita confundir com chão)
wall_slide_speed = 2;
is_wall_sliding = false;
wall_dir = 0;

wall_coyote_time = 5;
wall_coyote_counter = 0;

wall_jump_force_x = 9;
wall_jump_force_y = -7.5;
wall_jump_lock = 0;
wall_jump_lock_time = 10;

wall_jump_used_dir = 0;
wall_touch_prev = false;

// --- WALL RELEASE BUFFER (soltar segurando o lado contrário) ---
wall_release_time = 12;   // frames segurando a direção contrária pra soltar da parede
wall_release_counter = 0;

// --- WALL JUMP EM 2 ESTÁGIOS (1 pra cima, 1 pra longe) ---
wall_jump_stage = 0;      // 0 = nenhum usado, 1 = já fez o pulo pra cima (pode fazer o pra longe), 2 = já usou os dois

// --- CARREGA ARMA PERSISTENTE ENTRE ROOMS ---
if (!variable_global_exists("owned_weapons")) {
    global.owned_weapons = [];
    global.current_weapon_index = -1;
}
scr_refresh_equipped_weapon();

// ============================
// ARMA / COMBATE
// ============================
is_attacking = false;
attack_timer = 0;
attack_duration = 20;       // frames que o ataque dura
attack_cooldown = 0;
attack_cooldown_max = 20;

weapon_angle = 0;           // ângulo atual da arma (pra animar o swing)
weapon_offset_x = 4;       // distância da arma em relação ao player (ajusta visualmente depois)
weapon_offset_y = -24;

// Hitbox do ataque
attack_hitbox_width = 20;
attack_hitbox_height = 24;

// --- ARREMESSO DE ARMA ---
throw_cooldown = 0;
throw_cooldown_max = 45;

// ============================
// VIDA
// ============================
if (!variable_global_exists("bonus_hearts")) {
    global.bonus_hearts = 0;
}

max_hp = 3 + global.bonus_hearts;
hp = max_hp;

hp_invuln_time = 60;      // ~1s de invencibilidade após tomar dano
hp_invuln_timer = 0;

knockback_force = 6;
// --- Animação / Sprite ---
facing = "right";
state = "idle";

// --- VISUAL: CORPO ESPECTRAL (CABEÇA FLUTUANTE) ---
spirit_bob_timer = 0;
spirit_bob_speed = 0.05;
spirit_bob_height = 8; // amplitude do flutuar
visual_float_height = 40; // distância visual entre o "pé" (x,y real) e a cabeça

// --- TELECINESE NOS ATAQUES ---
telekinesis_push_x = 40;      // quanto a arma se afasta no eixo X durante bonk/forte
telekinesis_orbit_speed = 6;  // graus por frame que as partículas giram
telekinesis_orbit_radius = 18;
telekinesis_angle = 0;

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

// --- ANIMAÇÃO DE ARREMESSO (arpão) ---
is_throwing = false;
throw_anim_timer = 0;
throw_anim_duration = 12; // ajusta pra bater com a quantidade de frames do arpaoShot_spr

// --- ATAQUE FORTE (R) ---
is_heavy_attacking = false;
heavy_attack_timer = 0;
heavy_cooldown = 0;
heavy_cooldown_max = 50;

// Tesoura: swep largo e mais lento
sweep_duration = 30;
sweep_angle_start = 100;
sweep_angle_end = -100;
sweep_extra_reach = 20; // quanto a arma "se afasta" do corpo durante o giro

// Arpão: estocada rápida com lunge
stab_duration = 18;
stab_lunge_speed = 7;
stab_reach = 30;
stab_angle_offset = -35; // ajusta até a lança ficar reta/horizontal

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

// ============================
// UI DE TROCA DE ARMA (ajusta esses valores à vontade)
// ============================
weapon_ui_slot_size = 60;
weapon_ui_spacing = 8;
weapon_ui_x = 20;
weapon_ui_y = 100;          // ajusta pra não bater na barra de vida/dash

weapon_ui_bg_color = c_black;
weapon_ui_bg_alpha = 0.5;
weapon_ui_border_color = c_white;
weapon_ui_selected_color = c_yellow;
weapon_ui_icon_padding = 0.7; // % do slot que o ícone ocupa (0.7 = 70%)
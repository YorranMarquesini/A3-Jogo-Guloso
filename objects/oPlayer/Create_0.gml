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
grav = 0.35;
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
dash_cooldown_max = 20;
dash_dir_x = 0;
dash_dir_y = 0;

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

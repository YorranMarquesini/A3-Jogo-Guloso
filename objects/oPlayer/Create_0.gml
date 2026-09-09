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
// WALL INTERACTION
// ============================
wall_check_dist = 2;
wall_slide_speed = 2;
is_wall_sliding = false;
wall_dir = 0;

wall_coyote_time = 5;
wall_coyote_counter = 0;

wall_jump_force_x = 6;
wall_jump_force_y = -7.5;
wall_jump_lock = 0;
wall_jump_lock_time = 10;

wall_jump_used_dir = 0;
wall_touch_prev = false;
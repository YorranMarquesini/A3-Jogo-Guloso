// Movimento horizontal
hsp = 0;
move_speed = 4;
acc = 0.5;      // aceleração
dec = 0.5;      // desaceleração (fricção no chão)
air_acc = 0.35; // aceleração no ar (um pouco menor)

// Vertical / pulo
vsp = 0;
grav = 0.35;
jump_force = -8;
max_fall = 10;

// Coyote time (permite pular um pouco depois de sair da plataforma)
coyote_time = 6;
coyote_counter = 0;

// Jump buffer (permite apertar pulo um pouco antes de tocar o chão)
jump_buffer = 6;
jump_buffer_counter = 0;

// Pulo variável (solta o botão = pulo mais curto)
jump_cut_multiplier = 0.5;

// Double jump
max_jumps = 2;
jump_count = 0;

// Dash
can_dash = true;
is_dashing = false;
dash_speed = 12;
dash_time = 8;        // duração do dash em frames
dash_timer = 0;
dash_cooldown = 0;
dash_cooldown_max = 20; // tempo até poder dar dash de novo
dash_dir_x = 0;
dash_dir_y = 0;
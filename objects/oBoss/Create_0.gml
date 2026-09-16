// --- ESTADO ---
state = "idle";       // idle, attack_windup, transforming, idle2
phase = 1;

// --- VIDA / HITS ---
hp = 35;
invuln_timer = 0;
invuln_time = 20;      // frames de invencibilidade após cada hit (evita 1 golpe contar 2x)

// --- ATAQUE ---
attack_cooldown = 0;
attack_cooldown_max = 40;   // ~1s entre ataques (60fps)
attack_windup = 0;
attack_windup_time = 10;    // tempo de "preparação" antes de soltar o projétil
hittable = true;

// --- TRANSFORMAÇÃO ---
transform_timer = 0;
transform_duration = 40;
hit_flash_timer = 0;

sprite_index = boss1_idle_spr;
image_speed = 1;
// --- ESTADO ---
state = "idle";       // idle, attack_windup, transforming, idle2
phase = 1;
oEnemy.material = "plastico";

// --- VIDA / HITS ---
hp = 2;
invuln_timer = 0;
invuln_time = 20;      // frames de invencibilidade após cada hit (evita 1 golpe contar 2x)

// --- ATAQUE ---
attack_cooldown = 0;
attack_cooldown_max = 40;   // ~0.8s entre ataques (60fps)
attack_windup = 0;
attack_windup_time = 10;    // tempo de "preparação" antes de soltar o projétil
hittable = true;

// --- TRANSFORMAÇÃO ---
transform_timer = 0;
transform_duration = 40;
hit_flash_timer = 0;

sprite_index = boss1_idle_spr;
image_speed = 1;

// --- ATAQUES FASE 2 ---
phase2_attack_cooldown = 90;
phase2_attack_cooldown_max = 150;
water_projectile = noone;

// Ponto de onde o jato d'água nasce (ajusta até bater com a boca)
water_spawn_offset_x = 50;
water_spawn_offset_y = 190;
water_spawned = false;

// Ataque de olho caindo
warning_started = false;
eyedrop_warning_time = 60;
eyedrop_warning_timer = 0;

// --- MORTE ---
phase2_max_hp = 60;
death_duration = 90;
death_timer = 0;
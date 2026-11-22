// Cagliostro começa travado: a cutscene libera o combate.
state = "cutscene";
phase = 2;
material = "organico";
hp = 80;
max_hp = hp;
hittable = false;
invuln_timer = 0;
invuln_time = 16;
hit_flash_timer = 0;

// A poluição deixada na fase 2 acelera os ataques do Cagliostro.
if (!variable_global_exists("fase2_pollution_pct")) global.fase2_pollution_pct = 100;
boss_speed_multiplier = scr_get_pollution_speed_bonus(global.fase2_pollution_pct);

attack_timer = 90;
attack_cooldown_min = 70;
attack_cooldown_max = 150;
attack_kind = 0;
attack_fired = false;
last_attack_kind = -1;
attack_repeat_count = 0;
max_attack_repeats = 3;

// Rajada de fumaça: cada ataque sorteia de 3 a 6 disparos. O intervalo
// deixa uma janela para o jogador pousar e preparar a próxima esquiva.
smoke_shots_remaining = 0;
smoke_shot_timer = 0;
smoke_shot_interval_min = 52;
smoke_shot_interval_max = 64;
smoke_end_lag = 28;

// Bônus por completar os coletáveis das fases anteriores.
// O projeto trabalha a 60 FPS: 30 s = 1800 frames; 60 s = 3600 frames.
smoke_break_cooldown = 0;
smoke_break_cooldown_max = 30 * 60;
hat_break_cooldown = 0;
hat_break_cooldown_max = 60 * 60;
hat_disabled_timer = 0;
hat_disabled_duration = 30 * 60;
hat_cut_flash_timer = 0;
hat_cut_flash_duration = 22;

if (!variable_global_exists("fase1_collectibles_complete")) {
    global.fase1_collectibles_complete = false;
}
if (!variable_global_exists("fase2_collectibles_complete")) {
    global.fase2_collectibles_complete = false;
}

death_duration = 100;
death_timer = death_duration;

sprite_index = spr_cagliostro_talk;
image_speed = 0.22;
// A escala é configurada na room para permitir o enquadramento gigante da arena.

// O script de dano compartilhado espera esta variável.
phase2_max_hp = max_hp;

// Na IDE o GameMaker usa a mesma seed a cada execução; sorteamos uma vez.
if (!variable_global_exists("cagliostro_rng_ready")) {
    randomise();
    global.cagliostro_rng_ready = true;
}

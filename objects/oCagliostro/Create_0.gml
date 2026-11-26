// No retry, a arena recomeca direto sem repetir a apresentacao.
// Só conta como retry se a morte aconteceu NESTA arena.
var _retrying_boss = variable_global_exists("boss_retry_no_cutscene")
                  && global.boss_retry_no_cutscene
                  && variable_global_exists("boss_retry_room")
                  && global.boss_retry_room == room;
if (!_retrying_boss) global.boss_retry_no_cutscene = false;
state = _retrying_boss ? "combat" : "cutscene";
// Fase 1: fumaça + chapéu. Ao zerar a vida, scr_try_hit_enemy coloca o
// estado em "transforming" (mesma lógica do boss da fase 1) e ele volta
// com vida cheia na fase 2, fazendo chover dinheiro.
phase = 1;
material = "organico";
hp = 80;
max_hp = hp;
phase1_max_hp = hp;

// --- TRANSFORMAÇÃO ---
transform_timer = 0;
transform_duration = 10;       // frames parado no último quadro antes de voltar a lutar
transform_started = false;

// --- FASE 2: CHUVA DE DINHEIRO ---
money_spawn_timer = 0;
money_spawn_min = 14;
money_spawn_max = 26;
hittable = _retrying_boss;
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

// Fase 2: cospe bolas de fogo (spr_cagliostro_atk1 + oCagliostroFire).
// Cada ataque sorteia de 2 a 4 cuspidas; a animação toca inteira a cada
// disparo e o fogo sai no último quadro (boca aberta).
fire_shots_remaining = 0;
fire_shot_fired = false;
fire_hold_timer = 0;
fire_hold_time = 22;       // quadros segurando a boca aberta após cuspir
fire_speed = 12;

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
final_explosion_started = false;
final_explosion_timer = 0;
final_explosion_duration = 108;

sprite_index = _retrying_boss ? spr_cagliostro_idle : spr_cagliostro_talk;
image_speed = 0.22;
// A escala é configurada na room para permitir o enquadramento gigante da arena.

// Vida da segunda fase (a barra é recarregada durante a transformação).
phase2_max_hp = 100;

// Na IDE o GameMaker usa a mesma seed a cada execução; sorteamos uma vez.
if (!variable_global_exists("cagliostro_rng_ready")) {
    randomise();
    global.cagliostro_rng_ready = true;
}

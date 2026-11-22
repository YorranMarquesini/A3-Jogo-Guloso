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

attack_timer = 90;
attack_cooldown_min = 70;
attack_cooldown_max = 150;
attack_kind = 0;
attack_fired = false;
last_attack_kind = -1;
attack_repeat_count = 0;
max_attack_repeats = 3;
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

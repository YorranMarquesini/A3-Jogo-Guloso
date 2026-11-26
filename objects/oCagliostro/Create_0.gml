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
final_explosion_timer = 0;
final_explosion_duration = 30;
finale_stage = "hold";
finale_time = 0;
finale_qte_window = 1.10;
finale_qte_action = Bind.jump;
finale_actions = [Bind.jump, Bind.dash, Bind.attack];
finale_chart = [0, 1, 0, 2, 1, 2, 0, 1, 2, 0, 2, 1, 0, 1, 2, 0];
// Acentos de percussao do MP3 do chefe, em segundos desde o inicio da faixa.
finale_accents = [
        0.631, 1.476, 2.221, 3.111, 3.801, 4.721, 5.331, 6.131, 6.696, 7.601,
        8.181, 8.886, 9.626, 10.206, 10.791, 11.376, 12.061, 12.686, 13.561, 14.286,
        14.866, 15.451, 16.031, 16.616, 17.201, 18.071, 18.991, 19.526, 20.111, 20.691,
        21.571, 22.441, 23.026, 23.886, 24.771, 25.356, 25.936, 26.516, 27.251, 28.031,
        28.846, 29.431, 30.016, 30.596, 31.176, 31.761, 32.386, 32.971, 33.511, 34.136,
        34.671, 35.301, 35.841, 36.366, 37.141, 37.996, 38.751, 39.336, 40.246, 41.121,
        41.666, 42.286, 42.826, 43.446, 43.996, 44.626, 45.306, 46.036, 46.911, 47.491,
        48.076, 48.651, 49.381, 50.116, 50.986, 51.716, 52.446, 53.316, 54.046, 54.771,
        55.646, 56.226, 57.146, 57.976, 58.706, 59.431, 60.306, 61.036, 61.661, 62.201,
        63.071, 63.656, 64.536, 65.256, 66.126, 66.711, 67.296, 67.871, 68.461, 69.041,
        69.626, 70.251, 70.791, 71.371, 71.951, 72.816, 73.701, 74.281, 74.911, 75.451,
        76.081, 76.616, 77.231, 77.781, 78.361, 78.926, 79.571, 80.111, 80.741, 81.516,
        82.196, 83.081, 83.941, 84.541, 85.086, 85.791, 86.516, 87.251, 88.121, 88.851,
        89.606, 90.451, 91.286, 91.911, 92.546, 93.216, 94.036, 94.721, 95.551, 96.136,
        97.006, 97.886, 98.461, 99.336, 100.211, 100.796, 101.666, 102.206, 102.831, 103.706,
        104.576, 105.306, 106.036, 106.766, 107.491, 108.371, 109.096, 109.836, 110.696, 111.431,
        112.011, 112.591, 113.461, 114.326, 114.921, 115.646, 116.226, 116.851, 117.406, 117.981,
        118.561, 119.286, 120.161, 120.741, 121.391, 122.281, 123.156, 123.951, 124.671, 125.491,
        126.276, 126.911, 127.441, 128.256, 128.841, 129.601, 130.171, 130.861, 131.601, 132.496,
        133.201, 134.001, 134.806, 135.536, 136.316, 137.206, 137.926, 138.656, 139.241, 140.111,
        140.986, 141.856, 142.736, 143.606, 144.186, 144.916, 145.646, 146.516, 147.246, 147.976,
        148.706, 149.431, 150.016, 150.596, 151.176, 151.761, 152.636, 153.506, 154.236, 154.966,
        155.836, 156.566, 157.296, 158.026, 158.751, 159.331, 159.961, 160.501, 161.411, 162.246,
        162.826, 163.456, 164.141, 165.016, 165.741, 166.326, 167.056, 167.821, 168.366, 169.286,
        169.816, 170.696, 171.321, 172.046, 172.781, 173.311, 174.146, 174.776, 175.401, 176.266,
        177.146, 177.956, 178.631, 179.196, 179.726, 180.506, 181.391, 182.061, 182.671, 183.281,
        183.806, 184.391, 185.176, 185.736, 186.291, 187.176, 187.786, 188.341, 189.066, 189.931,
        190.516, 191.231, 191.816, 192.611, 193.216, 194.121, 195.021, 195.886, 196.766, 197.491,
        198.366, 198.956, 199.531, 200.261, 200.986, 201.861, 202.441, 203.171, 203.901, 204.771,
        205.351, 206.081, 206.811, 207.391, 208.266, 209.141, 210.016, 210.741, 211.471, 212.346,
        212.926, 213.661, 214.241, 215.111, 215.841, 216.421, 217.151, 217.736, 218.316, 219.041,
        219.916, 220.501, 221.376, 221.956, 222.541, 223.411, 224.201, 224.731, 225.456, 226.336,
        227.201, 227.936, 228.511, 229.246, 230.116, 230.996, 231.871, 232.736, 233.606, 234.476,
        235.061, 235.791, 236.661, 237.396, 237.976, 238.706, 239.481, 240.356, 240.886, 241.466,
        242.051, 242.636, 243.361, 244.091, 244.736, 245.546, 246.126, 246.716, 247.346, 247.876,
        248.456, 249.041, 249.771, 250.496, 251.376, 251.956, 252.536, 253.121, 253.701, 254.431,
        255.306, 256.036, 256.906, 257.781, 258.366, 259.141, 259.966, 260.696, 261.276, 262.001,
        262.731, 263.376, 264.186, 264.771, 265.351, 265.936, 266.666, 267.191, 267.976, 268.566,
        269.431, 270.221, 270.751, 271.321, 272.206, 273.066, 273.746, 274.381, 275.251, 275.821,
        276.701, 277.361, 278.191, 278.791, 279.636, 280.491, 281.361, 281.986, 282.541, 283.126,
        283.706, 284.581, 285.311, 286.181, 286.916, 287.641, 288.266, 289.091, 289.956, 290.691,
        291.596, 292.121, 292.676, 293.451, 294.336, 294.951, 295.476, 296.211, 296.811, 297.371,
        297.981, 298.771, 299.606, 300.241, 300.916, 301.441, 302.021, 302.686, 303.221, 303.966,
        304.646, 305.376, 306.106, 306.716, 307.301, 307.876, 308.506, 309.046, 309.626, 310.211,
        310.791, 311.371, 312.001, 312.536, 313.121, 313.706, 314.331, 315.156, 316.036, 316.661,
        317.201, 317.781, 318.411, 318.986, 319.531, 320.106, 320.741, 321.276, 321.861, 322.441,
        323.071, 323.646, 324.191, 324.771, 325.351, 325.981, 326.521, 327.146, 327.731, 328.266,
        328.851, 329.476, 330.061, 330.641, 331.181, 331.746, 332.341, 332.926, 333.546, 334.091,
        334.676, 335.476, 336.276, 337.051, 337.631, 338.216, 338.746, 339.381, 339.956, 340.501,
        341.126, 341.711, 342.401, 343.026, 343.606, 344.146, 344.916, 345.826, 346.366, 346.946,
        347.491, 348.061, 348.636, 349.296, 349.856, 350.451, 350.986, 351.566, 352.151, 352.731,
        353.361, 353.941, 354.536, 355.106, 355.696, 356.271, 356.811, 357.431, 357.971, 358.666,
        359.216, 359.761, 360.306, 360.886, 361.471, 362.056, 362.631, 363.261, 363.801, 364.426,
        365.011, 365.546, 366.181, 366.761, 367.296, 367.876, 368.511, 369.086, 369.626, 370.206,
        370.826, 371.371, 371.956, 372.536, 373.181, 374.051, 374.866, 375.491, 376.331, 377.196,
        377.776, 378.491, 379.306, 380.111, 380.696, 381.476, 382.271, 382.831, 383.611, 384.191,
        385.066, 385.651, 386.516, 387.106, 387.976, 388.851, 389.726, 390.601, 391.176, 391.771,
        392.636, 393.511, 394.386, 395.256, 395.841, 396.711, 397.591, 398.171, 398.751, 399.341,
        399.926, 400.501, 401.371, 402.246, 403.026, 403.931, 404.526, 405.271, 405.961, 406.746,
        407.391, 408.026, 408.746, 409.341, 410.021, 410.661, 411.276, 411.846
];
finale_cues = [];
clash_age = 0;
clash_front = 0.5;
finale_music_pos = 0;
finale_hit_window = 0.14;
finale_note = 0;
finale_hits = 0;
finale_track = -1;



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

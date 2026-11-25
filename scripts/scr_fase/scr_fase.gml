// ============================================================
//  scr_fase — recomeçar a fase atual.
// ============================================================

/// @desc Recomeça a fase atual: todo o lixo, os inimigos e o boss
///       voltam pro lugar, como no primeiro segundo da fase.
///
///       AS ARMAS FICAM. Elas são progresso do jogo inteiro, não da
///       fase: a tesoura e o arpão são pegos em pickups espalhados
///       pelo mapa, e na sala do boss não existe nenhum. Se a morte
///       tirasse as armas, morrer no boss deixava a luta impossível
///       de ganhar — você reaparecia desarmado numa sala sem pickup.
function scr_reiniciar_fase() {

    // Nas arenas, o retry volta ao primeiro segundo da LUTA, mas a
    // apresentacao do chefe nao deve tocar outra vez.
    var _retry_de_chefe = (room == BossRoom || room == Fase2Boss);
    global.boss_retry_no_cutscene = _retry_de_chefe;

    // Encerra a faixa antiga. A nova sala inicia o tema desde o zero.
    if (variable_global_exists("cagliostro_music")
    &&  global.cagliostro_music != noone
    &&  audio_is_playing(global.cagliostro_music)) {
        audio_stop_sound(global.cagliostro_music);
    }
    global.cagliostro_music = noone;

    // ---- o que VOLTA sozinho ----
    // Lixo, inimigos, boss e pickups são instâncias da sala: o
    // room_restart() lá embaixo recria todos, cheios de vida.

    // ---- o que a gente zera na mão ----
    // Na exploracao, coracoes extras pertencem a tentativa daquela fase.
    // Na arena, eles ja foram conquistados e precisam sobreviver ao retry.
    if (!_retry_de_chefe) global.bonus_hearts = 0;

    // se a barra de poluição existir nesta branch, volta cheia
    if (variable_global_exists("pollution_pct")) {
        global.pollution_pct = 100;
    }

    if (room == Room1) {
        global.fase1_pollution_pct = 100;
        global.fase1_collectibles_complete = false;
    } else if (room == Fase2) {
        global.fase2_pollution_pct = 100;
        global.fase2_collectibles_complete = false;
    }

    // ---- o que NÃO se mexe ----
    // global.owned_weapons e global.current_weapon_index ficam
    // intactos de propósito. Não apague estas linhas de comentário
    // achando que faltou zerar: é intencional.

    // ---- descongela e reconstrói a sala ----
    // O oGameOver congela o jogo com instance_deactivate_all().
    // Sem reativar antes, as instâncias ficariam penduradas.
    instance_activate_all();

    room_restart();
}


/// @desc Volta pro menu principal. Aqui sim zera TUDO, inclusive as
///       armas: sair pro menu é começar um jogo novo do zero.
function scr_voltar_ao_menu() {
    if (variable_global_exists("gameplay_music_handle")
    &&  global.gameplay_music_handle != noone
    &&  audio_is_playing(global.gameplay_music_handle)) {
        audio_stop_sound(global.gameplay_music_handle);
    }
    global.gameplay_music_handle = noone;

    if (variable_global_exists("cagliostro_music")
    &&  global.cagliostro_music != noone
    &&  audio_is_playing(global.cagliostro_music)) {
        audio_stop_sound(global.cagliostro_music);
    }
    global.cagliostro_music = noone;
    global.boss_retry_no_cutscene = false;
    global.fase2_landing_pending = false;
    global.player_cutscene_locked = false;
    global.bonus_hearts         = 0;
    global.owned_weapons        = [];
    global.current_weapon_index = -1;
    global.pollution_pct        = 100;
    global.fase1_pollution_pct  = 100;
    global.fase2_pollution_pct  = 100;
    global.fase1_collectibles_complete = false;
    global.fase2_collectibles_complete = false;

    instance_activate_all();
    room_goto(rm_menu);
}

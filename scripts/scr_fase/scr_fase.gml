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

    // ---- o que VOLTA sozinho ----
    // Lixo, inimigos, boss e pickups são instâncias da sala: o
    // room_restart() lá embaixo recria todos, cheios de vida.

    // ---- o que a gente zera na mão ----
    // Corações extras são conquista DESTA fase (junta todo o lixo),
    // então reiniciar a fase devolve eles pro estado inicial.
    global.bonus_hearts = 0;

    // se a barra de poluição existir nesta branch, volta cheia
    if (variable_global_exists("pollution_pct")) {
        global.pollution_pct = 100;
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
    global.bonus_hearts         = 0;
    global.owned_weapons        = [];
    global.current_weapon_index = -1;

    instance_activate_all();
    room_goto(rm_menu);
}

// Barra de poluição da fase atual. O valor representa o quanto ainda falta
// purificar: 100 = nenhum coletável pego; 0 = todos coletados.
tracked_room = room;
// Calculado no primeiro Step, quando todas as instâncias da sala já existem.
total_collectibles = -1;

bar_x = 20;
bar_y = 92;
bar_width = 260;
bar_height = 32;

global.pollution_pct = 100;

if (tracked_room == Fase2) {
    global.fase2_pollution_pct = 100;
} else {
    global.fase1_pollution_pct = 100;
}

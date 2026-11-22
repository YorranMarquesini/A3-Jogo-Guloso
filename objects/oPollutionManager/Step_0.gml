var _remaining = instance_number(oTrashCollectible);
if (total_collectibles < 0) total_collectibles = max(1, _remaining);
var _pollution = clamp((_remaining / max(total_collectibles, 1)) * 100, 0, 100);

global.pollution_pct = _pollution;

if (tracked_room == Fase2) {
    global.fase2_pollution_pct = _pollution;
} else {
    global.fase1_pollution_pct = _pollution;
}

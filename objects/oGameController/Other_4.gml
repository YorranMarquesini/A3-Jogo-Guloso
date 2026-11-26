if (room == BossRoom) {
    if (!variable_global_exists("boss1_briefing_seen") || !global.boss1_briefing_seen) {
        global.boss1_briefing_seen = true;
        instance_create_depth(0, 0, -12000, oBossBriefing);
    }
} else if (room == Room1) {
    instance_create_depth(489, 810, -900, oCombatHint);
    var _heavy_hint = instance_create_depth(706, 1024, -900, oCombatHint);
    _heavy_hint.action = Bind.heavy;
}

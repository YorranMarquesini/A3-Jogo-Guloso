if (room == Tutoras) {
    if (!instance_exists(oStageTransition)) {
        // Fora de -16000 a 16000, o GameMaker roda o Step sem desenhar.
        var _transition = instance_create_depth(0, 0, -12000, oStageTransition);
        _transition.target_room = Room1;
        _transition.stage_transition_type = 1;
        _transition.duration_out = 300;
        _transition.duration_in = 78;
    }
} else if (room == Room1) {
    room_goto(BossRoom);
} else if (room == Fase2) {
    room_goto(Fase2Boss);
}

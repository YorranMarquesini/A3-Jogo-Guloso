function scr_get_pollution_speed_bonus(_pct) {
    // Retorna o MULTIPLICADOR de velocidade do boss (1 = normal)
    if (_pct >= 100) {
        return 2.0;   // +100%
    } else if (_pct >= 75) {
        return 1.6;   // +60%
    } else if (_pct >= 50) {
        return 1.3;   // +30%
    } else if (_pct > 0) {
        return 1.1;   // +10%
    }
    return 1.0;       // sem poluição sobrando = sem bônus
}
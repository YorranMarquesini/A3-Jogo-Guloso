/// @desc Retorna a velocidade do boss baseada na poluição restante.
/// @param pollution_pct 0 = local limpo; 100 = totalmente poluído.
function scr_get_pollution_speed_bonus(_pollution_pct) {
    var _pollution = clamp(_pollution_pct / 100, 0, 1);
    return lerp(1, 2, _pollution);
}

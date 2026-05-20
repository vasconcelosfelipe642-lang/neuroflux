/// Controla confete de 100% do dia — uma vez por sessão do app.
abstract final class DayConfettiSession {
  static bool shown = false;

  static bool tryShow() {
    if (shown) return false;
    shown = true;
    return true;
  }
}

abstract final class TimeAgo {
  static String format(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inHours < 1) {
      final m = diff.inMinutes;
      return 'Há $m ${m == 1 ? 'minuto' : 'minutos'}';
    }
    if (diff.inDays < 1) {
      final h = diff.inHours;
      return 'Há $h ${h == 1 ? 'hora' : 'horas'}';
    }
    final d = diff.inDays;
    return 'Há $d ${d == 1 ? 'dia' : 'dias'}';
  }
}

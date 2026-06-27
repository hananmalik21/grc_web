abstract final class InterviewStatusCode {
  static const scheduled = 'SCHEDULED';
  static const completed = 'COMPLETED';
  static const cancelled = 'CANCELLED';
  static const rescheduled = 'RESCHEDULED';

  static const all = [scheduled, completed, cancelled, rescheduled];

  static String? normalize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final upper = raw.trim().toUpperCase();
    return all.contains(upper) ? upper : upper;
  }

  static bool isValid(String? raw) {
    if (raw == null) return false;
    return all.contains(raw.trim().toUpperCase());
  }
}

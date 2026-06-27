abstract final class InterviewResultStatus {
  static const pending = 'PENDING';
  static const selected = 'SELECTED';
  static const rejected = 'REJECTED';
  static const onHold = 'ON_HOLD';

  static const all = [pending, selected, rejected, onHold];

  static String? normalize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final upper = raw.trim().toUpperCase();
    return all.contains(upper) ? upper : upper;
  }

  static bool allowsEditAndReject(String? resultStatus) {
    return normalize(resultStatus) == pending;
  }
}

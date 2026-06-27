class RequisitionUiPlaceholder {
  RequisitionUiPlaceholder._();

  static const String value = '--';

  static String text(String? raw) {
    final trimmed = raw?.trim();
    if (trimmed == null || trimmed.isEmpty) return value;
    return trimmed;
  }

  static bool isPlaceholder(String? raw) {
    if (raw == null) return true;
    return raw.trim().isEmpty || raw.trim() == value;
  }
}

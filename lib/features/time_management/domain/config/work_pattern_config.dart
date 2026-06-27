/// Configuration constants for work patterns
class WorkPatternConfig {
  WorkPatternConfig._();

  /// Available pattern types
  static const List<String> patternTypes = ['5-day', '6-day', 'rotating'];

  /// Get display label for pattern type
  static String getPatternTypeLabel(String type) {
    switch (type) {
      case '5-day':
        return '5-Day Week';
      case '6-day':
        return '6-Day Week';
      case 'rotating':
        return 'Rotating Shift Pattern';
      default:
        return type;
    }
  }

  /// Day names
  static const List<String> dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
}

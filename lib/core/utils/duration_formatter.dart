/// Utility functions for formatting duration values
class DurationFormatter {
  DurationFormatter._();

  static String formatHours(double hours) {
    if (hours == hours.roundToDouble()) {
      return hours.toInt().toString();
    }

    final rounded = (hours * 10).round() / 10.0;
    final formatted = rounded.toStringAsFixed(1);
    return formatted.replaceAll(RegExp(r'\.?0+$'), '');
  }
}

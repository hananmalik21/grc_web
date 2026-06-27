class NumberFormatUtils {
  NumberFormatUtils._();

  static String formatDisplayValue(Object value) {
    if (value is int || value is String && int.tryParse(value) != null) {
      return value.toString();
    }
    if (value is double) {
      return value.round().toString();
    }
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed.round().toString();
    }
    return value.toString();
  }

  static String formatDays(num value) {
    return value.toDouble().toString().replaceAll(RegExp(r'\.0$'), '');
  }

  static String formatWithDecimals(num value, {int decimalPlaces = 1}) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(decimalPlaces);
  }
}

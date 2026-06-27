class PhoneNumberUtils {
  PhoneNumberUtils._();

  static const String defaultDialCode = '+965';
  static const String defaultCountryIso = 'KW';

  static const List<String> _gccDialCodes = [
    '+966',
    '+965',
    '+971',
    '+974',
    '+973',
    '+968',
    '+962',
    '+961',
    '+964',
    '+967',
    '+20',
    '+92',
    '+91',
    '+1',
    '+44',
    '+33',
    '+49',
  ];

  static ({String dialCode, String national}) split(String? full) {
    final trimmed = full?.trim() ?? '';
    if (trimmed.isEmpty) {
      return (dialCode: defaultDialCode, national: '');
    }

    for (final code in _gccDialCodes) {
      if (trimmed.startsWith(code)) {
        final national = trimmed.substring(code.length).replaceFirst(RegExp(r'^[\s\-]+'), '');
        return (dialCode: code, national: national);
      }
    }

    final match = RegExp(r'^(\+\d{1,4})(.*)$').firstMatch(trimmed);
    if (match != null) {
      return (dialCode: match.group(1)!, national: match.group(2)!.replaceFirst(RegExp(r'^[\s\-]+'), ''));
    }

    return (dialCode: defaultDialCode, national: trimmed);
  }

  static String combine(String? dialCode, String? national) {
    final nationalTrimmed = national?.trim() ?? '';
    if (nationalTrimmed.isEmpty) {
      return '';
    }
    final dial = dialCode?.trim();
    final effectiveDial = (dial != null && dial.isNotEmpty) ? dial : defaultDialCode;
    return '$effectiveDial $nationalTrimmed';
  }

  static String initialSelectionForPicker(String? dialCode) {
    final dial = dialCode?.trim();
    if (dial != null && dial.isNotEmpty) {
      return dial;
    }
    return defaultCountryIso;
  }
}

import 'package:flutter/services.dart';

/// Input formatters and keyboard types for text fields.
class AppInputFormatters {
  AppInputFormatters._();

  static final TextInputFormatter nameEn = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\.\-']"));
  static final TextInputFormatter nameAr = FilteringTextInputFormatter.allow(RegExp(r"[\u0600-\u06FF\s\.\-']"));
  static final TextInputFormatter nameAny = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\u0600-\u06FF\s\.\-']"));
  static final TextInputFormatter arabicOnly = FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF\s]'));
  static final TextInputFormatter arabicOnlyExtended = FilteringTextInputFormatter.allow(
    RegExp(r'[\u0600-\u06FF\u0750-\u077F\s]'),
  );

  static final TextInputFormatter orgUnitCode = FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9\-_]"));
  static final TextInputFormatter codeOrSlug = FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-_]'));

  static final TextInputFormatter phone = FilteringTextInputFormatter.allow(RegExp(r"[\d\+\-\s\(\)]"));
  static final TextInputFormatter email = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9@._\-]"));

  static const int ibanMaxLength = 34;

  static List<TextInputFormatter> get iban => [
    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
    LengthLimitingTextInputFormatter(ibanMaxLength),
  ];

  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.digitsOnly;
  static TextInputFormatter maxLen(int n) => LengthLimitingTextInputFormatter(n);

  static TextInputFormatter decimalWithOnePlace() => _DecimalInputFormatter(1);
  static TextInputFormatter decimalWithTwoPlaces() => _DecimalInputFormatter(2);
  static TextInputFormatter decimalWithThreePlaces() => _DecimalInputFormatter(3);
  static final TextInputFormatter currencyAmount = _CurrencyAmountFormatter();

  /// Blocks input once the numeric value exceeds [max].
  static TextInputFormatter maxValue(double max) => _MaxValueFormatter(max);
}

/// Formatter lists + keyboard types for common field types.
class FieldFormat {
  FieldFormat._();

  static const TextInputType integer = TextInputType.number;
  static const TextInputType decimal = TextInputType.numberWithOptions(decimal: true);
  static const TextInputType currency = TextInputType.numberWithOptions(decimal: true);
  static const TextInputType email = TextInputType.emailAddress;
  static const TextInputType phone = TextInputType.phone;

  static List<TextInputFormatter> get currencyAmount => [AppInputFormatters.currencyAmount];
  static List<TextInputFormatter> get integerOnly => [AppInputFormatters.digitsOnly];
  static List<TextInputFormatter> get decimalOnePlace => [AppInputFormatters.decimalWithOnePlace()];
  static List<TextInputFormatter> get decimalTwoPlaces => [AppInputFormatters.decimalWithTwoPlaces()];
  static List<TextInputFormatter> get decimalThreePlaces => [AppInputFormatters.decimalWithThreePlaces()];
  static List<TextInputFormatter> get codeOrSlug => [AppInputFormatters.codeOrSlug];
  static List<TextInputFormatter> get nameEn => [AppInputFormatters.nameEn];
  static List<TextInputFormatter> get nameAr => [AppInputFormatters.nameAr];
  static List<TextInputFormatter> get arabicOnlyFormatters => [AppInputFormatters.arabicOnlyExtended];
  static List<TextInputFormatter> get phoneFormatters => [AppInputFormatters.phone];
  static List<TextInputFormatter> get emailFormatters => [AppInputFormatters.email];
}

class _DecimalInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  _DecimalInputFormatter(this.decimalPlaces);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final regex = RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$');
    if (regex.hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}

class _MaxValueFormatter extends TextInputFormatter {
  const _MaxValueFormatter(this.max);

  final double max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final parsed = double.tryParse(newValue.text);
    if (parsed == null) return oldValue;
    if (parsed > max) return oldValue;
    return newValue;
  }
}

class _CurrencyAmountFormatter extends TextInputFormatter {
  static final RegExp _pattern = RegExp(r'^\d+\.?\d{0,3}$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty || _pattern.hasMatch(text)) {
      return newValue;
    }
    return oldValue;
  }
}

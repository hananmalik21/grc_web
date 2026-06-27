import 'package:grc/features/payroll/domain/models/pay_lookup_value.dart';

extension PayLookupValueListExtensions on List<PayLookupValue> {
  PayLookupValue? byCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final value in this) {
      if (value.valueCode.trim().toUpperCase() == normalized) return value;
    }
    return null;
  }

  String? labelForCode(String code) => byCode(code)?.valueName ?? code;
}

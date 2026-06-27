import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustLeaveBalanceValidation {
  String? validate({required Map<String, String> leaves, required String reason}) {
    for (final entry in leaves.entries) {
      final error = _validateRequiredNumber(entry.value, entry.key);
      if (error != null) return error;
    }
    final trimmed = reason.trim();
    if (trimmed.isEmpty) return 'Adjustment reason is required';
    return null;
  }

  String? _validateRequiredNumber(String value, String fieldName) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '$fieldName is required';
    final parsed = double.tryParse(trimmed);
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0) return 'Must be 0 or more';
    return null;
  }
}

final adjustLeaveBalanceValidationProvider = Provider<AdjustLeaveBalanceValidation>((ref) {
  return AdjustLeaveBalanceValidation();
});

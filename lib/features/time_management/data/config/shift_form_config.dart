import 'package:grc/core/enums/time_management_enums.dart';
import 'package:flutter/material.dart';

const String shiftTypeLookupCode = 'SHIFT_TYPE';

class ShiftFormConfig {
  ShiftFormConfig._();

  static List<String> get statusOptions => ShiftStatus.values.map((e) => e.displayName).toList();

  static const Color defaultColor = Color(0xFFFFD700);
}

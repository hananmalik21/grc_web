enum TimeManagementTab { shifts, workPatterns, workSchedules, scheduleAssignments, viewCalendar, publicHolidays }

enum ShiftType {
  day,
  evening,
  night,
  rotating;

  static ShiftType fromString(String value) {
    final normalized = value.toUpperCase().trim();
    switch (normalized) {
      case 'DAY':
        return ShiftType.day;
      case 'EVENING':
        return ShiftType.evening;
      case 'NIGHT':
        return ShiftType.night;
      case 'ROTATING':
        return ShiftType.rotating;
      default:
        return ShiftType.day;
    }
  }

  String get displayName {
    switch (this) {
      case ShiftType.day:
        return 'Day Shift';
      case ShiftType.evening:
        return 'Evening Shift';
      case ShiftType.night:
        return 'Night Shift';
      case ShiftType.rotating:
        return 'Rotating Shift';
    }
  }

  String get apiValue {
    switch (this) {
      case ShiftType.day:
        return 'DAY';
      case ShiftType.evening:
        return 'EVENING';
      case ShiftType.night:
        return 'NIGHT';
      case ShiftType.rotating:
        return 'ROTATING';
    }
  }

  static ShiftType fromDisplayName(String displayName) {
    for (final e in ShiftType.values) {
      if (e.displayName == displayName) return e;
    }
    return ShiftType.day;
  }
}

enum ShiftStatus {
  active,
  inactive;

  static ShiftStatus fromString(String value) {
    final normalized = value.toUpperCase().trim();
    switch (normalized) {
      case 'ACTIVE':
        return ShiftStatus.active;
      case 'INACTIVE':
        return ShiftStatus.inactive;
      default:
        return ShiftStatus.inactive;
    }
  }

  String get displayName {
    switch (this) {
      case ShiftStatus.active:
        return 'ACTIVE';
      case ShiftStatus.inactive:
        return 'INACTIVE';
    }
  }

  bool get isActive => this == ShiftStatus.active;
}

enum HolidayType {
  fixed,
  islamic,
  variable;

  static HolidayType fromString(String value) {
    final normalized = value.toUpperCase().trim();
    switch (normalized) {
      case 'FIXED':
        return HolidayType.fixed;
      case 'ISLAMIC':
        return HolidayType.islamic;
      case 'VARIABLE':
        return HolidayType.variable;
      default:
        return HolidayType.fixed;
    }
  }

  String get displayName {
    switch (this) {
      case HolidayType.fixed:
        return 'FIXED';
      case HolidayType.islamic:
        return 'ISLAMIC';
      case HolidayType.variable:
        return 'VARIABLE';
    }
  }

  String get apiValue {
    switch (this) {
      case HolidayType.fixed:
        return 'FIXED';
      case HolidayType.islamic:
        return 'ISLAMIC';
      case HolidayType.variable:
        return 'VARIABLE';
    }
  }
}

enum HolidayPaymentStatus {
  paid,
  unpaid;

  static HolidayPaymentStatus fromString(String value) {
    final normalized = value.toUpperCase().trim();
    switch (normalized) {
      case 'PAID':
        return HolidayPaymentStatus.paid;
      case 'UNPAID':
        return HolidayPaymentStatus.unpaid;
      default:
        return HolidayPaymentStatus.paid;
    }
  }

  String get displayName {
    switch (this) {
      case HolidayPaymentStatus.paid:
        return 'PAID';
      case HolidayPaymentStatus.unpaid:
        return 'UNPAID';
    }
  }

  String get apiValue {
    switch (this) {
      case HolidayPaymentStatus.paid:
        return 'PAID';
      case HolidayPaymentStatus.unpaid:
        return 'UNPAID';
    }
  }

  bool get isPaid => this == HolidayPaymentStatus.paid;
}

enum WorkScheduleAssignmentMode {
  sameShiftAllDays,
  perDayShift;

  String get apiValue {
    switch (this) {
      case WorkScheduleAssignmentMode.sameShiftAllDays:
        return 'SAME_SHIFT_ALL_DAYS';
      case WorkScheduleAssignmentMode.perDayShift:
        return 'PER_DAY_SHIFT';
    }
  }

  static WorkScheduleAssignmentMode fromApiValue(String value) {
    final normalized = value.toUpperCase().trim();
    switch (normalized) {
      case 'SAME_SHIFT_ALL_DAYS':
        return WorkScheduleAssignmentMode.sameShiftAllDays;
      case 'PER_DAY_SHIFT':
      default:
        return WorkScheduleAssignmentMode.perDayShift;
    }
  }
}

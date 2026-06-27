import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';

/// Domain model for Shift
class Shift {
  final int id;
  final String name;
  final String code;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Duration breakDuration;
  final double totalHours;
  final bool isActive;
  final String? description;
  final List<ShiftDay> workingDays;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Shift({
    required this.id,
    required this.name,
    required this.code,
    required this.startTime,
    required this.endTime,
    required this.breakDuration,
    required this.totalHours,
    required this.isActive,
    this.description,
    required this.workingDays,
    this.createdAt,
    this.updatedAt,
  });
}

/// Domain model for Shift overview (list item)
class ShiftOverview {
  final int id;
  final String name;
  final String nameAr;
  final String code;
  final String startTime;
  final String endTime;
  final double totalHours;
  final int breakHours;
  final ShiftType shiftType;
  final String shiftTypeRaw;
  final ShiftStatus status;
  final String colorHex;
  final String? createdDate;
  final String? createdBy;
  final String? updatedDate;
  final String? updatedBy;

  const ShiftOverview({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.code,
    required this.startTime,
    required this.endTime,
    required this.totalHours,
    required this.breakHours,
    required this.shiftType,
    required this.shiftTypeRaw,
    required this.status,
    required this.colorHex,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
  });

  bool get isActive => status.isActive;

  /// Get icon asset path based on shift type using generated assets
  String get iconPath {
    switch (shiftType) {
      case ShiftType.day:
        return Assets.icons.timeManagement.morning.path;
      case ShiftType.evening:
        return Assets.icons.timeManagement.evening.path;
      case ShiftType.night:
        return Assets.icons.timeManagement.night.path;
      case ShiftType.rotating:
        return Assets.icons.timeManagement.morning.path;
    }
  }

  /// Parse color hex string to Color value
  int get colorValue {
    try {
      final hexColor = colorHex.replaceAll('#', '');
      if (hexColor.length == 6) {
        return int.parse('FF$hexColor', radix: 16);
      }
      return 0xFF000000;
    } catch (e) {
      return 0xFF000000;
    }
  }

  /// Factory method to create ShiftOverview from API response JSON
  factory ShiftOverview.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? defaultValue;
      }
      if (value is num) return value.toInt();
      return defaultValue;
    }

    double parseDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed ?? defaultValue;
      }
      if (value is num) return value.toDouble();
      return defaultValue;
    }

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null) return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    final shiftId = parseInt(json['shift_id'], defaultValue: 0);
    if (shiftId <= 0) {
      throw FormatException('Invalid shift_id: must be greater than 0');
    }

    final shiftCode = parseString(json['shift_code']);
    if (shiftCode.isEmpty) {
      throw FormatException('shift_code is required and cannot be empty');
    }

    final shiftNameEn = parseString(json['shift_name_en']);
    if (shiftNameEn.isEmpty) {
      throw FormatException('shift_name_en is required and cannot be empty');
    }

    final shiftNameAr = parseString(json['shift_name_ar'], defaultValue: shiftNameEn);
    final shiftType = parseString(json['shift_type'], defaultValue: 'DAY');

    final startMinutes = parseInt(json['start_minutes'], defaultValue: 0);
    if (startMinutes < 0 || startMinutes >= 1440) {
      throw FormatException('Invalid start_minutes: must be between 0 and 1439');
    }

    final endMinutes = parseInt(json['end_minutes'], defaultValue: 0);
    if (endMinutes < 0 || endMinutes >= 1440) {
      throw FormatException('Invalid end_minutes: must be between 0 and 1439');
    }

    if (endMinutes <= startMinutes) {
      throw FormatException('Invalid time range: end_minutes must be greater than start_minutes');
    }

    final durationHours = parseDouble(json['duration_hours'], defaultValue: 0.0);
    if (durationHours < 0 || durationHours > 24) {
      throw FormatException('Invalid duration_hours: must be between 0 and 24');
    }

    final breakHours = parseInt(json['break_hours'], defaultValue: 0);
    if (breakHours < 0 || breakHours > durationHours) {
      throw FormatException('Invalid break_hours: must be between 0 and duration_hours');
    }

    final colorHex = parseString(json['color_hex'], defaultValue: '#000000');
    if (!colorHex.startsWith('#') || colorHex.length != 7) {
      throw FormatException('Invalid color_hex: must be in format #RRGGBB');
    }

    final status = parseString(json['status'], defaultValue: 'ACTIVE').toUpperCase();
    if (status != 'ACTIVE' && status != 'INACTIVE') {
      throw FormatException('Invalid status: must be ACTIVE or INACTIVE');
    }

    // Convert minutes to TimeOfDay and format
    TimeOfDay minutesToTimeOfDay(int minutes) {
      final clampedMinutes = minutes.clamp(0, 1439);
      final hours = clampedMinutes ~/ 60;
      final mins = clampedMinutes % 60;
      final validHours = hours.clamp(0, 23);
      final validMins = mins.clamp(0, 59);
      return TimeOfDay(hour: validHours, minute: validMins);
    }

    final startTime = minutesToTimeOfDay(startMinutes);
    final endTime = minutesToTimeOfDay(endMinutes);

    final creationDate = parseString(json['creation_date']);
    final createdBy = parseString(json['created_by']);
    final lastUpdateDate = parseString(json['last_update_date']);
    final lastUpdatedBy = parseString(json['last_updated_by']);

    return ShiftOverview(
      id: shiftId,
      name: shiftNameEn,
      nameAr: shiftNameAr,
      code: shiftCode,
      startTime: startTime.formatted,
      endTime: endTime.formatted,
      totalHours: durationHours,
      breakHours: breakHours,
      shiftType: ShiftType.fromString(shiftType),
      shiftTypeRaw: shiftType,
      status: ShiftStatus.fromString(status),
      colorHex: colorHex,
      createdDate: creationDate.isNotEmpty ? creationDate : null,
      createdBy: createdBy.isNotEmpty ? createdBy : null,
      updatedDate: lastUpdateDate.isNotEmpty ? lastUpdateDate : null,
      updatedBy: lastUpdatedBy.isNotEmpty ? lastUpdatedBy : null,
    );
  }
}

/// Shift working days
enum ShiftDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

/// Time of day model
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  String get formatted {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}

/// Paginated shift response
class PaginatedShifts {
  final List<ShiftOverview> shifts;
  final PaginationInfo pagination;

  const PaginatedShifts({required this.shifts, required this.pagination});
}

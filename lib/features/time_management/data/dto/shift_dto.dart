import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';

class ShiftDto {
  final int shiftId;
  final int tenantId;
  final String shiftCode;
  final String shiftNameEn;
  final String shiftNameAr;
  final String shiftType;
  final int startMinutes;
  final int endMinutes;
  final double durationHours;
  final int breakHours;
  final String colorHex;
  final String status;
  final String creationDate;
  final String createdBy;
  final String lastUpdateDate;
  final String lastUpdatedBy;

  const ShiftDto({
    required this.shiftId,
    required this.tenantId,
    required this.shiftCode,
    required this.shiftNameEn,
    required this.shiftNameAr,
    required this.shiftType,
    required this.startMinutes,
    required this.endMinutes,
    required this.durationHours,
    required this.breakHours,
    required this.colorHex,
    required this.status,
    required this.creationDate,
    required this.createdBy,
    required this.lastUpdateDate,
    required this.lastUpdatedBy,
  });

  factory ShiftDto.fromJson(Map<String, dynamic> json) {
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
      if (value == null || value == 'null') return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    final shiftId = parseInt(json['shift_id'], defaultValue: 0);
    if (shiftId <= 0) {
      throw FormatException('Invalid shift_id: must be greater than 0');
    }

    final tenantId = parseInt(json['tenant_id'], defaultValue: 0);
    if (tenantId <= 0) {
      throw FormatException('Invalid tenant_id: must be greater than 0');
    }

    final shiftCode = parseString(json['shift_code']);
    if (shiftCode.isEmpty) {
      throw FormatException('shift_code is required and cannot be empty');
    }

    final shiftNameEn = parseString(json['shift_name_en']);
    if (shiftNameEn.isEmpty) {
      throw FormatException('shift_name_en is required and cannot be empty');
    }

    final shiftNameAr = parseString(json['shift_name_ar']);

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

    final creationDate = parseString(json['creation_date'], defaultValue: '');
    final createdBy = parseString(json['created_by'], defaultValue: 'SYSTEM');
    final lastUpdateDate = parseString(json['last_update_date'], defaultValue: creationDate);
    final lastUpdatedBy = parseString(json['last_updated_by'], defaultValue: createdBy);

    return ShiftDto(
      shiftId: shiftId,
      tenantId: tenantId,
      shiftCode: shiftCode,
      shiftNameEn: shiftNameEn,
      shiftNameAr: shiftNameAr,
      shiftType: shiftType,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      durationHours: durationHours,
      breakHours: breakHours,
      colorHex: colorHex,
      status: status,
      creationDate: creationDate,
      createdBy: createdBy,
      lastUpdateDate: lastUpdateDate,
      lastUpdatedBy: lastUpdatedBy,
    );
  }

  TimeOfDay _minutesToTimeOfDay(int minutes) {
    final clampedMinutes = minutes.clamp(0, 1439);
    final hours = clampedMinutes ~/ 60;
    final mins = clampedMinutes % 60;

    final validHours = hours.clamp(0, 23);
    final validMins = mins.clamp(0, 59);

    return TimeOfDay(hour: validHours, minute: validMins);
  }

  ShiftOverview toDomain() {
    final startTime = _minutesToTimeOfDay(startMinutes);
    final endTime = _minutesToTimeOfDay(endMinutes);

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

class PaginatedShiftsDto {
  final bool success;
  final List<ShiftDto> data;
  final PaginationMetaDto meta;

  const PaginatedShiftsDto({required this.success, required this.data, required this.meta});

  factory PaginatedShiftsDto.fromJson(Map<String, dynamic> json) {
    final success = (json['success'] ?? json['status']) as bool? ?? true;

    final dataValue = json['data'];
    List<ShiftDto> shifts = [];

    if (dataValue != null) {
      if (dataValue is List) {
        if (dataValue.isNotEmpty) {
          try {
            shifts = dataValue
                .where((item) => item != null && item is Map<String, dynamic>)
                .map((item) {
                  try {
                    return ShiftDto.fromJson(item as Map<String, dynamic>);
                  } catch (e) {
                    return null;
                  }
                })
                .whereType<ShiftDto>()
                .toList();
          } catch (e) {
            shifts = [];
          }
        }
      } else {
        shifts = [];
      }
    }

    final metaValue = json['meta'];
    PaginationMetaDto meta;

    if (metaValue != null && metaValue is Map<String, dynamic>) {
      try {
        meta = PaginationMetaDto.fromJson(metaValue);
      } catch (e) {
        meta = PaginationMetaDto(
          pagination: PaginationInfoDto(
            page: 1,
            pageSize: shifts.length,
            total: shifts.length,
            totalPages: 1,
            hasNext: false,
            hasPrevious: false,
          ),
        );
      }
    } else {
      meta = PaginationMetaDto(
        pagination: PaginationInfoDto(
          page: 1,
          pageSize: shifts.length,
          total: shifts.length,
          totalPages: 1,
          hasNext: false,
          hasPrevious: false,
        ),
      );
    }

    return PaginatedShiftsDto(success: success, data: shifts, meta: meta);
  }
}

class PaginationMetaDto {
  final PaginationInfoDto pagination;

  const PaginationMetaDto({required this.pagination});

  factory PaginationMetaDto.fromJson(Map<String, dynamic> json) {
    final paginationValue = json['pagination'];

    if (paginationValue == null || paginationValue is! Map<String, dynamic>) {
      throw FormatException('pagination field is required and must be a Map');
    }

    return PaginationMetaDto(pagination: PaginationInfoDto.fromJson(paginationValue));
  }
}

class PaginationInfoDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationInfoDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfoDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {required int defaultValue, int min = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value < min ? defaultValue : value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return (parsed != null && parsed >= min) ? parsed : defaultValue;
      }
      if (value is num) {
        final intValue = value.toInt();
        return intValue >= min ? intValue : defaultValue;
      }
      return defaultValue;
    }

    bool parseBool(dynamic value, {bool defaultValue = false}) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is num) return value != 0;
      return defaultValue;
    }

    final page = parseInt(json['page'], defaultValue: 1, min: 1);

    final pageSize = parseInt(json['page_size'] ?? json['limit'], defaultValue: 10, min: 1);

    final total = parseInt(json['total'], defaultValue: 0, min: 0);

    final apiTotalPages = parseInt(json['total_pages'], defaultValue: 0, min: 0);
    final totalPages = apiTotalPages > 0 ? apiTotalPages : (total > 0 && pageSize > 0 ? (total / pageSize).ceil() : 0);

    final hasNext = parseBool(json['has_next'] ?? json['hasMore'], defaultValue: false);
    final hasPrevious = page > 1;

    return PaginationInfoDto(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

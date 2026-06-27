import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/public_holiday.dart';

class PublicHolidayModel {
  final int holidayId;
  final int tenantId;
  final String holidayNameEn;
  final String holidayNameAr;
  final String holidayDate;
  final int holidayYear;
  final String holidayType;
  final String descriptionEn;
  final String descriptionAr;
  final String appliesTo;
  final String status;
  final String creationDate;
  final String createdBy;
  final String lastUpdateDate;
  final String lastUpdatedBy;

  const PublicHolidayModel({
    required this.holidayId,
    required this.tenantId,
    required this.holidayNameEn,
    required this.holidayNameAr,
    required this.holidayDate,
    required this.holidayYear,
    required this.holidayType,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.appliesTo,
    required this.status,
    required this.creationDate,
    required this.createdBy,
    required this.lastUpdateDate,
    required this.lastUpdatedBy,
  });

  factory PublicHolidayModel.fromJson(Map<String, dynamic> json) {
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

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null) return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value.trim();
      return value.toString().trim();
    }

    return PublicHolidayModel(
      holidayId: parseInt(json['holiday_id'], defaultValue: 0),
      tenantId: parseInt(json['tenant_id'], defaultValue: 0),
      holidayNameEn: parseString(json['holiday_name_en']),
      holidayNameAr: parseString(json['holiday_name_ar']),
      holidayDate: parseString(json['holiday_date']),
      holidayYear: parseInt(json['holiday_year'], defaultValue: DateTime.now().year),
      holidayType: parseString(json['holiday_type'], defaultValue: 'PUBLIC'),
      descriptionEn: parseString(json['description_en']),
      descriptionAr: parseString(json['description_ar']),
      appliesTo: parseString(json['applies_to'], defaultValue: 'ALL'),
      status: parseString(json['status'], defaultValue: 'ACTIVE'),
      creationDate: parseString(json['creation_date']),
      createdBy: parseString(json['created_by'], defaultValue: 'SYSTEM'),
      lastUpdateDate: parseString(json['last_update_date']),
      lastUpdatedBy: parseString(json['last_updated_by'], defaultValue: 'SYSTEM'),
    );
  }

  /// Convert to domain entity (handles all parsing and transformations)
  PublicHoliday toEntity() {
    DateTime parseDate(String dateString) {
      try {
        return DateTime.parse(dateString).toLocal();
      } catch (e) {
        return DateTime.now();
      }
    }

    HolidayType mapHolidayType(String type) {
      final upperType = type.toUpperCase();
      if (upperType.contains('ISLAMIC') || upperType.contains('EID') || upperType.contains('RAMADAN')) {
        return HolidayType.islamic;
      }
      if (upperType.contains('VARIABLE')) {
        return HolidayType.variable;
      }
      return HolidayType.fixed;
    }

    HolidayPaymentStatus paymentStatus = HolidayPaymentStatus.paid;

    return PublicHoliday(
      id: holidayId,
      tenantId: tenantId,
      nameEn: holidayNameEn,
      nameAr: holidayNameAr,
      date: parseDate(holidayDate),
      year: holidayYear,
      type: mapHolidayType(holidayType),
      paymentStatus: paymentStatus,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      appliesTo: appliesTo,
      isActive: status.toUpperCase() == 'ACTIVE',
      createdAt: creationDate.isNotEmpty ? parseDate(creationDate) : null,
      createdBy: createdBy.isNotEmpty ? createdBy : null,
      updatedAt: lastUpdateDate.isNotEmpty ? parseDate(lastUpdateDate) : null,
      updatedBy: lastUpdatedBy.isNotEmpty ? lastUpdatedBy : null,
    );
  }

  /// Create data model from domain entity
  factory PublicHolidayModel.fromEntity(PublicHoliday entity) {
    String formatDate(DateTime? date) {
      if (date == null) return '';
      return date.toUtc().toIso8601String();
    }

    String mapHolidayTypeToApi(HolidayType type) {
      switch (type) {
        case HolidayType.fixed:
          return 'FIXED';
        case HolidayType.islamic:
          return 'ISLAMIC';
        case HolidayType.variable:
          return 'VARIABLE';
      }
    }

    return PublicHolidayModel(
      holidayId: entity.id,
      tenantId: entity.tenantId,
      holidayNameEn: entity.nameEn,
      holidayNameAr: entity.nameAr,
      holidayDate: formatDate(entity.date),
      holidayYear: entity.year,
      holidayType: mapHolidayTypeToApi(entity.type),
      descriptionEn: entity.descriptionEn,
      descriptionAr: entity.descriptionAr,
      appliesTo: entity.appliesTo,
      status: entity.isActive ? 'ACTIVE' : 'INACTIVE',
      creationDate: formatDate(entity.createdAt),
      createdBy: entity.createdBy ?? 'SYSTEM',
      lastUpdateDate: formatDate(entity.updatedAt),
      lastUpdatedBy: entity.updatedBy ?? 'SYSTEM',
    );
  }
}

/// Data model for paginated holidays response
class PaginatedHolidaysModel {
  final bool status;
  final String message;
  final List<PublicHolidayModel> data;
  final PaginationMetaModel meta;

  const PaginatedHolidaysModel({required this.status, required this.message, required this.data, required this.meta});

  factory PaginatedHolidaysModel.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as bool? ?? true;
    final message = json['message'] as String? ?? '';

    List<PublicHolidayModel> holidays = [];
    final dataValue = json['data'];
    if (dataValue != null && dataValue is List) {
      holidays = dataValue.whereType<Map<String, dynamic>>().map((item) => PublicHolidayModel.fromJson(item)).toList();
    }

    PaginationMetaModel meta;
    final metaValue = json['meta'];
    if (metaValue != null && metaValue is Map<String, dynamic>) {
      meta = PaginationMetaModel.fromJson(metaValue);
    } else {
      meta = PaginationMetaModel(
        pagination: PaginationInfoModel(page: 1, limit: holidays.length, total: holidays.length, hasMore: false),
      );
    }

    return PaginatedHolidaysModel(status: status, message: message, data: holidays, meta: meta);
  }

  /// Convert to domain entity
  PaginatedHolidays toEntity() {
    return PaginatedHolidays(
      holidays: data.map((model) => model.toEntity()).toList(),
      pagination: meta.pagination.toEntity(),
    );
  }
}

/// Pagination meta model
class PaginationMetaModel {
  final PaginationInfoModel pagination;

  const PaginationMetaModel({required this.pagination});

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    final paginationValue = json['pagination'];
    if (paginationValue != null && paginationValue is Map<String, dynamic>) {
      return PaginationMetaModel(pagination: PaginationInfoModel.fromJson(paginationValue));
    }
    return PaginationMetaModel(pagination: PaginationInfoModel(page: 1, limit: 10, total: 0, hasMore: false));
  }
}

/// Pagination info model
class PaginationInfoModel {
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  const PaginationInfoModel({required this.page, required this.limit, required this.total, required this.hasMore});

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
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

    bool parseBool(dynamic value, {bool defaultValue = false}) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is num) return value != 0;
      return defaultValue;
    }

    return PaginationInfoModel(
      page: parseInt(json['page'], defaultValue: 1),
      limit: parseInt(json['limit'], defaultValue: 10),
      total: parseInt(json['total'], defaultValue: 0),
      hasMore: parseBool(json['hasMore'], defaultValue: false),
    );
  }

  /// Convert to domain entity
  PaginationInfo toEntity() {
    return PaginationInfo(
      currentPage: page,
      pageSize: limit,
      totalItems: total,
      totalPages: (total / limit).ceil(),
      hasNext: hasMore,
      hasPrevious: page > 1,
    );
  }
}

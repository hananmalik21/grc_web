import 'package:grc/features/leave_management/data/dto/leave_request_dto.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';

class PaginatedLeaveRequestsDto {
  final bool success;
  final String message;
  final PaginationMetaDto meta;
  final List<LeaveRequestDto> data;

  const PaginatedLeaveRequestsDto({
    required this.success,
    required this.message,
    required this.meta,
    required this.data,
  });

  factory PaginatedLeaveRequestsDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};

    return PaginatedLeaveRequestsDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      meta: PaginationMetaDto.fromJson(metaJson),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => LeaveRequestDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  PaginatedLeaveRequests toDomain() {
    return PaginatedLeaveRequests(requests: data.map((dto) => dto.toDomain()).toList(), pagination: meta.toDomain());
  }
}

class PaginatedLeaveRequests {
  final List<TimeOffRequest> requests;
  final PaginationInfo pagination;

  const PaginatedLeaveRequests({required this.requests, required this.pagination});
}

class PaginationMetaDto {
  final int total;
  final PaginationInfoDto pagination;

  const PaginationMetaDto({required this.total, required this.pagination});

  factory PaginationMetaDto.fromJson(Map<String, dynamic> json) {
    return PaginationMetaDto(
      total: (json['total'] as num?)?.toInt() ?? 0,
      pagination: PaginationInfoDto.fromJson(json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }

  PaginationInfo toDomain() {
    return pagination.toDomain();
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
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value) ?? defaultValue;
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
      return defaultValue;
    }

    return PaginationInfoDto(
      page: parseInt(json['page']),
      pageSize: parseInt(json['page_size']),
      total: parseInt(json['total']),
      totalPages: parseInt(json['total_pages']),
      hasNext: parseBool(json['has_next']),
      hasPrevious: parseBool(json['has_previous']),
    );
  }

  PaginationInfo toDomain() {
    return PaginationInfo(
      currentPage: page,
      totalPages: totalPages,
      totalItems: total,
      pageSize: pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

import 'attendance_summary_dto.dart';

class AttendanceSummaryPaginationDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const AttendanceSummaryPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory AttendanceSummaryPaginationDto.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryPaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 25,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }
}

class AttendanceSummaryResponseDto {
  final AttendanceSummaryPaginationDto? pagination;
  final List<AttendanceSummaryDto> items;

  const AttendanceSummaryResponseDto({required this.pagination, required this.items});

  factory AttendanceSummaryResponseDto.fromApiResponse(dynamic response) {
    Map<String, dynamic>? root;
    if (response is Map<String, dynamic>) {
      root = response;
    }

    final data = root?['data'] ?? response;

    if (data is Map<String, dynamic>) {
      final paginationMap = data['pagination'] is Map<String, dynamic>
          ? data['pagination'] as Map<String, dynamic>
          : null;
      final pagination = paginationMap != null ? AttendanceSummaryPaginationDto.fromJson(paginationMap) : null;

      final list = _extractList(data);
      final items = list
          .whereType<Map>()
          .map((e) => AttendanceSummaryDto.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return AttendanceSummaryResponseDto(pagination: pagination, items: items);
    }

    if (data is List) {
      final items = data
          .whereType<Map>()
          .map((e) => AttendanceSummaryDto.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return AttendanceSummaryResponseDto(pagination: null, items: items);
    }

    if (data is Map && data.containsKey('actual_id')) {
      return AttendanceSummaryResponseDto(
        pagination: null,
        items: [AttendanceSummaryDto.fromJson(Map<String, dynamic>.from(data))],
      );
    }

    return const AttendanceSummaryResponseDto(pagination: null, items: []);
  }

  static List<dynamic> _extractList(Map<String, dynamic> data) {
    final candidates = <dynamic>[data['data'], data['items'], data['records'], data['results']];

    for (final c in candidates) {
      if (c is List) return c;
    }

    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      final inner = nested['data'];
      if (inner is List) return inner;
    }

    return const [];
  }
}

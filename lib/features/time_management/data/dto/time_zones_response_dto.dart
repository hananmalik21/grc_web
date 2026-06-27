class TimeZonesResponseDto {
  final bool status;
  final String message;
  final List<TimeZoneItemDto> data;
  final TimeZonesMetaDto meta;

  const TimeZonesResponseDto({required this.status, required this.message, required this.data, required this.meta});

  factory TimeZonesResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return TimeZonesResponseDto(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataList.map((e) => TimeZoneItemDto.fromJson(e as Map<String, dynamic>)).toList(),
      meta: TimeZonesMetaDto.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class TimeZoneItemDto {
  final String tzName;

  const TimeZoneItemDto({required this.tzName});

  factory TimeZoneItemDto.fromJson(Map<String, dynamic> json) {
    return TimeZoneItemDto(tzName: json['tz_name'] as String? ?? '');
  }
}

class TimeZonesMetaDto {
  final Map<String, dynamic> filters;
  final TimeZonesPaginationDto pagination;

  const TimeZonesMetaDto({required this.filters, required this.pagination});

  factory TimeZonesMetaDto.fromJson(Map<String, dynamic> json) {
    return TimeZonesMetaDto(
      filters: json['filters'] as Map<String, dynamic>? ?? {},
      pagination: TimeZonesPaginationDto.fromJson(json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class TimeZonesPaginationDto {
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  const TimeZonesPaginationDto({required this.page, required this.limit, required this.total, required this.hasMore});

  factory TimeZonesPaginationDto.fromJson(Map<String, dynamic> json) {
    return TimeZonesPaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 25,
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}

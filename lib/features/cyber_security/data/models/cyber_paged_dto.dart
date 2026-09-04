import 'package:grc/core/models/pagination_info.dart';

class CyberPagedDto<T> {
  final List<T> data;
  final PaginationInfo meta;

  const CyberPagedDto({required this.data, required this.meta});

  factory CyberPagedDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parse,
  ) {
    final rawMeta = json['meta'] as Map<String, dynamic>? ?? const {};
    final page = _toInt(rawMeta['page'], fallback: 1);
    final pageSize = _toInt(rawMeta['pageSize'], fallback: 25);
    final total = _toInt(rawMeta['total']);
    final totalPages = _toInt(rawMeta['totalPages'], fallback: 1);
    final rawData = json['data'];
    return CyberPagedDto(
      data: rawData is List
          ? rawData.whereType<Map<String, dynamic>>().map(parse).toList()
          : const [],
      meta: PaginationInfo(
        currentPage: page,
        totalPages: totalPages,
        totalItems: total,
        pageSize: pageSize,
        hasNext: page < totalPages,
        hasPrevious: page > 1,
      ),
    );
  }
}

int _toInt(dynamic value, {int fallback = 0}) => value is num
    ? value.toInt()
    : int.tryParse(value?.toString() ?? '') ?? fallback;

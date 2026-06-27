import 'package:grc/features/workforce_structure/data/models/position_model.dart';
import 'package:grc/features/workforce_structure/domain/models/position_response.dart';

/// Position response model (DTO)
/// Maps the complete API response including metadata and pagination
class PositionResponseModel {
  final bool success;
  final MetaModel meta;
  final List<PositionModel> data;

  const PositionResponseModel({required this.success, required this.meta, required this.data});

  factory PositionResponseModel.fromJson(Map<String, dynamic> json) {
    return PositionResponseModel(
      success: json['success'] as bool? ?? false,
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
      data:
          (json['data'] as List<dynamic>?)?.map((e) => PositionModel.fromJson(e as Map<String, dynamic>)).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'meta': meta.toJson(), 'data': data.map((e) => e.toJson()).toList()};
  }

  /// Convert to domain entity
  PositionResponse toEntity() {
    return PositionResponse(
      positions: data.map((model) => model.toEntity()).toList(),
      totalCount: meta.total,
      page: meta.pagination.page,
      pageSize: meta.pagination.pageSize,
      totalPages: meta.pagination.totalPages,
      hasNext: meta.pagination.hasNext,
      hasPrevious: meta.pagination.hasPrevious,
    );
  }
}

class MetaModel {
  final String version;
  final String timestamp;
  final String requestId;
  final int count;
  final int total;
  final PaginationModel pagination;

  const MetaModel({
    required this.version,
    required this.timestamp,
    required this.requestId,
    required this.count,
    required this.total,
    required this.pagination,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      version: json['api_version'] as String? ?? json['version'] as String? ?? '1.0.0',
      timestamp: json['timestamp'] as String? ?? '',
      requestId: json['request_id'] as String? ?? '',
      count: _asInt(json['count']),
      total: _asInt(json['total']),
      pagination: PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }

  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'timestamp': timestamp,
      'request_id': requestId,
      'count': count,
      'total': total,
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationModel {
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationModel({
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 10,
      totalPages: json['total_pages'] as int? ?? 1,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
      'total_pages': totalPages,
      'has_next': hasNext,
      'has_previous': hasPrevious,
    };
  }
}

import 'package:grc/features/workforce_structure/domain/models/position.dart';

/// Position response domain model
/// Represents the response from fetching positions with pagination info
class PositionResponse {
  final List<Position> positions;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PositionResponse({
    required this.positions,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  PositionResponse copyWith({
    List<Position>? positions,
    int? totalCount,
    int? page,
    int? pageSize,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return PositionResponse(
      positions: positions ?? this.positions,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }
}

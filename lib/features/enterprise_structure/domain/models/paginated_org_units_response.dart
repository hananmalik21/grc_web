import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';

/// Domain model for paginated org units response
class PaginatedOrgUnitsResponse {
  final List<OrgStructureLevel> units;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  const PaginatedOrgUnitsResponse({
    required this.units,
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
}


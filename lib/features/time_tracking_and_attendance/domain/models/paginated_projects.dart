import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/project.dart';

class PaginatedProjects {
  final List<Project> projects;
  final PaginationInfo pagination;
  final int total;
  final int count;

  const PaginatedProjects({
    required this.projects,
    required this.pagination,
    required this.total,
    required this.count,
  });
}


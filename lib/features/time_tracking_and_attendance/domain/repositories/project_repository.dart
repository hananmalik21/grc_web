import 'package:grc/features/time_tracking_and_attendance/domain/models/paginated_projects.dart';

abstract class ProjectRepository {
  Future<PaginatedProjects> getProjects({required int enterpriseId, String? search, int page = 1, int pageSize = 10});
}

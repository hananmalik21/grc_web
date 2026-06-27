import 'package:grc/features/time_tracking_and_attendance/data/datasources/project_remote_data_source.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/paginated_projects.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedProjects> getProjects({
    required int enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final dto = await remoteDataSource.getProjects(
      enterpriseId: enterpriseId,
      search: search,
      page: page,
      pageSize: pageSize,
    );
    return dto.toDomain();
  }
}

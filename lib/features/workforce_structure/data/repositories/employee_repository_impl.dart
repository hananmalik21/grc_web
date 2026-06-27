import 'package:grc/features/workforce_structure/data/datasources/employee_remote_data_source.dart';
import 'package:grc/features/workforce_structure/domain/models/paginated_employees.dart';
import 'package:grc/features/workforce_structure/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedEmployees> getEmployees({
    required int enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final dto = await remoteDataSource.getEmployees(
      enterpriseId: enterpriseId,
      search: search,
      page: page,
      pageSize: pageSize,
    );

    return dto.toDomain();
  }
}

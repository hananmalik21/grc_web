import 'package:grc/features/compensation/data/datasources/employees/employee_compensation_remote_data_source.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_list_page.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employee_compensation_repository.dart';

class EmployeeCompensationRepositoryImpl implements EmployeeCompensationRepository {
  EmployeeCompensationRepositoryImpl({required this.remoteDataSource});

  final EmployeeCompensationRemoteDataSource remoteDataSource;

  @override
  Future<EmployeeCompensationListPage> getEmployeeCompensations({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final dto = await remoteDataSource.getEmployeeCompensations(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: search,
    );

    return EmployeeCompensationListPage(
      items: dto.items.map((e) => e.toDomain()).toList(),
      page: dto.page,
      pageSize: dto.limit,
      total: dto.totalItems,
      totalPages: dto.totalPages,
      hasNext: dto.hasNext,
      hasPrevious: dto.hasPrevious,
    );
  }
}

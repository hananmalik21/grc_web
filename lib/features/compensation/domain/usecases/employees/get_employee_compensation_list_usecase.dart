import 'package:grc/features/compensation/domain/models/employees/employee_compensation_list_page.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employee_compensation_repository.dart';

class GetEmployeeCompensationListUseCase {
  GetEmployeeCompensationListUseCase({required this.repository});

  final EmployeeCompensationRepository repository;

  Future<EmployeeCompensationListPage> call({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  }) {
    return repository.getEmployeeCompensations(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }
}


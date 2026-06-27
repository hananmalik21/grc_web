import '../../models/employees/employees_page.dart';
import '../../repositories/employees/employees_repository.dart';

class GetEmployeesUseCase {
  final EmployeesRepository repository;

  const GetEmployeesUseCase({required this.repository});

  Future<EmployeesPage> call({required int enterpriseId, required int page, required int pageSize, String? search}) {
    return repository.getEmployees(enterpriseId: enterpriseId, page: page, pageSize: pageSize, search: search);
  }
}

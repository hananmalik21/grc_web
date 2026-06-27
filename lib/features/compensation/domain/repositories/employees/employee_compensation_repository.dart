import 'package:grc/features/compensation/domain/models/employees/employee_compensation_list_page.dart';

abstract class EmployeeCompensationRepository {
  Future<EmployeeCompensationListPage> getEmployeeCompensations({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  });
}

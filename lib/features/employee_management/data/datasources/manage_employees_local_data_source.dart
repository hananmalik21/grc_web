import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';

/// Local data source for the Manage Employees list.
/// Provides dummy/offline data for the table.
abstract class ManageEmployeesLocalDataSource {
  List<EmployeeListItem> getEmployees();
}

class ManageEmployeesLocalDataSourceImpl implements ManageEmployeesLocalDataSource {
  @override
  List<EmployeeListItem> getEmployees() {
    return [
      const EmployeeListItem(
        id: '1',
        fullName: 'Khurram K P Shahzad',
        employeeNumber: 'EMP1765637069447',
        position: 'HR Manager',
        department: 'Purchasing',
        status: 'probation',
      ),
      const EmployeeListItem(
        id: '2',
        fullName: 'Zahoor K Khan',
        employeeNumber: 'EMP1765637069448',
        position: 'HR Manager',
        department: 'Purchasing',
        status: 'probation',
      ),
      const EmployeeListItem(
        id: '3',
        fullName: 'Ali G H Shamkhani',
        employeeNumber: 'EMP1765637069449',
        position: 'HR Manager',
        department: 'Purchasing',
        status: 'probation',
      ),
      const EmployeeListItem(
        id: '4',
        fullName: 'Sara Ahmed',
        employeeNumber: 'EMP1765637069450',
        position: 'Finance Analyst',
        department: 'Finance',
        status: 'active',
      ),
      const EmployeeListItem(
        id: '5',
        fullName: 'Omar Hassan',
        employeeNumber: 'EMP1765637069451',
        position: 'IT Specialist',
        department: 'IT',
        status: 'active',
      ),
    ];
  }
}

import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';

abstract class ForfeitPreviewLocalDataSource {
  List<ForfeitPreviewEmployee> getForfeitPreviewEmployees();
}

class ForfeitPreviewLocalDataSourceImpl implements ForfeitPreviewLocalDataSource {
  @override
  List<ForfeitPreviewEmployee> getForfeitPreviewEmployees() {
    return [
      ForfeitPreviewEmployee(
        id: '1',
        employeeId: 'EMP001',
        name: 'Ahmed Al-Mansour',
        department: 'Engineering',
        leaveType: 'Annual Leave',
        totalBalance: 24.5,
        carryLimit: 10.0,
        forfeitDays: -4.5,
        expiryDate: DateTime(2024, 3, 31),
      ),
      ForfeitPreviewEmployee(
        id: '2',
        employeeId: 'EMP002',
        name: 'Sarah Johnson',
        department: 'Marketing',
        leaveType: 'Annual Leave',
        totalBalance: 18.0,
        carryLimit: 10.0,
        forfeitDays: -2.0,
        expiryDate: DateTime(2024, 3, 31),
      ),
      ForfeitPreviewEmployee(
        id: '3',
        employeeId: 'EMP003',
        name: 'Mohammed Ali',
        department: 'Sales',
        leaveType: 'Annual Leave',
        totalBalance: 15.5,
        carryLimit: 10.0,
        forfeitDays: -1.5,
        expiryDate: DateTime(2024, 3, 31),
      ),
    ];
  }
}

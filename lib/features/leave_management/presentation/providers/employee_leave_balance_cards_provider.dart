import 'package:grc/features/leave_management/data/datasources/employee_leave_balance_cards_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_card_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeLeaveBalanceCardsLocalDataSourceProvider = Provider<EmployeeLeaveBalanceCardsLocalDataSource>((ref) {
  return EmployeeLeaveBalanceCardsLocalDataSourceImpl();
});

final employeeLeaveBalanceCardsProvider = Provider<List<LeaveBalanceCardData>>((ref) {
  final localDataSource = ref.watch(employeeLeaveBalanceCardsLocalDataSourceProvider);
  return localDataSource.getLeaveBalanceCards();
});

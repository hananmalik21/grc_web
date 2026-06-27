import 'package:grc/features/leave_management/domain/models/leave_balance_card_data.dart';

abstract class EmployeeLeaveBalanceCardsLocalDataSource {
  List<LeaveBalanceCardData> getLeaveBalanceCards();
}

class EmployeeLeaveBalanceCardsLocalDataSourceImpl implements EmployeeLeaveBalanceCardsLocalDataSource {
  @override
  List<LeaveBalanceCardData> getLeaveBalanceCards() {
    return const [
      LeaveBalanceCardData(leaveTypeLabel: 'Annual', totalDays: 30, usedDays: 12, remainingDays: 18),
      LeaveBalanceCardData(leaveTypeLabel: 'Sick', totalDays: 45, usedDays: 5, remainingDays: 40),
      LeaveBalanceCardData(leaveTypeLabel: 'Hajj', totalDays: 15, usedDays: 0, remainingDays: 15),
      LeaveBalanceCardData(leaveTypeLabel: 'Personal', totalDays: 10, usedDays: 3, remainingDays: 7),
      LeaveBalanceCardData(leaveTypeLabel: 'Emergency', totalDays: 5, usedDays: 1, remainingDays: 4),
    ];
  }
}

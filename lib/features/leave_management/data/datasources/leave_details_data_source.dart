import 'package:intl/intl.dart';

import '../dto/leave_details_dto.dart';

abstract class LeaveDetailsDataSource {
  Future<LeaveDetailsData> getLeaveDetails(String employeeId);
}

class LeaveDetailsDataSourceImpl implements LeaveDetailsDataSource {
  @override
  Future<LeaveDetailsData> getLeaveDetails(String employeeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return LeaveDetailsData(
      employeeData: {'joinDate': '2020-01-15', 'yearsOfService': 6, 'department': 'IT', 'position': 'Senior Developer'},
      summaryByLeaveType: {
        'annualLeave': {'totalAccrued': 180.0, 'totalConsumed': 0.0, 'currentBalance': 23.0, 'entitlement': '30 '},
        'sickLeave': {'totalAccrued': 0.0, 'totalConsumed': 0.0, 'currentBalance': 15.0, 'entitlement': '15 '},
        'unpaidLeave': {'totalAccrued': 0.0, 'totalConsumed': 0.0, 'currentBalance': 0.0, 'entitlement': 'As needed'},
      },
      transactions: _buildTransactions(),
    );
  }

  static List<Map<String, dynamic>> _buildTransactions() {
    final transactions = <Map<String, dynamic>>[];
    final startDate = DateTime(2020, 2, 15);
    double balance = 0.0;
    for (int i = 0; i < 72; i++) {
      final date = DateTime(startDate.year, startDate.month + i, startDate.day);
      const amount = 2.5;
      balance += amount;
      transactions.add({
        'date': date,
        'type': 'Accrual',
        'description': 'Monthly Accrual - ${DateFormat('MMMM yyyy').format(date)}',
        'amount': amount,
        'balance': balance,
      });
    }
    return transactions.reversed.toList();
  }
}

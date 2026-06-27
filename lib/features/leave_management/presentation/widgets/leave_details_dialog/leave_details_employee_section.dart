import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_top_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LeaveDetailsEmployeeSection extends StatelessWidget {
  const LeaveDetailsEmployeeSection({super.key, required this.item, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final bool isDark;

  String _calculateYearsOfService() {
    if (item.joinDate == null) return '0.0';
    final years = DateTime.now().difference(item.joinDate!).inDays / 365.25;
    return years.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14.w,
      children: [
        Expanded(
          child: LeaveDetailsTopCard(
            label: 'Join Date',
            value: item.joinDate != null ? DateFormat('MMM d, yyyy').format(item.joinDate!) : '-',
            isDark: isDark,
          ),
        ),
        Expanded(
          child: LeaveDetailsTopCard(
            label: 'Years of Service',
            value: '${_calculateYearsOfService()} years',
            isDark: isDark,
          ),
        ),
        Expanded(
          child: LeaveDetailsTopCard(label: 'Department', value: item.department, isDark: isDark),
        ),
        // Expanded(
        //   child: LeaveDetailsTopCard(label: 'Position', value: item.position ?? '-', isDark: isDark),
        // ),
      ],
    );
  }
}

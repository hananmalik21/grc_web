import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'attendance_table_row.dart';

class AttendanceTableSkeleton extends StatelessWidget {
  final bool isDark;
  final int rowCount;

  static final AttendanceRecord _skeletonRecord = AttendanceRecord(
    employeeName: 'Loading',
    employeeId: 'EMP-000',
    departmentName: 'Department',
    date: DateTime(2000, 1, 1),
    status: '-',
    avatarInitials: 'L',
  );

  const AttendanceTableSkeleton({super.key, required this.isDark, this.rowCount = 10});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          rowCount,
          (_) => AttendanceTableRow(record: _skeletonRecord, isDark: isDark, isExpanded: false, onToggle: () {}),
        ),
      ),
    );
  }
}

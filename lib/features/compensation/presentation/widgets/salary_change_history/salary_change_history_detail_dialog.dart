import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_config.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_detail_view.dart';
import 'package:flutter/material.dart';

import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalaryChangeHistoryDetailDialog extends StatelessWidget {
  const SalaryChangeHistoryDetailDialog({super.key, required this.row});

  final SalaryChangeHistoryTableRowData row;

  static Future<void> show(BuildContext context, {required SalaryChangeHistoryTableRowData row}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SalaryChangeHistoryDetailDialog(row: row),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Salary Change Details',
      subtitle: row.changeId,
      width: 920.w,
      content: SalaryChangeHistoryDetailView(row: row, layout: SalaryChangeHistoryDetailLayout.desktop),
    );
  }
}

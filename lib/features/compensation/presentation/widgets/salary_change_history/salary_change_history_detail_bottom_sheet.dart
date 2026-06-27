import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_config.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalaryChangeHistoryDetailBottomSheet extends StatelessWidget {
  const SalaryChangeHistoryDetailBottomSheet({super.key, required this.row});

  final SalaryChangeHistoryTableRowData row;

  static Future<void> show(BuildContext context, {required SalaryChangeHistoryTableRowData row}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Salary Change Details',
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 8.h),
        child: SalaryChangeHistoryDetailView(row: row, layout: SalaryChangeHistoryDetailLayout.mobile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SalaryChangeHistoryDetailView(row: row, layout: SalaryChangeHistoryDetailLayout.mobile);
  }
}

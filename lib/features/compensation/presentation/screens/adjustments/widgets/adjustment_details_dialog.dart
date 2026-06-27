import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustment_details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdjustmentDetailsDialog extends StatelessWidget {
  final AdjustmentRowData row;

  const AdjustmentDetailsDialog({super.key, required this.row});

  static Future<void> show(BuildContext context, {required AdjustmentRowData row}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) => AdjustmentDetailsDialog(row: row),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Adjustment Details',
      subtitle: row.adjustmentId,
      width: 860.w,
      content: AdjustmentDetailsContent(row: row),
    );
  }
}

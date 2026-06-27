import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustment_details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdjustmentDetailsMobileSheet extends StatelessWidget {
  final AdjustmentRowData row;

  const AdjustmentDetailsMobileSheet({super.key, required this.row});

  static Future<void> show(BuildContext context, {required AdjustmentRowData row}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Adjustment Details',
      child: AdjustmentDetailsMobileSheet(row: row),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdjustmentDetailsContent(row: row),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

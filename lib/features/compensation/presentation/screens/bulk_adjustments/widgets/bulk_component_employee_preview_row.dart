import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BulkComponentEmployeePreviewRow extends StatelessWidget {
  const BulkComponentEmployeePreviewRow({
    super.key,
    required this.edit,
    required this.isDark,
    required this.localizations,
  });

  final BulkEmployeeComponentEdit edit;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final nameStyle = context.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );
    final amountStyle = context.textTheme.bodySmall?.copyWith(
      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
    );

    if (context.isMobileLayout) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(edit.employeeName, style: nameStyle),
            Gap(4.h),
            Text(localizations.compensationAdjustmentCurrentAmount(edit.formattedCurrentAmount), style: amountStyle),
            Gap(2.h),
            Text(
              '${localizations.compensationAdjustmentNewAmountLabel}: ${edit.formattedNewAmount}',
              style: amountStyle,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(edit.employeeName, style: nameStyle)),
          Expanded(
            flex: 2,
            child: Text(
              localizations.compensationAdjustmentCurrentAmount(edit.formattedCurrentAmount),
              style: amountStyle,
            ),
          ),
          Expanded(flex: 2, child: Text(edit.formattedNewAmount, style: amountStyle)),
        ],
      ),
    );
  }
}

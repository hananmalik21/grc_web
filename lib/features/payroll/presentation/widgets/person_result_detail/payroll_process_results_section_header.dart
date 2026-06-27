import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PayrollProcessResultsSectionHeader extends ConsumerWidget {
  const PayrollProcessResultsSectionHeader({required this.personNumber, super.key});

  final String personNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final totalItems = ref.watch(personResultDetailTotalItemsProvider(personNumber));
    final period = ref.watch(personResultDetailSummaryPeriodProvider(personNumber));
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(24.w, 18.h, 24.w, 19.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.payrollPersonResultsProcessResultsTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(2.h),
          Text(
            loc.payrollPersonResultsTasksSummary(totalItems, period),
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

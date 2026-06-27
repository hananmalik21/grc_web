import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_tab_provider.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_ui_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultsHeader extends ConsumerWidget {
  const PersonResultsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final enterpriseName = ref.watch(personResultsEnterpriseNameProvider);
    final subtitle = enterpriseName.isNotEmpty ? loc.payrollPersonResultsSubtitle(enterpriseName) : loc.payroll;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20.w : 32.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.payrollPersonResults,
            style: context.textTheme.displaySmall?.copyWith(
              fontSize: isMobile ? 22.sp : 28.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(4.h),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textTertiary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(isMobile ? 12.h : 16.h),
          DigifyTextField.search(
            hintText: loc.payrollPersonResultsSearchHint,
            onChanged: ref.read(personResultsUiProvider.notifier).setSearchQuery,
          ),
          Gap(16.h),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              PersonResultsFilterChip(label: loc.payrollPersonResultsBusinessTitle),
              PersonResultsFilterChip(label: loc.payrollPersonResultsAssignmentStatus),
              PersonResultsFilterChip(label: loc.payrollPersonResultsEffectiveAsOfDate),
              PersonResultsFilterChip(label: loc.payrollPersonResultsIncludeTerminated),
              PersonResultsFilterChip(label: loc.payrollPersonResultsTerminationDate),
              PersonResultsFilterChip(label: loc.payrollPersonResultsWorkerType),
              PersonResultsFilterChip(label: loc.filters),
            ],
          ),
        ],
      ),
    );
  }
}

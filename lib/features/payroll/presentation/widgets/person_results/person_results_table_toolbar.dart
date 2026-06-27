import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_list_provider.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultsTableToolbar extends ConsumerWidget {
  const PersonResultsTableToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final totalItems = ref.watch(personResultsTotalItemsProvider);
    final uiState = ref.watch(personResultsUiProvider);
    final uiNotifier = ref.read(personResultsUiProvider.notifier);
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.employees,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(2.h),
        Text(
          loc.payrollPersonResultsRecordsFound(totalItems),
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );

    final actionsSection = Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: isMobile ? double.infinity : 220.w,
          child: DigifyTextField.search(
            hintText: loc.payrollPersonResultsTableFilterHint,
            onChanged: uiNotifier.setTableFilterQuery,
          ),
        ),
        PopupMenuButton<PersonResultsSortField>(
          initialValue: uiState.sortField,
          onSelected: uiNotifier.setSortField,
          itemBuilder: (context) => PersonResultsSortField.values
              .map((field) => PopupMenuItem(value: field, child: Text(_sortLabel(loc, field))))
              .toList(),
          child: Container(
            height: 36.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.payrollPersonResultsSortBy,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.grayBorderDark,
                  ),
                ),
                Gap(6.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(24.w, 18.h, 24.w, 19.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleSection, Gap(12.h), actionsSection])
          : Row(
              children: [
                Expanded(child: titleSection),
                actionsSection,
              ],
            ),
    );
  }

  String _sortLabel(AppLocalizations loc, PersonResultsSortField field) {
    return switch (field) {
      PersonResultsSortField.name => loc.payrollPersonResultsName,
      PersonResultsSortField.businessTitle => loc.payrollPersonResultsBusinessTitle,
      PersonResultsSortField.personNumber => loc.payrollPersonResultsPersonNumber,
      PersonResultsSortField.assignmentNumber => loc.payrollPersonResultsAssignmentNumber,
      PersonResultsSortField.assignmentStatus => loc.payrollPersonResultsAssignmentStatus,
      PersonResultsSortField.workerType => loc.payrollPersonResultsWorkerType,
      PersonResultsSortField.workEmail => loc.payrollPersonResultsWorkEmail,
      PersonResultsSortField.workPhone => loc.payrollPersonResultsWorkPhone,
    };
  }
}

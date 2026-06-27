import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_task_detail_messages_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailMessagesFilterSection extends ConsumerWidget {
  const PersonResultTaskDetailMessagesFilterSection({
    super.key,
    required this.errorCount,
    required this.warningCount,
    required this.informationCount,
  });

  final int errorCount;
  final int warningCount;
  final int informationCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final messagesState = ref.watch(personResultTaskDetailMessagesProvider);
    final messagesController = ref.read(personResultTaskDetailMessagesProvider.notifier);

    return Container(
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DigifyTextField.search(
            hintText: loc.payrollPersonResultsTaskDetailMessagesSearchHint,
            onChanged: messagesController.setSearchQuery,
          ),
          Gap(12.h),
          if (isMobile)
            _MobileActionsRow(
              selectedFilter: messagesState.severityFilter,
              errorCount: errorCount,
              warningCount: warningCount,
              informationCount: informationCount,
              onExpandAll: messagesController.expandAll,
              onCollapseAll: messagesController.collapseAll,
              onFilterSelected: messagesController.setSeverityFilter,
            )
          else
            _DesktopActionsRow(
              selectedFilter: messagesState.severityFilter,
              errorCount: errorCount,
              warningCount: warningCount,
              informationCount: informationCount,
              onExpandAll: messagesController.expandAll,
              onCollapseAll: messagesController.collapseAll,
              onFilterSelected: messagesController.setSeverityFilter,
            ),
        ],
      ),
    );
  }
}

class _DesktopActionsRow extends StatelessWidget {
  const _DesktopActionsRow({
    required this.selectedFilter,
    required this.errorCount,
    required this.warningCount,
    required this.informationCount,
    required this.onExpandAll,
    required this.onCollapseAll,
    required this.onFilterSelected,
  });

  final PersonResultTaskDetailMessageSeverityFilter selectedFilter;
  final int errorCount;
  final int warningCount;
  final int informationCount;
  final VoidCallback onExpandAll;
  final VoidCallback onCollapseAll;
  final ValueChanged<PersonResultTaskDetailMessageSeverityFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ExpandCollapseActions(onExpandAll: onExpandAll, onCollapseAll: onCollapseAll),
        const Spacer(),
        _SeverityFilters(
          selectedFilter: selectedFilter,
          errorCount: errorCount,
          warningCount: warningCount,
          informationCount: informationCount,
          onFilterSelected: onFilterSelected,
        ),
      ],
    );
  }
}

class _MobileActionsRow extends StatelessWidget {
  const _MobileActionsRow({
    required this.selectedFilter,
    required this.errorCount,
    required this.warningCount,
    required this.informationCount,
    required this.onExpandAll,
    required this.onCollapseAll,
    required this.onFilterSelected,
  });

  final PersonResultTaskDetailMessageSeverityFilter selectedFilter;
  final int errorCount;
  final int warningCount;
  final int informationCount;
  final VoidCallback onExpandAll;
  final VoidCallback onCollapseAll;
  final ValueChanged<PersonResultTaskDetailMessageSeverityFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ExpandCollapseActions(onExpandAll: onExpandAll, onCollapseAll: onCollapseAll),
        Gap(12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: _SeverityFilters(
            selectedFilter: selectedFilter,
            errorCount: errorCount,
            warningCount: warningCount,
            informationCount: informationCount,
            onFilterSelected: onFilterSelected,
          ),
        ),
      ],
    );
  }
}

class _ExpandCollapseActions extends StatelessWidget {
  const _ExpandCollapseActions({required this.onExpandAll, required this.onCollapseAll});

  final VoidCallback onExpandAll;
  final VoidCallback onCollapseAll;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _MessagesOutlineButton(label: loc.expandAll, onPressed: onExpandAll),
        _MessagesOutlineButton(label: loc.collapseAll, onPressed: onCollapseAll),
      ],
    );
  }
}

class _SeverityFilters extends StatelessWidget {
  const _SeverityFilters({
    required this.selectedFilter,
    required this.errorCount,
    required this.warningCount,
    required this.informationCount,
    required this.onFilterSelected,
  });

  final PersonResultTaskDetailMessageSeverityFilter selectedFilter;
  final int errorCount;
  final int warningCount;
  final int informationCount;
  final ValueChanged<PersonResultTaskDetailMessageSeverityFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MessagesFilterChip(
          label: loc.all,
          isSelected: selectedFilter == PersonResultTaskDetailMessageSeverityFilter.all,
          onTap: () => onFilterSelected(PersonResultTaskDetailMessageSeverityFilter.all),
        ),
        Gap(6.w),
        _MessagesFilterChip(
          label: loc.payrollPersonResultsTaskDetailErrors,
          count: errorCount,
          isSelected: selectedFilter == PersonResultTaskDetailMessageSeverityFilter.error,
          onTap: () => onFilterSelected(PersonResultTaskDetailMessageSeverityFilter.error),
        ),
        Gap(6.w),
        _MessagesFilterChip(
          label: loc.payrollPersonResultsTaskDetailWarnings,
          count: warningCount,
          isSelected: selectedFilter == PersonResultTaskDetailMessageSeverityFilter.warning,
          onTap: () => onFilterSelected(PersonResultTaskDetailMessageSeverityFilter.warning),
        ),
        Gap(6.w),
        _MessagesFilterChip(
          label: loc.payrollPersonResultsTaskDetailMessagesInformation,
          count: informationCount,
          isSelected: selectedFilter == PersonResultTaskDetailMessageSeverityFilter.information,
          onTap: () => onFilterSelected(PersonResultTaskDetailMessageSeverityFilter.information),
        ),
        Gap(6.w),
        AppMobileButton.outline(svgPath: Assets.icons.downloadTemplateIcon.path, onPressed: () {}),
      ],
    );
  }
}

class _MessagesOutlineButton extends StatelessWidget {
  const _MessagesOutlineButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Material(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(fontSize: 13.sp, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessagesFilterChip extends StatelessWidget {
  const _MessagesFilterChip({required this.label, required this.isSelected, required this.onTap, this.count});

  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    final textColor = isSelected
        ? AppColors.buttonTextLight
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          height: 40.w,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: isSelected ? null : Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: textColor,
                ),
              ),
              if (count != null) ...[Gap(6.w), _MessagesCountBadge(count: count!)],
            ],
          ),
        ),
      ),
    );
  }
}

class _MessagesCountBadge extends StatelessWidget {
  const _MessagesCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(color: isDark ? AppColors.grayBgDark : AppColors.grayBg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: context.textTheme.headlineMedium?.copyWith(
          fontSize: 11.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}

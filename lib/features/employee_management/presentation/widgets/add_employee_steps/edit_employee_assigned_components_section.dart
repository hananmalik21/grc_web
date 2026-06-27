import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/employee_management/application/edit_employee_compensation/providers/edit_employee_assigned_components_providers.dart';
import 'package:grc/features/employee_management/domain/models/edit_employee_assigned_component.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditEmployeeAssignedComponentsSection extends ConsumerWidget {
  const EditEmployeeAssignedComponentsSection({super.key, required this.employeeGuid});

  final String employeeGuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final componentsAsync = ref.watch(editEmployeeAssignedComponentsProvider(employeeGuid));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.compensation.components.path,
                width: 20.w,
                height: 20.w,
                color: AppColors.primary,
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  localizations.editEmployeeAssignedComponentsTitle,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 18.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Gap(24.h),
          EmployeeAssignedComponentsContent(
            componentsAsync: componentsAsync,
            onRetry: () => ref.invalidate(editEmployeeAssignedComponentsProvider(employeeGuid)),
            isDark: isDark,
            localizations: localizations,
          ),
        ],
      ),
    );
  }
}

class EmployeeAssignedComponentsContent extends StatelessWidget {
  const EmployeeAssignedComponentsContent({
    super.key,
    required this.componentsAsync,
    required this.onRetry,
    required this.isDark,
    required this.localizations,
  });

  final AsyncValue<List<EditEmployeeAssignedComponent>> componentsAsync;
  final VoidCallback onRetry;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return componentsAsync.when(
      loading: () => _EditEmployeeAssignedComponentsTableSkeleton(isDark: isDark, localizations: localizations),
      error: (error, _) => _EditEmployeeAssignedComponentsError(message: error.toString(), onRetry: onRetry),
      data: (components) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16.w,
              runSpacing: 8.h,
              children: [
                Text(localizations.editEmployeeAssignedComponentsSubtitle, style: context.textTheme.titleSmall),
                Text(
                  localizations.editEmployeeAssignedComponentsActiveCount(components.length),
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textTertiary),
                ),
              ],
            ),
            Gap(12.h),
            if (components.isEmpty)
              TableEmptyState(
                title: localizations.noComponentsFound,
                message: localizations.editEmployeeNoAssignedComponentsMessage,
                iconPath: Assets.icons.compensation.components.path,
                height: 250.h,
              )
            else
              _EditEmployeeAssignedComponentsTable(
                components: components,
                isDark: isDark,
                localizations: localizations,
              ),
          ],
        );
      },
    );
  }
}

class _EditEmployeeAssignedComponentsTable extends StatelessWidget {
  const _EditEmployeeAssignedComponentsTable({
    required this.components,
    required this.isDark,
    required this.localizations,
  });

  final List<EditEmployeeAssignedComponent> components;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    if (context.isMobileLayout) {
      return _EditEmployeeAssignedComponentsListMobile(
        components: components,
        isDark: isDark,
        localizations: localizations,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _TableHeader(isDark: isDark, localizations: localizations),
          Column(
            children: components.asMap().entries.map((entry) {
              final component = entry.value;
              return _TableRow(component: component, isDark: isDark, isLast: entry.key == components.length - 1);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EditEmployeeAssignedComponentsListMobile extends StatelessWidget {
  const _EditEmployeeAssignedComponentsListMobile({
    required this.components,
    required this.isDark,
    required this.localizations,
  });

  final List<EditEmployeeAssignedComponent> components;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: components.map((component) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(component.componentName, style: context.textTheme.titleSmall)),
                  _CategoryBadge(category: component.categoryLabel, isDark: isDark),
                ],
              ),
              Gap(12.h),
              _MobileDetailRow(label: localizations.compensationFrequency, value: component.frequencyLabel),
              Gap(8.h),
              _MobileDetailRow(label: localizations.compensationCurrentAmount, value: component.formattedAmount),
              Gap(8.h),
              _MobileDetailRow(
                label: localizations.compensationAnnualValue,
                value: component.formattedAnnualValue,
                valueColor: AppColors.primary,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MobileDetailRow extends StatelessWidget {
  const _MobileDetailRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textTertiary),
        ),
        Text(
          value,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.isDark, required this.localizations});

  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grayBgDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
      ),
      child: Row(
        children: [
          _HeaderCell(text: localizations.compensationComponentName, flex: 3),
          _HeaderCell(text: localizations.componentType, flex: 2),
          _HeaderCell(text: localizations.compensationFrequency, flex: 2),
          _HeaderCell(text: localizations.compensationCurrentAmount, flex: 2),
          _HeaderCell(text: localizations.compensationAnnualValue, flex: 2),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.text, required this.flex});

  final String text;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textTertiary),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.component, required this.isDark, required this.isLast});

  final EditEmployeeAssignedComponent component;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              component.componentName,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [_CategoryBadge(category: component.categoryLabel, isDark: isDark)],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              component.frequencyLabel,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              component.formattedAmount,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              component.formattedAnnualValue,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category, required this.isDark});

  final String category;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final normalized = category.toLowerCase();

    late Color backgroundColor;
    late Color textColor;

    if (normalized.contains('earning') || normalized == 'base') {
      backgroundColor = isDark ? AppColors.infoBgDark : AppColors.infoBg;
      textColor = isDark ? AppColors.infoTextDark : AppColors.infoText;
    } else if (normalized.contains('allowance')) {
      backgroundColor = isDark ? AppColors.warningBgDark : AppColors.warningBg;
      textColor = isDark ? AppColors.warningTextDark : AppColors.warningText;
    } else {
      backgroundColor = isDark ? AppColors.grayBgDark : AppColors.tableHeaderBackground;
      textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    }

    return DigifyCapsule(label: category, backgroundColor: backgroundColor, textColor: textColor);
  }
}

class _EditEmployeeAssignedComponentsTableSkeleton extends StatelessWidget {
  const _EditEmployeeAssignedComponentsTableSkeleton({required this.isDark, required this.localizations});

  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final skeletonData = EditEmployeeAssignedComponent.skeletonData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.loading, style: context.textTheme.labelSmall?.copyWith(color: AppColors.textTertiary)),
        Gap(12.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          child: Column(
            children: [
              _TableHeader(isDark: isDark, localizations: localizations),
              Skeletonizer(
                enabled: true,
                child: Column(
                  children: skeletonData.asMap().entries.map((entry) {
                    final component = entry.value;
                    return _TableRow(
                      component: component,
                      isDark: isDark,
                      isLast: entry.key == skeletonData.length - 1,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditEmployeeAssignedComponentsError extends StatelessWidget {
  const _EditEmployeeAssignedComponentsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
        Gap(12.h),
        TextButton(onPressed: onRetry, child: Text(localizations.retry)),
      ],
    );
  }
}

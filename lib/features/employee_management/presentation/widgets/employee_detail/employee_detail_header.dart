import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/employee_management/presentation/models/employee_detail_display_data.dart';
import 'package:grc/features/employee_management/presentation/screens/mixins/manage_employees_permission_mixin.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_chip.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_leave_stats_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'employee_detail_summary_cards.dart';

class EmployeeDetailHeader extends ConsumerWidget with ManageEmployeesPermissionMixin {
  const EmployeeDetailHeader({
    super.key,
    required this.displayData,
    required this.isDark,
    this.onEditPressed,
    this.onDownloadDocuments,
    this.isDownloadingDocuments = false,
  });

  final EmployeeDetailDisplayData displayData;
  final bool isDark;
  final VoidCallback? onEditPressed;
  final Future<void> Function(BuildContext context)? onDownloadDocuments;
  final bool isDownloadingDocuments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context, textPrimary, context.responsiveData.isTablet && context.isPortrait),
          Gap(24.h),
          EmployeeDetailSummaryCards(displayData: displayData, isDark: isDark),
          Gap(24.h),
          EmployeeDetailLeaveStatsCards(
            employeeGuid: displayData.employee.id,
            isDark: isDark,
            localizations: localizations,
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, Color textPrimary, bool isCompact) {
    final nameAndChips = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayData.displayName,
          style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: textPrimary),
        ),
        Gap(8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            EmployeeDetailChip(
              path: Assets.icons.deiDashboardIcon.path,
              label: displayData.positionLabel,
              isDark: isDark,
            ),
            EmployeeDetailChip(
              path: Assets.icons.departmentsIcon.path,
              label: displayData.departmentLabel,
              isDark: isDark,
            ),
            EmployeeDetailChip(
              path: Assets.icons.employeeManagement.hash.path,
              label: displayData.employeeNumber,
              isDark: isDark,
            ),
          ],
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(
          label: 'Download documents',
          svgPath: Assets.icons.downloadIcon.path,
          isLoading: isDownloadingDocuments,
          onPressed: onDownloadDocuments != null ? () => onDownloadDocuments!(context) : null,
        ),
        if (canUpdateEmployee) ...[
          Gap(8.w),
          AppButton.primary(label: 'Edit Profile', svgPath: Assets.icons.editIcon.path, onPressed: onEditPressed),
        ],
      ],
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
              Gap(16.w),
              Expanded(child: nameAndChips),
            ],
          ),
          Gap(16.h),
          Align(alignment: AlignmentDirectional.centerEnd, child: actionButtons),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
        Gap(24.w),
        Expanded(child: nameAndChips),
        actionButtons,
      ],
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/employee_management/presentation/models/employee_detail_display_data.dart';
import 'package:grc/features/employee_management/presentation/widgets/edit_employee_mobile_sheet.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_chip.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EmployeeDetailMobileHeader extends ConsumerWidget {
  const EmployeeDetailMobileHeader({
    super.key,
    required this.displayData,
    required this.isDark,
    this.onDownloadDocuments,
    this.isDownloadingDocuments = false,
  });

  final EmployeeDetailDisplayData displayData;
  final bool isDark;
  final Future<void> Function(BuildContext context)? onDownloadDocuments;
  final bool isDownloadingDocuments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
              Gap(12.w),
              Expanded(
                child: Text(
                  displayData.displayName,
                  style: context.textTheme.titleMedium?.copyWith(fontSize: 18.sp, color: textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(8.w),
              AppMobileButton.outline(
                svgPath: Assets.icons.downloadIcon.path,
                isLoading: isDownloadingDocuments,
                onPressed: onDownloadDocuments != null ? () => onDownloadDocuments!(context) : null,
              ),
              Gap(8.w),
              AppMobileButton.primary(
                svgPath: Assets.icons.editIcon.path,
                onPressed: () => EditEmployeeMobileSheet.show(context, displayData.employee.id),
              ),
            ],
          ),
          Gap(12.h),
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
      ),
    );
  }
}

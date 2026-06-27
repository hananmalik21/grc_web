import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_chip.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PersonResultDetailHeader extends StatelessWidget {
  const PersonResultDetailHeader({super.key, required this.employee, required this.isDark});

  final PersonResultEmployee employee;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final status = employee.isActive ? loc.active : loc.inactive;
    final isCompact = context.screenLayout.isMobile || (context.responsiveData.isTablet && context.isPortrait);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: isCompact
          ? _buildCompactLayout(context, textPrimary, status)
          : _buildDesktopLayout(context, textPrimary, status),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Color textPrimary, String status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(context),
        Gap(24.w),
        Expanded(child: _buildNameAndMeta(context, textPrimary, status)),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, Color textPrimary, String status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(context),
        Gap(16.w),
        Expanded(child: _buildNameAndMeta(context, textPrimary, status)),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path);
  }

  Widget _buildNameAndMeta(BuildContext context, Color textPrimary, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          employee.name,
          style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: textPrimary),
        ),
        Gap(8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            EmployeeDetailChip(path: Assets.icons.deiDashboardIcon.path, label: employee.businessTitle, isDark: isDark),
            EmployeeDetailChip(
              path: Assets.icons.employeeManagement.hash.path,
              label: employee.personNumber,
              isDark: isDark,
            ),
            DigifyStatusCapsule(status: status),
          ],
        ),
      ],
    );
  }
}

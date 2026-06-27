import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailTabBar extends StatelessWidget implements PreferredSizeWidget {
  const EmployeeDetailTabBar({super.key, required this.controller, required this.isDark});

  final TabController controller;
  final bool isDark;

  @override
  Size get preferredSize => Size.fromHeight(48.h);

  @override
  Widget build(BuildContext context) {
    final unselectedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final isDesktop = context.responsiveData.isDesktop;
    return TabBar(
      controller: controller,
      isScrollable: !isDesktop,
      tabAlignment: isDesktop ? TabAlignment.fill : TabAlignment.start,
      tabs: [
        _buildTab(
          context: context,
          iconPath: Assets.icons.leaveManagement.myLeave.path,
          label: 'Personal Information',
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.deiDashboardIcon.path,
          label: 'Employment Details',
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.attendanceIcon.path,
          label: 'Compensation & Benefits',
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.leaveManagement.forfeitReports.path,
          label: 'Documents & Banking',
          unselectedColor: unselectedColor,
        ),
      ],
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.w, color: AppColors.primary),
      ),
      dividerColor: AppColors.textPlaceholder,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.primary,
      unselectedLabelColor: unselectedColor,
      labelStyle: context.textTheme.titleMedium?.copyWith(color: AppColors.primary),
      unselectedLabelStyle: context.textTheme.bodyLarge?.copyWith(fontSize: 16.sp, color: unselectedColor),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String iconPath,
    required String label,
    required Color unselectedColor,
  }) {
    return Tab(
      child: Builder(
        builder: (context) {
          final color = DefaultTextStyle.of(context).style.color ?? unselectedColor;
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DigifyAsset(assetPath: iconPath, width: 20.w, height: 20.w, color: color),
              Gap(8.w),
              Text(label),
            ],
          );
        },
      ),
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionDetailTabBar extends StatelessWidget implements PreferredSizeWidget {
  const RequisitionDetailTabBar({super.key, required this.controller, required this.isDark});

  final TabController controller;
  final bool isDark;

  @override
  Size get preferredSize => Size.fromHeight(48.h);

  @override
  Widget build(BuildContext context) {
    final unselectedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final loc = AppLocalizations.of(context)!;

    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: [
        _buildTab(
          context: context,
          iconPath: Assets.icons.sectionIconSmall.path,
          label: loc.hiringRequisitionDetailTabOverview,
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.checkIconGreen.path,
          label: loc.hiringRequisitionDetailTabApprovalWorkflow,
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.submitted.path,
          label: loc.hiringRequisitionDetailTabJobPosting,
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.employeeListIcon.path,
          label: loc.hiringRequisitionDetailTabApplications,
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.securityManager.addUser.path,
          label: loc.hiringRequisitionDetailTabFindCandidates,
          unselectedColor: unselectedColor,
        ),
        _buildTab(
          context: context,
          iconPath: Assets.icons.clockIcon.path,
          label: loc.hiringRequisitionDetailTabHistory,
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
              DigifyAsset(assetPath: iconPath, width: 18.w, height: 18.w, color: color),
              Gap(8.w),
              Text(label),
            ],
          );
        },
      ),
    );
  }
}

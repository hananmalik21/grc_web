import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/router/app_nav_item.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/theme/app_colors.dart';

class AppTopNavBar extends StatefulWidget {
  const AppTopNavBar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  final AppNavItem selected;
  final ValueChanged<AppNavItem> onSelect;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  @override
  State<AppTopNavBar> createState() => _AppTopNavBarState();
}

class _AppTopNavBarState extends State<AppTopNavBar> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return _MobileTopNavBar(
        scrollController: _scrollController,
        selected: widget.selected,
        onSelect: widget.onSelect,
      );
    }

    if (layout.isTabletSmall) {
      return _TabletSmallTopNavBar(
        scrollController: _scrollController,
        selected: widget.selected,
        onSelect: widget.onSelect,
      );
    }

    return _DesktopTopNavBar(
      selected: widget.selected,
      onSelect: widget.onSelect,
    );
  }
}

class _DesktopTopNavBar extends StatelessWidget {
  const _DesktopTopNavBar({
    required this.selected,
    required this.onSelect,
  });

  final AppNavItem selected;
  final ValueChanged<AppNavItem> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final items = _navItems(l10n);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final item in items) ...[
                    _NavItem(
                      selected: selected == item.id,
                      iconAsset: item.asset,
                      label: item.label,
                      onTap: () => onSelect(item.id),
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                    ),
                    SizedBox(width: 30.w),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileTopNavBar extends StatelessWidget {
  const _MobileTopNavBar({
    required this.scrollController,
    required this.selected,
    required this.onSelect,
  });

  final ScrollController scrollController;
  final AppNavItem selected;
  final ValueChanged<AppNavItem> onSelect;

  @override
  Widget build(BuildContext context) {
    final items = _navItems(context.l10n);

    return Container(
      height: 48.h,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 4.w),
        itemBuilder: (context, index) {
          final item = items[index];
          return _IconNavItem(
            selected: selected == item.id,
            iconAsset: item.asset,
            label: item.label,
            onTap: () => onSelect(item.id),
          );
        },
      ),
    );
  }
}

class _TabletSmallTopNavBar extends StatelessWidget {
  const _TabletSmallTopNavBar({
    required this.scrollController,
    required this.selected,
    required this.onSelect,
  });

  final ScrollController scrollController;
  final AppNavItem selected;
  final ValueChanged<AppNavItem> onSelect;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final items = _navItems(context.l10n);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            for (final item in items) ...[
              _LabeledNavItem(
                selected: selected == item.id,
                iconAsset: item.asset,
                label: item.label,
                textTheme: textTheme,
                onTap: () => onSelect(item.id),
              ),
              SizedBox(width: 8.w),
            ],
          ],
        ),
      ),
    );
  }
}

List<({AppNavItem id, String asset, String label})> _navItems(dynamic l10n) {
  return [
    (id: AppNavItem.dashboard, asset: 'assets/figma/dashboard/svg/dashboard_icon.svg', label: l10n.navDashboard),
    (id: AppNavItem.library, asset: 'assets/figma/dashboard/svg/library_icon.svg', label: l10n.navLibrary),
    (id: AppNavItem.assets, asset: 'assets/figma/dashboard/svg/assets_icon.svg', label: l10n.navAssets),
    (id: AppNavItem.risks, asset: 'assets/figma/dashboard/svg/security_icon.svg', label: l10n.navRisks),
    (id: AppNavItem.assessments, asset: 'assets/figma/dashboard/svg/assessments_icon.svg', label: l10n.navAssessments),
    (id: AppNavItem.controls, asset: 'assets/figma/dashboard/svg/controls_icon.svg', label: l10n.navControls),
    (id: AppNavItem.tprm, asset: 'assets/figma/dashboard/svg/users_icon.svg', label: l10n.navTprm),
    (id: AppNavItem.programs, asset: 'assets/figma/dashboard/svg/programs_icon.svg', label: l10n.navPrograms),
    (id: AppNavItem.reviewProgress, asset: 'assets/figma/dashboard/svg/dashboard_icon.svg', label: l10n.navReviewProgress),
    (id: AppNavItem.roles, asset: 'assets/figma/dashboard/svg/roles_icon.svg', label: l10n.navRoles),
  ];
}

class _IconNavItem extends StatelessWidget {
  const _IconNavItem({
    required this.selected,
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      preferBelow: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 44.w,
          height: 44.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  selected ? AppColors.primary : AppColors.textBody,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: selected ? 20.w : 0,
                height: 2.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledNavItem extends StatelessWidget {
  const _LabeledNavItem({
    required this.selected,
    required this.iconAsset,
    required this.label,
    required this.textTheme,
    required this.onTap,
  });

  final bool selected;
  final String iconAsset;
  final String label;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 18.w,
              height: 18.h,
              colorFilter: ColorFilter.mode(
                selected ? AppColors.primary : AppColors.textBody,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: selected ? AppColors.primary : AppColors.textBody,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.selected,
    required this.iconAsset,
    required this.label,
    required this.onTap,
    required this.textTheme,
    required this.colorScheme,
  });

  final bool selected;
  final String iconAsset;
  final String label;
  final VoidCallback onTap;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(
                selected ? AppColors.primary : AppColors.textBody,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: (selected ? textTheme.bodyLarge : textTheme.bodyMedium)?.copyWith(
                color: selected ? AppColors.primary : AppColors.textBody,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

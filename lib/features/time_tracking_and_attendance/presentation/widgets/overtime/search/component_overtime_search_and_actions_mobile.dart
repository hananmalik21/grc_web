import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import 'component_overtime_search_and_actions.dart';
import 'overtime_search_bar.dart';

class OvertimeSearchAndActionsMobile extends ConsumerStatefulWidget {
  const OvertimeSearchAndActionsMobile({required this.localizations, required this.isDark, super.key});

  final AppLocalizations localizations;
  final bool isDark;

  @override
  ConsumerState<OvertimeSearchAndActionsMobile> createState() => _OvertimeSearchAndActionsMobileState();
}

class _OvertimeSearchAndActionsMobileState extends ConsumerState<OvertimeSearchAndActionsMobile> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OvertimeSearchBar(
                  hintText: widget.localizations.searchPositionsPlaceholder,
                  isDark: widget.isDark,
                  width: double.infinity,
                ),
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: widget.isDark,
                isActive: _showFilters,
                onTap: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
          if (_showFilters) ...[
            Gap(12.h),
            OvertimeFiltersPanel(isDark: widget.isDark, statusLabel: widget.localizations.allStatus, compact: true),
          ],
        ],
      ),
    );
  }
}

class _FilterToggleButton extends StatelessWidget {
  const _FilterToggleButton({required this.isDark, required this.isActive, required this.onTap});

  final bool isDark;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    final bgColor = isActive
        ? AppColors.primary.withValues(alpha: 0.1)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: DigifyAsset(
            assetPath: Assets.icons.employeeManagement.filterMain.path,
            width: 18,
            height: 18,
            color: isActive ? AppColors.primary : null,
          ),
        ),
      ),
    );
  }
}

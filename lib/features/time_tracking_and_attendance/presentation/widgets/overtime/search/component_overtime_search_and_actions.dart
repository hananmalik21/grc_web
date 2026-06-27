import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_org_structure_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_enterprise_selection_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/app_shadows.dart';
import 'overtime_search_bar.dart';
import 'overtime_status_dropdown.dart';

class OvertimeSearchAndActions extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const OvertimeSearchAndActions({super.key, required this.localizations, required this.isDark});

  @override
  ConsumerState<OvertimeSearchAndActions> createState() => _OvertimeSearchAndActionsState();
}

class _OvertimeSearchAndActionsState extends ConsumerState<OvertimeSearchAndActions> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
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
              Gap(16.w),
              OvertimeStatusDropdown(label: widget.localizations.allStatus, isDark: widget.isDark),
            ],
          ),
          Gap(16.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.outline(
              label: 'Filters',
              svgPath: Assets.icons.employeeManagement.filterMain.path,
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ),
          if (_showFilters) ...[
            Gap(16.h),
            OvertimeFiltersPanel(isDark: widget.isDark, statusLabel: widget.localizations.allStatus),
          ],
        ],
      ),
    );
  }
}

class OvertimeFiltersPanel extends ConsumerWidget {
  const OvertimeFiltersPanel({required this.isDark, required this.statusLabel, this.compact = false, super.key});

  final bool isDark;
  final String statusLabel;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgState = ref.watch(overtimeOrgStructureNotifierProvider);
    final org = orgState.orgStructure;

    return Container(
      padding: EdgeInsets.all(compact ? 12.r : 16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.employeeManagement.filterSecondary.path,
                    width: compact ? 16 : 20,
                    height: compact ? 16 : 20,
                  ),
                  Gap(compact ? 6.w : 8.w),
                  Text(
                    compact ? 'Filters' : 'Advanced Filters',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: compact ? 13.sp : 14.sp,
                    ),
                  ),
                ],
              ),
              if (org != null)
                GestureDetector(
                  onTap: () => _resetOrgFilters(ref),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        compact ? 'Clear All' : 'Reset filters',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                      ),
                      if (!compact) ...[
                        Gap(6.w),
                        DigifyAsset(
                          assetPath: Assets.icons.refreshGray.path,
                          width: 16.w,
                          height: 16.h,
                          color: AppColors.brandRed,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
          Gap(compact ? 12.h : 16.h),
          OvertimeStatusDropdown(label: statusLabel, isDark: isDark, width: compact ? double.infinity : 180.w),
          Gap(compact ? 12.h : 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = compact || context.isMobile ? constraints.maxWidth : 180.w;

              return Wrap(
                spacing: 14.w,
                runSpacing: 14.h,
                children: org == null
                    ? _buildOrgFiltersLoadingPlaceholders(fieldWidth)
                    : _buildOrgCascade(
                        ref: ref,
                        param: (levels: org.activeLevels, structureId: org.structureId),
                        fieldWidth: fieldWidth,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrgFiltersLoadingPlaceholders(double fieldWidth) {
    return List.generate(4, (_) {
      return SizedBox(
        width: fieldWidth,
        height: 48.h,
        child: Skeletonizer(
          enabled: true,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrgCascade({
    required WidgetRef ref,
    required ({List<OrgStructureLevel> levels, String structureId}) param,
    required double fieldWidth,
  }) {
    final notifier = ref.read(overtimeManagementProvider.notifier);
    final selectionProvider = overtimeEnterpriseSelectionNotifierProvider(param.structureId);
    final selectionState = ref.watch(selectionProvider);
    final levels = param.levels;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;

      return SizedBox(
        width: fieldWidth,
        child: DigifyStyleOrgLevelField(
          level: level,
          selectionProvider: selectionProvider,
          isEnabled: isEnabled,
          showLabel: false,
          onSelectionChanged: (levelCode, unit) {
            final id = unit?.orgUnitId;
            ref.read(selectionProvider.notifier).selectUnit(levelCode, unit);
            notifier.setOrgFilter(id?.toString(), levelCode);
          },
        ),
      );
    }).toList();
  }

  void _resetOrgFilters(WidgetRef ref) {
    final orgState = ref.read(overtimeOrgStructureNotifierProvider);
    final org = orgState.orgStructure;
    if (org != null) {
      ref.read(overtimeEnterpriseSelectionNotifierProvider(org.structureId).notifier).reset();
    }

    ref.read(overtimeManagementProvider.notifier).resetFilters();
  }
}

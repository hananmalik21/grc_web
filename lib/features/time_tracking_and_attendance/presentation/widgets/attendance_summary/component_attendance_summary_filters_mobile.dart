import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/buttons/app_mobile_button.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import '../../../../workforce_structure/domain/models/org_structure_level.dart';
import '../../providers/attendance_summary/attendance_summary_enterprise_selection_provider.dart';
import '../../providers/attendance_summary/attendance_summary_org_structure_provider.dart';
import '../../providers/attendance_summary/attendance_summary_provider.dart';

class ComponentAttendanceSummaryFiltersMobile extends ConsumerStatefulWidget {
  const ComponentAttendanceSummaryFiltersMobile({super.key, required this.isDark});

  final bool isDark;

  @override
  ConsumerState<ComponentAttendanceSummaryFiltersMobile> createState() =>
      _ComponentAttendanceSummaryFiltersMobileState();
}

class _ComponentAttendanceSummaryFiltersMobileState extends ConsumerState<ComponentAttendanceSummaryFiltersMobile> {
  bool _showFilters = false;
  DateTime? _pendingFromDate;
  DateTime? _pendingToDate;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceSummaryProvider);
    final notifier = ref.read(attendanceSummaryProvider.notifier);
    final appliedFrom = state.fromDate ?? _tryParseIsoDate(state.date);
    final appliedTo = state.toDate;
    final effectiveFrom = _pendingFromDate ?? appliedFrom;
    final effectiveTo = _pendingToDate ?? appliedTo;
    final hasAnyDate = effectiveFrom != null || effectiveTo != null;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DigifyDateField(
                  label: 'From',
                  isRequired: false,
                  initialDate: effectiveFrom,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onDateSelected: (date) => setState(() => _pendingFromDate = date),
                  hintText: 'Start date',
                ),
              ),
              Gap(8.w),
              Expanded(
                child: DigifyDateField(
                  label: 'To',
                  isRequired: false,
                  initialDate: effectiveTo,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onDateSelected: (date) => setState(() => _pendingToDate = date),
                  hintText: 'End date',
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              AppMobileButton.primary(
                icon: Icons.check_rounded,
                onPressed: () {
                  notifier.setFromDate(effectiveFrom);
                  notifier.setToDate(effectiveTo);
                  notifier.applyDateRange();
                },
              ),
              if (hasAnyDate) ...[
                Gap(8.w),
                AppMobileButton.outline(
                  icon: Icons.close_rounded,
                  onPressed: () {
                    setState(() {
                      _pendingFromDate = null;
                      _pendingToDate = null;
                    });
                    notifier.clearDateFilters();
                  },
                ),
              ],
              const Spacer(),
              AppMobileButton.outline(
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                onPressed: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
          if (_showFilters) ...[Gap(10.h), _AdvancedFiltersMobile(isDark: widget.isDark)],
        ],
      ),
    );
  }

  static DateTime? _tryParseIsoDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class _AdvancedFiltersMobile extends ConsumerWidget {
  const _AdvancedFiltersMobile({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgState = ref.watch(attendanceSummaryOrgStructureNotifierProvider);
    final org = orgState.orgStructure;

    return Container(
      padding: EdgeInsets.all(12.r),
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
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(assetPath: Assets.icons.employeeManagement.filterSecondary.path, width: 16, height: 16),
                  Gap(6.w),
                  Text(
                    'Advanced Filters',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              if (org != null)
                GestureDetector(
                  onTap: () => _resetOrgFilters(ref, org.structureId),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reset',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                      ),
                      Gap(4.w),
                      DigifyAsset(
                        assetPath: Assets.icons.refreshGray.path,
                        width: 14.w,
                        height: 14.h,
                        color: AppColors.brandRed,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Gap(12.h),
          if (org == null)
            _buildLoadingPlaceholders()
          else
            _buildOrgCascade(context, ref, (levels: org.activeLevels, structureId: org.structureId)),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholders() {
    return Column(
      children: List.generate(2, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i < 1 ? 10.h : 0),
          child: SizedBox(
            width: double.infinity,
            height: 44.h,
            child: Skeletonizer(
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrgCascade(
    BuildContext context,
    WidgetRef ref,
    ({List<OrgStructureLevel> levels, String structureId}) param,
  ) {
    final notifier = ref.read(attendanceSummaryProvider.notifier);
    final selectionProvider = attendanceSummaryEnterpriseSelectionNotifierProvider(param.structureId);
    final selectionState = ref.watch(selectionProvider);
    final levels = param.levels;

    return Column(
      children: levels.asMap().entries.map((entry) {
        final index = entry.key;
        final level = entry.value;
        final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;

        return Padding(
          padding: EdgeInsets.only(bottom: index < levels.length - 1 ? 10.h : 0),
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
      }).toList(),
    );
  }

  void _resetOrgFilters(WidgetRef ref, String structureId) {
    ref.read(attendanceSummaryEnterpriseSelectionNotifierProvider(structureId).notifier).reset();
    ref.read(attendanceSummaryProvider.notifier).setOrgFilter(null, null);
  }
}

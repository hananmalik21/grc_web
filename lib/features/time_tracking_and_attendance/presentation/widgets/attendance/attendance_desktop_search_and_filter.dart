import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_org_structure_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_enterprise_selection_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceDesktopSearchAndFilter extends ConsumerStatefulWidget {
  const AttendanceDesktopSearchAndFilter({
    super.key,
    required this.employeeNumberController,
    required this.fromDate,
    required this.toDate,
    required this.onSearchChanged,
    required this.onFromDateSelected,
    required this.onToDateSelected,
    required this.onApply,
    required this.onClear,
    required this.isDark,
  });

  final TextEditingController employeeNumberController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DateTime> onFromDateSelected;
  final ValueChanged<DateTime> onToDateSelected;
  final VoidCallback onApply;
  final VoidCallback onClear;
  final bool isDark;

  @override
  ConsumerState<AttendanceDesktopSearchAndFilter> createState() => _AttendanceDesktopSearchAndFilterState();
}

class _AttendanceDesktopSearchAndFilterState extends ConsumerState<AttendanceDesktopSearchAndFilter> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: widget.employeeNumberController,
            hintText: 'Search by employee number...',
            onChanged: widget.onSearchChanged,
          ),
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DigifyDateField(
                  label: 'From Date',
                  isRequired: false,
                  initialDate: widget.fromDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onDateSelected: widget.onFromDateSelected,
                  hintText: 'Select from date',
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyDateField(
                  label: 'To Date',
                  isRequired: false,
                  initialDate: widget.toDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onDateSelected: widget.onToDateSelected,
                  hintText: 'Select to date',
                ),
              ),
              Gap(16.w),
              Wrap(
                spacing: 12.w,
                runSpacing: 8.h,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  AppButton(label: 'Apply', type: AppButtonType.primary, onPressed: widget.onApply),
                  if (widget.fromDate != null || widget.toDate != null)
                    AppButton.outline(label: 'Clear', onPressed: widget.onClear),
                ],
              ),
            ],
          ),
          Gap(16.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.outline(
              label: 'Filters',
              svgPath: Assets.icons.employeeManagement.filterMain.path,
              onPressed: () => setState(() => _showFilters = !_showFilters),
            ),
          ),
          if (_showFilters) ...[Gap(16.h), _buildAdvancedFilters(context)],
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(BuildContext context) {
    final orgState = ref.watch(attendanceOrgStructureNotifierProvider);
    final org = orgState.orgStructure;
    final isDark = widget.isDark;

    return Container(
      padding: EdgeInsets.all(16.r),
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
                  DigifyAsset(assetPath: Assets.icons.employeeManagement.filterSecondary.path, width: 20, height: 20),
                  Gap(8.w),
                  Text(
                    'Advanced Filters',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 14.sp,
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
                        'Reset filters',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                      ),
                      Gap(6.w),
                      DigifyAsset(
                        assetPath: Assets.icons.refreshGray.path,
                        width: 16.w,
                        height: 16.h,
                        color: AppColors.brandRed,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Gap(16.h),
          Wrap(
            spacing: 14.w,
            runSpacing: 14.h,
            children: org == null
                ? _buildOrgLoadingPlaceholders(isDark)
                : _buildOrgCascade(ref, (levels: org.activeLevels, structureId: org.structureId)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrgCascade(WidgetRef ref, ({List<OrgStructureLevel> levels, String structureId}) param) {
    final notifier = ref.read(attendanceNotifierProvider.notifier);
    final selectionProvider = attendanceEnterpriseSelectionNotifierProvider(param.structureId);
    final selectionState = ref.watch(selectionProvider);
    final levels = param.levels;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;

      return SizedBox(
        width: 180.w,
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
}

void _resetOrgFilters(WidgetRef ref) {
  final orgState = ref.read(attendanceOrgStructureNotifierProvider);
  final org = orgState.orgStructure;
  if (org != null) {
    ref.read(attendanceEnterpriseSelectionNotifierProvider(org.structureId).notifier).reset();
  }
  ref.read(attendanceNotifierProvider.notifier).setOrgFilter(null, null);
}

List<Widget> _buildOrgLoadingPlaceholders(bool isDark) {
  return List.generate(4, (_) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: SizedBox(
        width: 180.w,
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 14.h,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
                  ),
                ),
                Gap(8.w),
                Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}

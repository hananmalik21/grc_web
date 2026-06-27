import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
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

class AttendanceMobileSearchAndFilter extends ConsumerStatefulWidget {
  const AttendanceMobileSearchAndFilter({
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
    this.onImport,
    this.onExport,
    this.isExporting = false,
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
  final VoidCallback? onImport;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<AttendanceMobileSearchAndFilter> createState() => _AttendanceMobileSearchAndFilterState();
}

class _AttendanceMobileSearchAndFilterState extends ConsumerState<AttendanceMobileSearchAndFilter> {
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
          Row(
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: widget.employeeNumberController,
                  hintText: 'Search by employee number...',
                  onChanged: widget.onSearchChanged,
                ),
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.bulkUploadIconFigma.path,
                backgroundColor: AppColors.shiftUploadButton,
                foregroundColor: Colors.white,
                onPressed: widget.onImport,
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
                foregroundColor: Colors.white,
                onPressed: widget.isExporting ? null : widget.onExport,
                isLoading: widget.isExporting,
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: widget.isDark,
                isActive: _showFilters,
                onTap: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
          if (_showFilters) ...[Gap(12.h), _buildFilterPanel(context)],
        ],
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context) {
    final isDark = widget.isDark;
    final orgState = ref.watch(attendanceOrgStructureNotifierProvider);
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
                    'Filters',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  widget.onClear();
                  _resetOrgFilters(ref);
                },
                child: Text(
                  'Clear All',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Gap(12.h),
          DigifyDateField(
            label: 'From Date',
            isRequired: false,
            initialDate: widget.fromDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onDateSelected: widget.onFromDateSelected,
            hintText: 'Select from date',
          ),
          Gap(8.h),
          DigifyDateField(
            label: 'To Date',
            isRequired: false,
            initialDate: widget.toDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onDateSelected: widget.onToDateSelected,
            hintText: 'Select to date',
          ),
          Gap(12.h),
          Row(
            children: [AppButton(label: 'Apply', type: AppButtonType.primary, onPressed: widget.onApply)],
          ),
          Gap(16.h),
          Divider(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(assetPath: Assets.icons.employeeManagement.filterSecondary.path, width: 14, height: 14),
                  Gap(6.w),
                  Text(
                    'Organization',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 12.sp,
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
                        'Reset',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
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
          Gap(8.h),
          if (org == null)
            Wrap(spacing: 8.w, runSpacing: 8.h, children: _buildOrgLoadingPlaceholders(isDark))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8.h,
              children: _buildOrgCascade(ref, (levels: org.activeLevels, structureId: org.structureId)),
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

      return DigifyStyleOrgLevelField(
        level: level,
        selectionProvider: selectionProvider,
        isEnabled: isEnabled,
        showLabel: false,
        onSelectionChanged: (levelCode, unit) {
          final id = unit?.orgUnitId;
          ref.read(selectionProvider.notifier).selectUnit(levelCode, unit);
          notifier.setOrgFilter(id?.toString(), levelCode);
        },
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

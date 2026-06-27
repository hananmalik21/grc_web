import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SalaryChangeHistoryFilterBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final SalaryChangeHistoryStatus selectedStatus;
  final ValueChanged<SalaryChangeHistoryStatus?> onStatusChanged;
  final SalaryChangeHistoryType selectedType;
  final ValueChanged<SalaryChangeHistoryType?> onTypeChanged;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final ValueChanged<DateTime?> onEffectiveFromChanged;
  final ValueChanged<DateTime?> onEffectiveToChanged;
  final VoidCallback onApplyFilter;
  final VoidCallback onRemoveFilter;
  final VoidCallback onExportPressed;
  final bool isExporting;

  const SalaryChangeHistoryFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.selectedType,
    required this.onTypeChanged,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.onEffectiveFromChanged,
    required this.onEffectiveToChanged,
    required this.onApplyFilter,
    required this.onRemoveFilter,
    required this.onExportPressed,
    this.isExporting = false,
  });

  bool get _hasDateFilter => effectiveFrom != null || effectiveTo != null;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

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
          DigifyTextField.search(
            hintText: 'Search by employee name, ID, or change ID...',
            onChanged: onSearchChanged,
            onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                width: 180.w,
                child: DigifyDateField(
                  label: 'Effective From',
                  hintText: 'Select start date',
                  isRequired: false,
                  initialDate: effectiveFrom,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateSelected: (date) => onEffectiveFromChanged(date),
                ),
              ),
              SizedBox(
                width: 180.w,
                child: DigifyDateField(
                  label: 'Effective To',
                  hintText: 'Select end date',
                  isRequired: false,
                  initialDate: effectiveTo,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateSelected: (date) => onEffectiveToChanged(date),
                ),
              ),
              AppButton(label: 'Apply', type: AppButtonType.primary, onPressed: onApplyFilter),
              if (_hasDateFilter) AppButton.outline(label: 'Remove', onPressed: onRemoveFilter),
            ],
          ),
          Gap(12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                width: 180.w,
                child: DigifySelectField<SalaryChangeHistoryStatus>(
                  hint: 'Status',
                  value: selectedStatus,
                  items: SalaryChangeHistoryStatus.values,
                  itemLabelBuilder: (item) => item.label,
                  onChanged: onStatusChanged,
                ),
              ),
              SizedBox(
                width: 180.w,
                child: DigifySelectField<SalaryChangeHistoryType>(
                  hint: 'Type',
                  value: selectedType,
                  items: SalaryChangeHistoryType.values,
                  itemLabelBuilder: (item) => item.label,
                  onChanged: onTypeChanged,
                ),
              ),
              AppButton(
                label: 'Export',
                onPressed: isExporting ? null : onExportPressed,
                isLoading: isExporting,
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

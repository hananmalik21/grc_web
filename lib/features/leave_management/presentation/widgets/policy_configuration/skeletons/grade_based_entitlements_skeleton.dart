import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/date_selection_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GradeBasedEntitlementsSkeleton extends StatelessWidget {
  final bool isDark;

  const GradeBasedEntitlementsSkeleton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Grade-Based Entitlements & Accrual',
      iconPath: Assets.icons.leaveManagementIcon.path,
      child: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.h,
          children: [_buildGradeRowCard(), _buildEffectiveDateCard(), _buildProRataCard()],
        ),
      ),
    );
  }

  Widget _buildGradeRowCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          Row(
            children: [Icon(Icons.workspace_premium, size: 20.sp, color: AppColors.primary)],
          ),
          Row(
            spacing: 12.w,
            children: [
              const Expanded(
                child: DigifyTextField(labelText: 'Grade From', initialValue: '1', onChanged: null),
              ),
              const Expanded(
                child: DigifyTextField(labelText: 'Grade To', initialValue: '10', onChanged: null),
              ),
              const Expanded(
                child: DigifyTextField(labelText: 'Days', initialValue: '30', onChanged: null),
              ),
              const Expanded(
                child: DigifyTextField(labelText: 'Accrual Rate', initialValue: '2.5', onChanged: null),
              ),
            ],
          ),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifySelectFieldWithLabel(
                  label: 'Accrual Method',
                  items: const [],
                  itemLabelBuilder: (v) => '',
                  onChanged: null,
                ),
              ),
              Expanded(
                child: DigifySelectFieldWithLabel(
                  label: 'Status',
                  items: const [],
                  itemLabelBuilder: (v) => '',
                  onChanged: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectiveDateCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.lightWhiteBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        spacing: 16.w,
        children: [
          Expanded(
            child: DateSelectionField(label: 'Effective Start Date', date: DateTime.now(), onDateSelected: (_) {}),
          ),
          Expanded(
            child: DateSelectionField(label: 'Effective End Date', date: DateTime.now(), onDateSelected: (_) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildProRataCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.roleBadgeBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.permissionBadgeBorder),
      ),
      child: Row(
        children: [
          const DigifyCheckbox(value: true, onChanged: null),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  'Enable Pro-Rata Calculation',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
                Text('Calculate leave entitlement proportionally for partial years', style: TextStyle(fontSize: 11.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

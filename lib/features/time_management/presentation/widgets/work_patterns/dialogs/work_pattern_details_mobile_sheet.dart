import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/mixins/datetime_conversion_mixin.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/work_pattern_days_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/edit_work_pattern_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternDetailsMobileSheet extends ConsumerWidget with DateTimeConversionMixin, WorkPatternsPermissionMixin {
  final WorkPattern workPattern;
  final int enterpriseId;

  const WorkPatternDetailsMobileSheet({super.key, required this.workPattern, required this.enterpriseId});

  static Future<void> show(BuildContext context, WorkPattern workPattern, int enterpriseId) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Work Pattern Details',
      child: WorkPatternDetailsMobileSheet(workPattern: workPattern, enterpriseId: enterpriseId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Gap(16.h),
                const DigifyDivider(),
                Gap(16.h),
                _buildDetailsGrid(context),
                Gap(16.h),
                WorkPatternDaysSection(label: 'Working Days', dayType: 'WORK', workPattern: workPattern),
                Gap(12.h),
                WorkPatternDaysSection(label: 'Rest Days', dayType: 'REST', workPattern: workPattern),
                Gap(12.h),
                WorkPatternDaysSection(label: 'Off Days', dayType: 'OFF', workPattern: workPattern),
                Gap(8.h),
              ],
            ),
          ),
        ),
        if (canUpdateWorkPattern) _WorkPatternDetailsFooter(workPattern: workPattern, enterpriseId: enterpriseId),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(12.r)),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.leaveManagementMainIcon.path,
            width: 26.w,
            height: 26.w,
            color: AppColors.primary,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workPattern.patternNameEn,
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (workPattern.patternNameAr.isNotEmpty)
                Text(
                  workPattern.patternNameAr,
                  textDirection: TextDirection.rtl,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              Gap(4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(4.r)),
                child: Text(
                  workPattern.patternCode.toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(color: AppColors.infoText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DetailItem(label: 'Pattern Type', value: workPattern.patternType),
            ),
            Expanded(
              child: _DetailItem(
                label: 'Status',
                widget: DigifyStatusCapsule(
                  status: workPattern.status == PositionStatus.active ? 'Active' : 'Inactive',
                ),
              ),
            ),
          ],
        ),
        Gap(12.h),
        Row(
          children: [
            Expanded(
              child: _DetailItem(label: 'Total Hours/Week', value: '${workPattern.totalHoursPerWeek} hrs'),
            ),
            Expanded(
              child: _DetailItem(label: 'Working Days', value: '${workPattern.workingDays} days'),
            ),
          ],
        ),
        Gap(12.h),
        Row(
          children: [
            Expanded(
              child: _DetailItem(label: 'Created Date', value: formatDateFromDateTime(workPattern.creationDate)),
            ),
            Expanded(
              child: _DetailItem(label: 'Updated By', value: workPattern.lastUpdatedBy),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkPatternDetailsFooter extends StatelessWidget with WorkPatternsPermissionMixin {
  final WorkPattern workPattern;
  final int enterpriseId;

  const _WorkPatternDetailsFooter({required this.workPattern, required this.enterpriseId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop(), height: 46),
              Gap(10.w),
              Expanded(
                child: AppButton(
                  label: 'Edit Pattern',
                  svgPath: Assets.icons.editIcon.path,
                  onPressed: () {
                    Navigator.of(context).pop();
                    EditWorkPatternMobileSheet.show(context, enterpriseId, workPattern);
                  },
                  backgroundColor: AppColors.greenButton,
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? widget;

  const _DetailItem({required this.label, this.value, this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        Gap(4.h),
        widget ?? Text(value ?? '-', style: context.textTheme.labelLarge?.copyWith(color: AppColors.dialogTitle)),
      ],
    );
  }
}

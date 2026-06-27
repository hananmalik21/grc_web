import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/mixins/datetime_conversion_mixin.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/duration_formatter.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/update_shift_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftDetailsMobileSheet extends ConsumerWidget with DateTimeConversionMixin, ShiftsPermissionMixin {
  final ShiftOverview shift;

  const ShiftDetailsMobileSheet({super.key, required this.shift});

  static Future<void> show(BuildContext context, ShiftOverview shift) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Shift Details',
      child: ShiftDetailsMobileSheet(shift: shift),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final bgColor = Color(shift.colorValue);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.125), shape: BoxShape.circle),
                      child: DigifyAsset(assetPath: shift.iconPath, width: 28.w, height: 28.w, color: bgColor),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(shift.name, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            textDirection: TextDirection.rtl,
                            shift.nameAr,
                            style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                          ),
                          Gap(6.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: AppColors.jobRoleBg,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              shift.code.toUpperCase(),
                              style: context.textTheme.labelSmall?.copyWith(color: AppColors.infoText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                const DigifyDivider(),
                Gap(16.h),
                _buildDetailGrid(context, isDark),
              ],
            ),
          ),
        ),
        if (canUpdateShift) _ShiftDetailsFooter(shift: shift),
      ],
    );
  }

  Widget _buildDetailGrid(BuildContext context, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DetailItem(label: 'Shift Type', value: shift.shiftType.displayName),
            ),
            Expanded(
              child: _DetailItem(
                label: 'Status',
                widget: DigifyStatusCapsule(status: shift.isActive ? 'Active' : 'Inactive'),
              ),
            ),
          ],
        ),
        Gap(12.h),
        Row(
          children: [
            Expanded(
              child: _DetailItem(label: 'Start Time', value: shift.startTime),
            ),
            Expanded(
              child: _DetailItem(label: 'End Time', value: shift.endTime),
            ),
          ],
        ),
        Gap(12.h),
        Row(
          children: [
            Expanded(
              child: _DetailItem(label: 'Duration', value: '${DurationFormatter.formatHours(shift.totalHours)} hours'),
            ),
            Expanded(
              child: _DetailItem(
                label: 'Break Duration',
                value: '${DurationFormatter.formatHours(shift.breakHours.toDouble())} hour(s)',
              ),
            ),
          ],
        ),
        Gap(12.h),
        Row(
          children: [
            Expanded(
              child: _DetailItem(label: 'Created Date', value: formatDate(shift.createdDate)),
            ),
            Expanded(
              child: _DetailItem(label: 'Updated By', value: shift.updatedBy ?? '-'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShiftDetailsFooter extends ConsumerWidget with ShiftsPermissionMixin {
  final ShiftOverview shift;

  const _ShiftDetailsFooter({required this.shift});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  label: 'Edit Shift',
                  svgPath: Assets.icons.editIcon.path,
                  onPressed: () {
                    Navigator.of(context).pop();
                    final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);
                    if (enterpriseId != null) {
                      UpdateShiftMobileSheet.show(context, shift, enterpriseId: enterpriseId);
                    }
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

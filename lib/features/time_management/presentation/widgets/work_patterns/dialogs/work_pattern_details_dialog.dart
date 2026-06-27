import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/mixins/datetime_conversion_mixin.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/work_pattern_days_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/edit_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/work_pattern_details_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WorkPatternDetailsDialog extends ConsumerWidget with DateTimeConversionMixin, WorkPatternsPermissionMixin {
  final WorkPattern workPattern;

  const WorkPatternDetailsDialog({super.key, required this.workPattern});

  static Future<void> show(BuildContext context, WorkPattern workPattern, {int? enterpriseId}) {
    if (ResponsiveHelper.isMobile(context) && enterpriseId != null) {
      return WorkPatternDetailsMobileSheet.show(context, workPattern, enterpriseId);
    }
    return showDialog(
      context: context,
      builder: (context) => WorkPatternDetailsDialog(workPattern: workPattern),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    return AppDialog(
      title: 'Work Pattern Details',
      width: 700.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDark),
          DigifyDivider(margin: EdgeInsets.symmetric(vertical: 24.h)),
          _buildDetailsGrid(context),
          WorkPatternDaysSection(label: 'Working Days', dayType: 'WORK', workPattern: workPattern),
          Gap(16.h),
          WorkPatternDaysSection(label: 'Rest Days', dayType: 'REST', workPattern: workPattern),
          Gap(16.h),
          WorkPatternDaysSection(label: 'Off Days', dayType: 'OFF', workPattern: workPattern),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Close', onPressed: () => context.pop()),
        if (canUpdateWorkPattern) ...[
          Gap(8.w),
          AppButton(
            label: 'Edit Pattern',
            onPressed: () {
              context.pop();
              final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);
              if (enterpriseId != null) {
                EditWorkPatternDialog.show(context, enterpriseId, workPattern);
              }
            },
            svgPath: Assets.icons.editIcon.path,
            backgroundColor: AppColors.greenButton,
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.leaveManagementMainIcon.path,
            width: 32.w,
            height: 32.w,
            color: AppColors.primary,
          ),
        ),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                workPattern.patternNameEn,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 19.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              if (workPattern.patternNameAr.isNotEmpty) ...[
                Gap(2.h),
                Text(
                  workPattern.patternNameAr,
                  textDirection: TextDirection.rtl,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
              Gap(4.h),
              DigifySquareCapsule(label: workPattern.patternType),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 0.h,
      crossAxisSpacing: 0.w,
      childAspectRatio: 4,
      children: [
        _buildDetailItem(context, 'Pattern Type', workPattern.patternType),
        _buildDetailItem(
          context,
          'Status',
          '',
          widget: DigifyStatusCapsule(status: workPattern.status == PositionStatus.active ? 'Active' : 'Inactive'),
        ),
        _buildDetailItem(context, 'Total Hours/Week', '${workPattern.totalHoursPerWeek} hours'),
        _buildDetailItem(context, 'Created Date', formatDateFromDateTime(workPattern.creationDate)),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, {Widget? widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Gap(4.h),
        widget ?? Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.dialogTitle)),
      ],
    );
  }
}

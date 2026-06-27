import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../data/config/overtime_table_config.dart';
import '../../../providers/overtime/overtime_actions_provider.dart';
import '../../../providers/overtime/overtime_provider.dart';
import '../../../providers/overtime/overtime_table_width_provider.dart';

class OvertimeTableRow extends ConsumerWidget with OvertimePermissionMixin {
  final OvertimeRecord record;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(OvertimeRecord)? onEdit;

  const OvertimeTableRow({
    super.key,
    required this.record,
    required this.localizations,
    required this.isDark,
    required this.isExpanded,
    required this.onToggle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widths = ref.watch(overtimeTableWidthsProvider);
    final dividerColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return InkWell(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: isExpanded
              ? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarActiveBg.withAlpha(128))
              : null,
          border: isExpanded
              ? null
              : Border(
                  bottom: BorderSide(color: dividerColor, width: 1.w),
                ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  if (OvertimeTableConfig.showEmployee) _buildDivider(widths.employee, dividerColor),
                  if (OvertimeTableConfig.showDate) _buildDivider(widths.date, dividerColor),
                  if (OvertimeTableConfig.showType) _buildDivider(widths.type, dividerColor),
                  if (OvertimeTableConfig.showHours) _buildDivider(widths.hours, dividerColor),
                  if (OvertimeTableConfig.showRate) _buildDivider(widths.rate, dividerColor),
                  if (OvertimeTableConfig.showAmount) _buildDivider(widths.amount, dividerColor),
                  if (OvertimeTableConfig.showStatus) _buildDivider(widths.status, dividerColor),
                  if (OvertimeTableConfig.showActions) _buildDivider(widths.actions, dividerColor, isLast: true),
                ],
              ),
            ),
            Row(
              children: [
                if (OvertimeTableConfig.showEmployee)
                  _buildDataCell(
                    Row(
                      children: [
                        AnimatedRotation(
                          turns: isExpanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: isExpanded
                                ? AppColors.statIconBlue
                                : isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.dialogCloseIcon,
                            size: 20.r,
                          ),
                        ),
                        Gap(8.w),
                        AppAvatar(size: 35.w, fallbackInitial: record.employeeNameDisplay),
                        Gap(11.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                record.employeeNameDisplay.toUpperCase(),
                                style: context.theme.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                              ),
                              Gap(2.h),
                              Text(
                                record.employeeIdDisplay,
                                style: context.theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.tableHeaderText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    widths.employee,
                  ),
                if (OvertimeTableConfig.showDate)
                  _buildDataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          record.dateDisplay,
                          style: context.theme.textTheme.labelMedium?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.dialogTitle,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          'Requested: ${record.requestedDateDisplay}',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.tableHeaderText,
                          ),
                        ),
                      ],
                    ),
                    widths.date,
                  ),
                if (OvertimeTableConfig.showType)
                  _buildDataCell(
                    DigifySquareCapsule(
                      label: record.typeDisplay,
                      textColor: AppColors.statIconBlue,
                      backgroundColor: AppColors.statIconBlue.withValues(alpha: 0.1),
                    ),
                    widths.type,
                  ),
                if (OvertimeTableConfig.showHours)
                  _buildDataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${record.overtimeHoursDisplay} hrs',
                          style: context.theme.textTheme.labelMedium?.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.dialogTitle,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          'Regular: ${record.regularHoursDisplay} hrs',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.tableHeaderText,
                          ),
                        ),
                      ],
                    ),
                    widths.hours,
                  ),
                if (OvertimeTableConfig.showRate)
                  _buildDataCell(
                    Text(
                      '${record.rateDisplay}x',
                      style: context.theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.dialogTitle,
                      ),
                    ),
                    widths.rate,
                  ),
                if (OvertimeTableConfig.showAmount)
                  _buildDataCell(
                    Text(
                      'KWD ${record.amountDisplay}',
                      style: context.theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.dialogTitle,
                      ),
                    ),
                    widths.amount,
                  ),
                if (OvertimeTableConfig.showStatus)
                  _buildDataCell(DigifyStatusCapsule(status: record.approvalInformation?.status ?? ""), widths.status),
                if (OvertimeTableConfig.showActions) _buildDataCell(_buildActionsCell(context, ref), widths.actions),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: OvertimeTableConfig.cellPaddingHorizontal.w, vertical: 16.h),
      child: child,
    );
  }

  Widget _buildDivider(double width, Color dividerColor, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: dividerColor, width: 1.w),
              ),
      ),
    );
  }

  Widget _buildActionsCell(BuildContext context, WidgetRef ref) {
    final status = OvertimeStatus.fromString(record.approvalInformation?.status ?? '');
    final state = ref.watch(overtimeManagementProvider);

    if (status == OvertimeStatus.draft) {
      final guid = record.otRequestGuid ?? '';
      final isCanceling = state.cancelingOvertimeGuid == guid;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canUpdateOvertime)
            ActionButtonWidget(
              type: ActionButtonType.edit,
              onTap: isCanceling ? null : () => onEdit?.call(record),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          if (canApproveOvertime) ...[
            Gap(8.w),
            ActionButtonWidget(
              icon: Assets.icons.closeIcon.path,
              color: AppColors.error,
              isLoading: isCanceling,
              onTap: isCanceling ? null : () => OvertimeActions.cancelDraftOvertimeRequest(context, ref, record),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          ],
        ],
      );
    }

    if (status == OvertimeStatus.submitted || status == OvertimeStatus.pending) {
      final guid = record.otRequestGuid ?? '';
      final isApproving = state.approvingOvertimeGuid == guid;
      final isRejecting = state.rejectingOvertimeGuid == guid;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canApproveOvertime) ...[
            ActionButtonWidget(
              isLoading: isApproving,
              icon: Assets.icons.checkIconGreen.path,
              color: AppColors.success,
              onTap: isApproving || isRejecting
                  ? null
                  : () => OvertimeActions.approveOvertimeRequest(context, ref, record),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),

            Gap(8.w),
            ActionButtonWidget(
              icon: Assets.icons.closeIcon.path,
              color: AppColors.error,
              isLoading: isRejecting,
              onTap: isApproving || isRejecting
                  ? null
                  : () => OvertimeActions.rejectOvertimeRequest(context, ref, record),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          ],
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

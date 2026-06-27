import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/security_manager/data/config/active_sessions_table_config.dart';
import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_session_details_dialog.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_session_status_chip.dart';
import 'package:grc/features/security_manager/presentation/providers/active_sessions/active_sessions_table_width_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSessionsTableRow extends ConsumerWidget {
  final ActiveSession session;
  final bool isDark;

  const ActiveSessionsTableRow({super.key, required this.session, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
    );
    final widths = ref.watch(activeSessionsTableWidthsProvider);
    final dividerColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (ActiveSessionsTableConfig.showUserDetails) _buildDivider(widths.user, dividerColor),
                if (ActiveSessionsTableConfig.showLocationAndIp) _buildDivider(widths.locationAndIp, dividerColor),
                if (ActiveSessionsTableConfig.showDeviceAndBrowser)
                  _buildDivider(widths.deviceAndBrowser, dividerColor),
                if (ActiveSessionsTableConfig.showSessionInfo) _buildDivider(widths.sessionInfo, dividerColor),
                if (ActiveSessionsTableConfig.showStatus) _buildDivider(widths.status, dividerColor),
                if (ActiveSessionsTableConfig.showActions) _buildDivider(widths.actions, dividerColor, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (ActiveSessionsTableConfig.showUserDetails)
                _buildCell(
                  Row(
                    children: [
                      AppAvatar(
                        image: null,
                        fallbackInitial: session.userName,
                        size: 44.w,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              session.userName,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Gap(2.h),
                            Text(session.userEmail, style: secondaryStyle),
                            Text(session.employeeId, style: secondaryStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  widths.user,
                ),
              if (ActiveSessionsTableConfig.showLocationAndIp)
                _buildCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.locationPinIcon.path,
                            width: 14.w,
                            height: 14.h,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                          Gap(6.w),
                          Expanded(
                            child: Text(
                              '${session.city}, ${session.country}',
                              style: context.textTheme.labelMedium?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(2.h),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 20.w),
                        child: Text(session.ipAddress, style: secondaryStyle),
                      ),
                    ],
                  ),
                  widths.locationAndIp,
                ),
              if (ActiveSessionsTableConfig.showDeviceAndBrowser)
                _buildCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.securityManager.monitor.path,
                            width: 14.w,
                            height: 14.h,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                          Gap(6.w),
                          Expanded(
                            child: Text(
                              '${session.deviceType} • ${session.deviceName}',
                              style: context.textTheme.labelMedium?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(2.h),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 20.w),
                        child: Text(session.browser, style: secondaryStyle),
                      ),
                    ],
                  ),
                  widths.deviceAndBrowser,
                ),
              if (ActiveSessionsTableConfig.showSessionInfo)
                _buildCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Login', style: context.textTheme.labelMedium?.copyWith(color: AppColors.textPrimary)),
                      Gap(3.h),
                      Text(
                        session.loginAt,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 12.sp,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.grayBorderDark,
                        ),
                      ),
                      Gap(8.h),
                      Text('Last', style: context.textTheme.labelMedium?.copyWith(color: AppColors.textPrimary)),
                      Gap(3.h),
                      Text(
                        session.lastActiveAt,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 12.sp,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.grayBorderDark,
                        ),
                      ),
                    ],
                  ),
                  widths.sessionInfo,
                ),
              if (ActiveSessionsTableConfig.showStatus)
                _buildCell(ActiveSessionStatusChip(status: session.status), widths.status),
              if (ActiveSessionsTableConfig.showActions) _buildCell(_buildActions(context), widths.actions),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ActiveSessionsTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
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

  Widget _buildActions(BuildContext context) {
    final canTerminate = !session.isCurrent;
    return LayoutBuilder(
      builder: (context, constraints) {
        final showLabels = constraints.maxWidth >= 240.w;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: showLabels ? 'Details' : '',
              type: AppButtonType.outline,
              svgPath: Assets.icons.infoCircleAttendance.path,
              height: 32.h,
              fontSize: 13.sp,
              padding: showLabels
                  ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h)
                  : EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.infoBg,
              foregroundColor: AppColors.primary,
              borderColor: isDark ? AppColors.borderGreyDark : AppColors.infoBorder,
              onPressed: () => ActiveSessionDetailsDialog.show(context, session: session),
            ),
            Gap(10.w),
            Opacity(
              opacity: canTerminate ? 1.0 : 0.45,
              child: AppButton.dangerOutline(
                label: showLabels ? 'Terminate' : '',
                svgPath: Assets.icons.securityManager.terminate.path,
                height: 32.h,
                fontSize: 13.sp,
                padding: showLabels
                    ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h)
                    : EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                onPressed: canTerminate
                    ? () async {
                        final confirmed = await AppConfirmationDialog.show(
                          context,
                          title: 'Terminate session?',
                          message: 'This will sign out the user from this device. You can’t undo this action.',
                          itemName: '${session.userName} • ${session.deviceName}',
                          confirmLabel: 'Terminate',
                          type: ConfirmationType.danger,
                          svgPath: Assets.icons.securityManager.terminate.path,
                        );
                        if (confirmed == true && context.mounted) {
                          ToastService.warning(context, 'Terminate session (mock).', title: 'Active Sessions');
                        }
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_session_status_chip.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSessionDetailsDialog extends StatelessWidget {
  final ActiveSession session;

  const ActiveSessionDetailsDialog({super.key, required this.session});

  static Future<void> show(BuildContext context, {required ActiveSession session}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) => ActiveSessionDetailsDialog(session: session),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final canTerminate = !session.isCurrent;

    return AppDialog(
      title: 'Session Details',
      subtitle: 'Complete session information',
      width: 680.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: 'User Information'),
          Gap(10.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                AppAvatar(
                  image: null,
                  fallbackInitial: session.userName,
                  size: 40.w,
                  backgroundColor: AppColors.primary,
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        session.userName,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        session.employeeId,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 11.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(18.h),
          _SectionTitle(text: 'Session Information'),
          Gap(10.h),
          _Grid(
            children: [
              _InfoTile(
                label: 'Session ID',
                value: Text(session.sessionId, style: _valueStyle(context, isDark)),
              ),
              _InfoTile(
                label: 'Status',
                value: ActiveSessionStatusChip(status: session.status),
              ),
              _InfoTile(
                label: 'Login Time',
                value: Text(session.loginAt, style: _valueStyle(context, isDark)),
              ),
              _InfoTile(
                label: 'Last Activity',
                value: Text(session.lastActiveAt, style: _valueStyle(context, isDark)),
              ),
            ],
          ),
          Gap(18.h),
          _SectionTitle(text: 'Location & Network'),
          Gap(10.h),
          _Grid(
            children: [
              _InfoTile(
                label: 'Location',
                svgPath: Assets.icons.locationPinIcon.path,
                value: Text('${session.city}, ${session.country}', style: _valueStyle(context, isDark)),
              ),
              _InfoTile(
                label: 'IP Address',
                svgPath: Assets.icons.leaveManagement.globe.path,
                value: Text(session.ipAddress, style: _valueStyle(context, isDark)),
              ),
            ],
          ),
          Gap(18.h),
          _SectionTitle(text: 'Device Information'),
          Gap(10.h),
          _Grid(
            children: [
              _InfoTile(
                label: 'Device',
                svgPath: Assets.icons.securityManager.monitor.path,
                value: Text('${session.deviceName} ${session.deviceType}', style: _valueStyle(context, isDark)),
              ),
              _InfoTile(
                label: 'Browser',
                svgPath: Assets.icons.securityManager.chrome.path,
                value: Text(session.browser, style: _valueStyle(context, isDark)),
              ),
            ],
          ),
        ],
      ),
      actions: [
        AppButton(label: 'Close', type: AppButtonType.outline, height: 40.h, onPressed: () => context.pop()),
        Gap(12.w),
        Opacity(
          opacity: canTerminate ? 1.0 : 0.5,
          child: AppButton(
            label: 'Terminate Session',
            type: AppButtonType.danger,
            svgPath: Assets.icons.securityManager.terminate.path,
            height: 40.h,
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
                      context.pop();
                      ToastService.warning(context, 'Terminate session (mock).', title: 'Active Sessions');
                    }
                  }
                : null,
          ),
        ),
      ],
    );
  }

  TextStyle? _valueStyle(BuildContext context, bool isDark) {
    return context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle);
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Text(
      text,
      style: context.textTheme.headlineMedium?.copyWith(
        fontSize: 14.sp,
        color: isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark,
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<Widget> children;

  const _Grid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.w;
        final isTwoCol = constraints.maxWidth >= 560.w;
        final tileWidth = isTwoCol ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [for (final child in children) SizedBox(width: tileWidth, child: child)],
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final Widget value;
  final String? svgPath;

  const _InfoTile({required this.label, required this.value, this.svgPath});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveLabelStyle = context.textTheme.headlineMedium?.copyWith(
      fontSize: 11.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
      letterSpacing: 0.5,
    );

    return Container(
      constraints: BoxConstraints(minHeight: 60.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (svgPath != null) ...[_TileIcon(svgPath: svgPath), Gap(7.w)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label.toUpperCase(), style: effectiveLabelStyle),
                Gap(4.h),
                value,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  final String? svgPath;

  const _TileIcon({this.svgPath});

  @override
  Widget build(BuildContext context) {
    final size = 14.w;
    final color = AppColors.primary;

    if (svgPath != null) {
      return DigifyAsset(assetPath: svgPath!, width: size, height: size, color: color);
    }
    return const SizedBox.shrink();
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/data/config/active_sessions_table_config.dart';
import 'package:grc/features/security_manager/presentation/providers/active_sessions/active_sessions_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveSessionsTableHeader extends ConsumerWidget {
  final bool isDark;

  const ActiveSessionsTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widths = ref.watch(activeSessionsTableWidthsProvider);
    final lastColumn = _lastVisibleColumn();
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          if (ActiveSessionsTableConfig.showUserDetails)
            _buildHeaderCell(
              context,
              'User Details',
              widths.user,
              ActiveSessionsColumn.userDetails,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == ActiveSessionsColumn.userDetails,
            ),
          if (ActiveSessionsTableConfig.showLocationAndIp)
            _buildHeaderCell(
              context,
              'Location & IP',
              widths.locationAndIp,
              ActiveSessionsColumn.locationAndIp,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == ActiveSessionsColumn.locationAndIp,
            ),
          if (ActiveSessionsTableConfig.showDeviceAndBrowser)
            _buildHeaderCell(
              context,
              'Device & Browser',
              widths.deviceAndBrowser,
              ActiveSessionsColumn.deviceAndBrowser,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == ActiveSessionsColumn.deviceAndBrowser,
            ),
          if (ActiveSessionsTableConfig.showSessionInfo)
            _buildHeaderCell(
              context,
              'Session Info',
              widths.sessionInfo,
              ActiveSessionsColumn.sessionInfo,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == ActiveSessionsColumn.sessionInfo,
            ),
          if (ActiveSessionsTableConfig.showStatus)
            _buildHeaderCell(
              context,
              'Status',
              widths.status,
              ActiveSessionsColumn.status,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == ActiveSessionsColumn.status,
            ),
          if (ActiveSessionsTableConfig.showActions)
            _buildHeaderCell(
              context,
              'Actions',
              widths.actions,
              ActiveSessionsColumn.actions,
              ref,
              borderColor: borderColor,
              isLast: true,
            ),
        ],
      ),
    );
  }

  ActiveSessionsColumn _lastVisibleColumn() {
    if (ActiveSessionsTableConfig.showActions) return ActiveSessionsColumn.actions;
    if (ActiveSessionsTableConfig.showStatus) return ActiveSessionsColumn.status;
    if (ActiveSessionsTableConfig.showSessionInfo) return ActiveSessionsColumn.sessionInfo;
    if (ActiveSessionsTableConfig.showDeviceAndBrowser) return ActiveSessionsColumn.deviceAndBrowser;
    if (ActiveSessionsTableConfig.showLocationAndIp) return ActiveSessionsColumn.locationAndIp;
    return ActiveSessionsColumn.userDetails;
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    ActiveSessionsColumn column,
    WidgetRef ref, {
    required Color borderColor,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : borderColor, width: 1.w),
          bottom: BorderSide(color: borderColor, width: 1.w),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: ActiveSessionsTableConfig.cellPaddingHorizontal.w,
              vertical: 14.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.tableHeaderText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isLast)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 15.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  ref.read(activeSessionsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

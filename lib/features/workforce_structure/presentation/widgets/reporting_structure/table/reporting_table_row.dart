import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_table_width_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/configs/reporting_table_config.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportingTableRow extends ConsumerWidget {
  final ReportingPosition position;
  final bool isDark;
  final AppLocalizations localizations;
  final Function(ReportingPosition)? onView;
  final Function(ReportingPosition)? onEdit;

  const ReportingTableRow({
    super.key,
    required this.position,
    required this.isDark,
    required this.localizations,
    this.onView,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final widths = ref.watch(reportingTableWidthsProvider);
    final isTopLevel = position.reportsToTitle == null || position.reportsToTitle!.trim().isEmpty;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (ReportingTableConfig.showCode) _buildDivider(widths.code),
                if (ReportingTableConfig.showTitle) _buildDivider(widths.title),
                if (ReportingTableConfig.showDepartment) _buildDivider(widths.department),
                if (ReportingTableConfig.showLevel) _buildDivider(widths.level),
                if (ReportingTableConfig.showGrade) _buildDivider(widths.grade),
                if (ReportingTableConfig.showReportsTo) _buildDivider(widths.reportsTo),
                if (ReportingTableConfig.showStatus) _buildDivider(widths.status),
                if (ReportingTableConfig.showActions) _buildDivider(widths.actions, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (ReportingTableConfig.showCode)
                _buildDataCell(
                  Text(
                    position.positionCode.toUpperCase(),
                    style: textStyle?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widths.code,
                ),
              if (ReportingTableConfig.showTitle)
                _buildDataCell(
                  Text(position.titleEnglish, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  widths.title,
                ),
              if (ReportingTableConfig.showDepartment)
                _buildDataCell(
                  Text(
                    position.department.toUpperCase(),
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widths.department,
                ),
              if (ReportingTableConfig.showLevel)
                _buildDataCell(
                  Text(position.level, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  widths.level,
                ),
              if (ReportingTableConfig.showGrade)
                _buildDataCell(
                  Text(position.gradeStep, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  widths.grade,
                ),
              if (ReportingTableConfig.showReportsTo)
                _buildDataCell(
                  isTopLevel
                      ? DigifyCapsule(
                          label: 'TOP LEVEL',
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          textColor: AppColors.primary,
                          borderColor: AppColors.primary.withValues(alpha: 0.2),
                        )
                      : Text(position.reportsToTitle!, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  widths.reportsTo,
                ),
              if (ReportingTableConfig.showStatus) _buildDataCell(_buildStatusCapsule(), widths.status),
              if (ReportingTableConfig.showActions)
                _buildDataCell(
                  ReportingActionButtons(position: position, onView: onView, onEdit: onEdit),
                  widths.actions,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCapsule() {
    final isActive = position.status.toLowerCase() == 'active';
    return DigifyCapsule(
      label: (isActive ? localizations.active : localizations.inactive).toUpperCase(),
      backgroundColor: isActive ? AppColors.activeStatusBg : AppColors.inactiveStatusBg,
      textColor: isActive ? AppColors.successText : AppColors.inactiveStatusText,
      borderColor: isActive ? AppColors.activeStatusBorder : AppColors.inactiveStatusBorder,
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ReportingTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildDivider(double width, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }
}

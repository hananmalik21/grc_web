import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/workforce_structure/data/config/workforce_positions_table_config.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/screens/positions/positions_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/position_badges.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_positions_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionTableRow extends ConsumerWidget with PositionsPermissionMixin {
  final Position position;
  final AppLocalizations localizations;
  final Function(Position) onView;
  final Function(Position) onEdit;
  final Function(Position) onDelete;

  const PositionTableRow({
    super.key,
    required this.position,
    required this.localizations,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletingId = ref.watch(
      positionNotifierProvider.select((_) => ref.read(positionNotifierProvider.notifier).deletingPositionId),
    );
    final isDeleting = deletingId == position.id;
    final widths = ref.watch(positionTableWidthsProvider);

    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
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
                if (WorkforcePositionsTableConfig.showPositionCode) _buildDivider(widths.positionCode),
                if (WorkforcePositionsTableConfig.showTitle) _buildDivider(widths.title),
                if (WorkforcePositionsTableConfig.showDepartment) _buildDivider(widths.department),
                if (WorkforcePositionsTableConfig.showJobFamily) _buildDivider(widths.jobFamily),
                if (WorkforcePositionsTableConfig.showJobLevel) _buildDivider(widths.jobLevel),
                if (WorkforcePositionsTableConfig.showGradeStep) _buildDivider(widths.gradeStep),
                if (WorkforcePositionsTableConfig.showReportsTo) _buildDivider(widths.reportsTo),
                if (WorkforcePositionsTableConfig.showHeadcount) _buildDivider(widths.headcount),
                if (WorkforcePositionsTableConfig.showVacancy) _buildDivider(widths.vacancy),
                if (WorkforcePositionsTableConfig.showStatus) _buildDivider(widths.status),
                if (WorkforcePositionsTableConfig.showActions) _buildDivider(widths.actions, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (WorkforcePositionsTableConfig.showPositionCode)
                _buildDataCell(Text(position.code, style: textStyle), widths.positionCode),
              if (WorkforcePositionsTableConfig.showTitle)
                _buildDataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(position.titleEnglish, style: textStyle),
                      Text(
                        position.titleArabic,
                        textDirection: TextDirection.rtl,
                        style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: AppColors.tableHeaderText),
                      ),
                    ],
                  ),
                  widths.title,
                ),
              if (WorkforcePositionsTableConfig.showDepartment)
                _buildDataCell(Text(position.department, style: textStyle), widths.department),
              if (WorkforcePositionsTableConfig.showJobFamily)
                _buildDataCell(Text(position.jobFamily, style: textStyle), widths.jobFamily),
              if (WorkforcePositionsTableConfig.showJobLevel)
                _buildDataCell(Text(position.level, style: textStyle), widths.jobLevel),
              if (WorkforcePositionsTableConfig.showGradeStep)
                _buildDataCell(
                  Text(
                    '${position.grade.isNotEmpty ? 'Grade ${position.grade}' : ''}${position.grade.isNotEmpty && position.step.isNotEmpty ? ' / ' : ''}${position.step.isNotEmpty ? (position.step.toLowerCase().contains('step') ? position.step : 'Step ${position.step}') : ''}',
                    style: textStyle,
                  ),
                  widths.gradeStep,
                ),
              if (WorkforcePositionsTableConfig.showReportsTo)
                _buildDataCell(Text(position.reportsTo ?? '-', style: textStyle), widths.reportsTo),
              if (WorkforcePositionsTableConfig.showHeadcount)
                _buildDataCell(
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${position.filled}', style: textStyle),
                        TextSpan(text: '/${position.headcount}', style: textStyle),
                      ],
                    ),
                  ),
                  widths.headcount,
                ),
              if (WorkforcePositionsTableConfig.showVacancy)
                _buildDataCell(
                  PositionVacancyBadge(
                    vacancy: position.headcount - position.filled,
                    vacantLabel: localizations.vacant,
                    fullLabel: 'Full',
                  ),
                  widths.vacancy,
                ),
              if (WorkforcePositionsTableConfig.showStatus)
                _buildDataCell(DigifyStatusCapsule(status: position.status), widths.status),
              if (WorkforcePositionsTableConfig.showActions)
                _buildDataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.w,
                    children: [
                      if (canViewPosition)
                        ActionButtonWidget(
                          type: ActionButtonType.view,
                          onTap: () => onView(position),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canUpdatePosition)
                        ActionButtonWidget(
                          type: ActionButtonType.edit,
                          onTap: () => onEdit(position),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canDeletePosition)
                        ActionButtonWidget(
                          type: ActionButtonType.delete,
                          onTap: isDeleting ? null : () => onDelete(position),
                          isLoading: isDeleting,
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                    ],
                  ),
                  widths.actions,
                  isLast: true,
                ),
            ],
          ),
        ],
      ),
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

  Widget _buildDataCell(Widget child, double width, {bool isLast = false}) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: child,
    );
  }
}

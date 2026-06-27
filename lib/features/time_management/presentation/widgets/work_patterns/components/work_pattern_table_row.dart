import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/data/config/work_patterns_table_config.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_table_width_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/work_pattern_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternTableRow extends ConsumerWidget {
  final WorkPattern workPattern;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WorkPatternTableRow({super.key, required this.workPattern, this.onView, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final widths = ref.watch(workPatternsTableWidthsProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (WorkPatternsTableConfig.showCode) _buildDivider(widths.code, isDark),
                if (WorkPatternsTableConfig.showName) _buildDivider(widths.name, isDark),
                if (WorkPatternsTableConfig.showType) _buildDivider(widths.type, isDark),
                if (WorkPatternsTableConfig.showWorkingDays) _buildDivider(widths.workingDays, isDark),
                if (WorkPatternsTableConfig.showRestDays) _buildDivider(widths.restDays, isDark),
                if (WorkPatternsTableConfig.showOffDays) _buildDivider(widths.offDays, isDark),
                if (WorkPatternsTableConfig.showHoursPerWeek) _buildDivider(widths.hoursPerWeek, isDark),
                if (WorkPatternsTableConfig.showStatus) _buildDivider(widths.status, isDark),
                if (WorkPatternsTableConfig.showActions) _buildDivider(widths.actions, isDark, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (WorkPatternsTableConfig.showCode)
                _buildDataCell(
                  Text(
                    workPattern.patternCode,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  widths.code,
                ),
              if (WorkPatternsTableConfig.showName)
                _buildDataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        workPattern.patternNameEn,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      if (workPattern.patternNameAr.isNotEmpty) ...[
                        Gap(2.h),
                        Text(
                          workPattern.patternNameAr,
                          textDirection: TextDirection.rtl,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  widths.name,
                ),
              if (WorkPatternsTableConfig.showType)
                _buildDataCell(DigifySquareCapsule(label: workPattern.patternType), widths.type),
              if (WorkPatternsTableConfig.showWorkingDays)
                _buildDataCell(
                  Text(
                    '${workPattern.workingDays} ${workPattern.workingDays == 1 ? 'day' : 'days'}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  widths.workingDays,
                ),
              if (WorkPatternsTableConfig.showRestDays)
                _buildDataCell(
                  Text(
                    '${workPattern.restDays} ${workPattern.restDays == 1 ? 'day' : 'days'}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  widths.restDays,
                ),
              if (WorkPatternsTableConfig.showOffDays)
                _buildDataCell(
                  Text(
                    '${workPattern.offDays} ${workPattern.offDays == 1 ? 'day' : 'days'}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  widths.offDays,
                ),
              if (WorkPatternsTableConfig.showHoursPerWeek)
                _buildDataCell(
                  Text(
                    '${workPattern.totalHoursPerWeek}h',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  widths.hoursPerWeek,
                ),
              if (WorkPatternsTableConfig.showStatus)
                _buildDataCell(
                  DigifyStatusCapsule(status: workPattern.status == PositionStatus.active ? 'Active' : 'Inactive'),
                  widths.status,
                ),
              if (WorkPatternsTableConfig.showActions)
                _buildDataCell(
                  WorkPatternActionButtons(onView: onView, onEdit: onEdit, onDelete: onDelete),
                  widths.actions,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: child,
    );
  }

  Widget _buildDivider(double width, bool isDark, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }
}

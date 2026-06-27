import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/data/config/work_patterns_table_config.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const WorkPatternTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(workPatternsTableWidthsProvider);

    final headerCells = <Widget>[];

    if (WorkPatternsTableConfig.showCode) {
      headerCells.add(_buildHeaderCell(context, localizations.code, widths.code, WorkPatternColumn.code, ref));
    }
    if (WorkPatternsTableConfig.showName) {
      headerCells.add(_buildHeaderCell(context, 'NAME', widths.name, WorkPatternColumn.name, ref));
    }
    if (WorkPatternsTableConfig.showType) {
      headerCells.add(_buildHeaderCell(context, 'TYPE', widths.type, WorkPatternColumn.type, ref));
    }
    if (WorkPatternsTableConfig.showWorkingDays) {
      headerCells.add(
        _buildHeaderCell(context, 'WORKING DAYS', widths.workingDays, WorkPatternColumn.workingDays, ref),
      );
    }
    if (WorkPatternsTableConfig.showRestDays) {
      headerCells.add(_buildHeaderCell(context, 'REST DAYS', widths.restDays, WorkPatternColumn.restDays, ref));
    }
    if (WorkPatternsTableConfig.showOffDays) {
      headerCells.add(_buildHeaderCell(context, 'OFF DAYS', widths.offDays, WorkPatternColumn.offDays, ref));
    }
    if (WorkPatternsTableConfig.showHoursPerWeek) {
      headerCells.add(
        _buildHeaderCell(context, 'HOURS/WEEK', widths.hoursPerWeek, WorkPatternColumn.hoursPerWeek, ref),
      );
    }
    if (WorkPatternsTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, widths.status, WorkPatternColumn.status, ref));
    }
    if (WorkPatternsTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(context, localizations.actions, widths.actions, WorkPatternColumn.actions, ref, isLast: true),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    WorkPatternColumn column,
    WidgetRef ref, {
    bool isLast = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
            alignment: Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
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
                  ref.read(workPatternsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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

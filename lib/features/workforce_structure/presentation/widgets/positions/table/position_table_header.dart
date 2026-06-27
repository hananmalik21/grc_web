import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/workforce_structure/data/config/workforce_positions_table_config.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_positions_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const PositionTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(positionTableWidthsProvider);

    final headerCells = <Widget>[];

    if (WorkforcePositionsTableConfig.showPositionCode) {
      headerCells.add(
        _buildResizableHeaderCell(
          context,
          localizations.positionCode,
          widths.positionCode,
          PositionColumn.positionCode,
          ref,
        ),
      );
    }
    if (WorkforcePositionsTableConfig.showTitle) {
      headerCells.add(_buildResizableHeaderCell(context, localizations.title, widths.title, PositionColumn.title, ref));
    }
    if (WorkforcePositionsTableConfig.showDepartment) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.department, widths.department, PositionColumn.department, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showJobFamily) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.jobFamily, widths.jobFamily, PositionColumn.jobFamily, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showJobLevel) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.jobLevel, widths.jobLevel, PositionColumn.jobLevel, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showGradeStep) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.gradeStep, widths.gradeStep, PositionColumn.gradeStep, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showReportsTo) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.reportsTo, widths.reportsTo, PositionColumn.reportsTo, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showHeadcount) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.headcount, widths.headcount, PositionColumn.headcount, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showVacancy) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.vacancy, widths.vacancy, PositionColumn.vacancy, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showStatus) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.status, widths.status, PositionColumn.status, ref),
      );
    }
    if (WorkforcePositionsTableConfig.showActions) {
      headerCells.add(
        _buildResizableHeaderCell(
          context,
          localizations.actions,
          widths.actions,
          PositionColumn.actions,
          ref,
          isLast: true,
        ),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildResizableHeaderCell(
    BuildContext context,
    String text,
    double width,
    PositionColumn columnKey,
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
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
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
                  ref.read(positionTableWidthsProvider.notifier).updateWidth(columnKey, details.delta.dx);
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

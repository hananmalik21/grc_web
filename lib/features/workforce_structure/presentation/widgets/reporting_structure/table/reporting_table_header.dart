import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_table_width_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/configs/reporting_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportingTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ReportingTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(reportingTableWidthsProvider);

    final headerCells = <Widget>[];

    if (ReportingTableConfig.showCode) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.positionCode, widths.code, ReportingColumn.code, ref),
      );
    }
    if (ReportingTableConfig.showTitle) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.titleEnglish, widths.title, ReportingColumn.title, ref),
      );
    }
    if (ReportingTableConfig.showDepartment) {
      headerCells.add(
        _buildResizableHeaderCell(
          context,
          localizations.department,
          widths.department,
          ReportingColumn.department,
          ref,
        ),
      );
    }
    if (ReportingTableConfig.showLevel) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.jobLevel, widths.level, ReportingColumn.level, ref),
      );
    }
    if (ReportingTableConfig.showGrade) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.gradeStep, widths.grade, ReportingColumn.grade, ref),
      );
    }
    if (ReportingTableConfig.showReportsTo) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.reportsTo, widths.reportsTo, ReportingColumn.reportsTo, ref),
      );
    }
    if (ReportingTableConfig.showStatus) {
      headerCells.add(
        _buildResizableHeaderCell(context, localizations.status, widths.status, ReportingColumn.status, ref),
      );
    }
    if (ReportingTableConfig.showActions) {
      headerCells.add(
        _buildResizableHeaderCell(
          context,
          localizations.actions,
          widths.actions,
          ReportingColumn.actions,
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
    String label,
    double width,
    ReportingColumn columnKey,
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
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: ReportingTableConfig.cellPaddingHorizontal.w,
              vertical: 14.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              label.toUpperCase(),
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
                  ref.read(reportingTableWidthsProvider.notifier).updateWidth(columnKey, details.delta.dx);
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

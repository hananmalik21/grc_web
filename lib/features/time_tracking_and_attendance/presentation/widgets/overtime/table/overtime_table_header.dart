import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../data/config/overtime_table_config.dart';
import '../../../providers/overtime/overtime_table_width_provider.dart';

class OvertimeTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const OvertimeTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(overtimeTableWidthsProvider);
    final lastColumn = _lastVisibleColumn();
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    final headerCells = <Widget>[];

    if (OvertimeTableConfig.showEmployee) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'EMPLOYEE',
          widths.employee,
          OvertimeColumn.employee,
          ref,
          borderColor: borderColor,
          isLast: lastColumn == OvertimeColumn.employee,
        ),
      );
    }
    if (OvertimeTableConfig.showDate) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'DATE',
          widths.date,
          OvertimeColumn.date,
          ref,
          borderColor: borderColor,
          isLast: lastColumn == OvertimeColumn.date,
        ),
      );
    }
    if (OvertimeTableConfig.showType) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'TYPE',
          widths.type,
          OvertimeColumn.type,
          ref,
          borderColor: borderColor,
          isLast: lastColumn == OvertimeColumn.type,
        ),
      );
    }
    if (OvertimeTableConfig.showHours) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'HOURS',
          widths.hours,
          OvertimeColumn.hours,
          ref,
          borderColor: borderColor,
          isLast: lastColumn == OvertimeColumn.hours,
        ),
      );
    }
    if (OvertimeTableConfig.showRate) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'RATE',
          widths.rate,
          OvertimeColumn.rate,
          ref,
          borderColor: borderColor,
          isLast: lastColumn == OvertimeColumn.rate,
        ),
      );
    }
    if (OvertimeTableConfig.showAmount) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'AMOUNT',
          widths.amount,
          OvertimeColumn.amount,
          ref,
          borderColor: borderColor,
          isLast: lastColumn == OvertimeColumn.amount,
        ),
      );
    }
    if (OvertimeTableConfig.showStatus) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'STATUS',
          widths.status,
          OvertimeColumn.status,
          ref,
          borderColor: borderColor,
          isLast: lastColumn == OvertimeColumn.status,
        ),
      );
    }
    if (OvertimeTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'ACTION',
          widths.actions,
          OvertimeColumn.actions,
          ref,
          borderColor: borderColor,
          isLast: true,
        ),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  OvertimeColumn _lastVisibleColumn() {
    if (OvertimeTableConfig.showActions) return OvertimeColumn.actions;
    if (OvertimeTableConfig.showStatus) return OvertimeColumn.status;
    if (OvertimeTableConfig.showAmount) return OvertimeColumn.amount;
    if (OvertimeTableConfig.showRate) return OvertimeColumn.rate;
    if (OvertimeTableConfig.showHours) return OvertimeColumn.hours;
    if (OvertimeTableConfig.showType) return OvertimeColumn.type;
    if (OvertimeTableConfig.showDate) return OvertimeColumn.date;
    return OvertimeColumn.employee;
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    OvertimeColumn column,
    WidgetRef ref, {
    required Color borderColor,
    TextAlign textAlign = TextAlign.left,
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
              horizontal: OvertimeTableConfig.cellPaddingHorizontal.w,
              vertical: 14.h,
            ),
            alignment: textAlign == TextAlign.center ? Alignment.center : Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
              textAlign: textAlign,
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
                  ref.read(overtimeTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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

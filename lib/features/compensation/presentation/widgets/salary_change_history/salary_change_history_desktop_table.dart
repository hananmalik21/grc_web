import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/compensation/domain/models/adjustments/salary_change_history.dart';
import 'package:grc/features/compensation/presentation/providers/salary_change_history_table_width_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_change_history_tab_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_config.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_detail_dialog.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_table_config.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_table_types.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SalaryChangeHistoryDesktopTable extends ConsumerStatefulWidget {
  const SalaryChangeHistoryDesktopTable({required this.sectionSpacing, super.key});

  final double sectionSpacing;

  @override
  ConsumerState<SalaryChangeHistoryDesktopTable> createState() => _SalaryChangeHistoryDesktopTableState();
}

class _SalaryChangeHistoryDesktopTableState extends ConsumerState<SalaryChangeHistoryDesktopTable> {
  final _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  SalaryChangeHistoryTableRowData _mapToRowData(SalaryChangeHistoryEntry entry) {
    return SalaryChangeHistoryTableRowData(
      employeeName: entry.employeeNameEn,
      employeeId: entry.employeeNumber,
      changeId: entry.displayChangeId,
      changeDate: entry.submissionDate != null ? entry.displayEffectiveDate : '-',
      department: entry.orgStructureList.isNotEmpty ? entry.orgStructureList.first.orgUnitNameEn : '-',
      jobTitle: entry.positionName,
      gradeName: entry.gradeName,
      changeType: entry.changeType,
      effectiveDate: entry.displayEffectiveDate,
      previousSalaryLabel: entry.formattedPreviousSalary,
      newSalaryLabel: entry.formattedCurrentSalary,
      changeAmountLabel: entry.formattedImpactAmount,
      changePercentLabel: entry.formattedImpactPercent,
      isIncrease: entry.isIncrease,
      isDecrease: entry.isDecrease,
      status: entry.status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(salaryChangeHistoryTableWidthsProvider);
    final dataAsync = ref.watch(salaryChangeHistoryDataPageProvider);
    final tabNotifier = ref.read(salaryChangeHistoryTabProvider.notifier);

    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard;

    final totalWidth =
        state.columnOrder.fold<double>(0, (sum, col) => sum + state.widthFor(col)) +
        SalaryChangeHistoryTableConfig.actionsWidth.w;

    final tableMinHeight = context
        .responsiveFine<double>(mobile: 440, tabletSmall: 440, tabletMedium: 460, tabletLarge: 480, desktop: 500)
        .h;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: tableMinHeight),
              child: Column(
                children: [
                  SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: totalWidth,
                      child: Column(
                        children: [
                          _SalaryChangeHistoryTableHeader(isDark: isDark),
                          dataAsync.when(
                            skipLoadingOnRefresh: false,
                            data: (page) {
                              if (dataAsync.isRefreshing || dataAsync.isReloading) {
                                return _buildSkeleton(isDark);
                              }
                              if (page.data.isEmpty) {
                                return TableEmptyState(
                                  width: totalWidth,
                                  title: 'No Salary Change History',
                                  message: 'No records match your filters.',
                                );
                              }
                              return Column(
                                children: [
                                  for (final entry in page.data)
                                    _SalaryChangeHistoryTableRow(row: _mapToRowData(entry), isDark: isDark),
                                ],
                              );
                            },
                            loading: () => _buildSkeleton(isDark),
                            error: (err, stack) => TableEmptyState(
                              width: totalWidth,
                              title: 'Error Loading Data',
                              message: err.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: widget.sectionSpacing),
                ],
              ),
            ),
          ),
          dataAsync.maybeWhen(
            data: (page) => PaginationControls(
              currentPage: page.pagination.page,
              totalPages: page.pagination.totalPages,
              totalItems: page.pagination.total,
              pageSize: page.pagination.limit,
              hasNext: page.pagination.hasNext,
              hasPrevious: page.pagination.hasPrevious,
              onPrevious: page.pagination.hasPrevious ? tabNotifier.previousPage : null,
              onNext: page.pagination.hasNext
                  ? () => tabNotifier.nextPage(totalPages: page.pagination.totalPages)
                  : null,
              isLoading: dataAsync.isRefreshing || dataAsync.isReloading,
              showBorder: true,
              style: PaginationStyle.simple,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(bool isDark) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          5,
          (index) => _SalaryChangeHistoryTableRow(row: SalaryChangeHistoryConfig.mockTableRows.first, isDark: isDark),
        ),
      ),
    );
  }
}

class _SalaryChangeHistoryTableHeader extends ConsumerWidget {
  final bool isDark;

  const _SalaryChangeHistoryTableHeader({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salaryChangeHistoryTableWidthsProvider);
    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      SalaryChangeHistoryTableConfig.actionsWidth.w,
    ];

    return Container(
      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                for (var i = 0; i < dividerWidths.length; i++)
                  _DividerCell(width: dividerWidths[i], isLast: i == dividerWidths.length - 1),
              ],
            ),
          ),
          Row(
            children: [
              ...state.columnOrder.map((column) {
                return _buildDraggableResizableCell(
                  context,
                  ref,
                  column: column,
                  label: _labelFor(column),
                  width: state.widthFor(column),
                );
              }),
              _HeaderCell(
                label: 'ACTIONS',
                width: SalaryChangeHistoryTableConfig.actionsWidth.w,
                isLast: true,
                alignment: Alignment.centerLeft,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableResizableCell(
    BuildContext context,
    WidgetRef ref, {
    required SalaryChangeHistoryTableColumn column,
    required String label,
    required double width,
  }) {
    return DragTarget<SalaryChangeHistoryTableColumn>(
      onWillAcceptWithDetails: (details) => details.data != column,
      onAcceptWithDetails: (details) {
        ref.read(salaryChangeHistoryTableWidthsProvider.notifier).reorderColumn(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<SalaryChangeHistoryTableColumn>(
          data: column,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.9,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: width, height: 44.h),
                child: _ResizableHeaderCell(
                  label: label,
                  width: width,
                  onResize: (delta) =>
                      ref.read(salaryChangeHistoryTableWidthsProvider.notifier).updateWidth(column, delta),
                ),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.35,
            child: _ResizableHeaderCell(
              label: label,
              width: width,
              onResize: (delta) => ref.read(salaryChangeHistoryTableWidthsProvider.notifier).updateWidth(column, delta),
            ),
          ),
          child: _ResizableHeaderCell(
            label: label,
            width: width,
            onResize: (delta) => ref.read(salaryChangeHistoryTableWidthsProvider.notifier).updateWidth(column, delta),
          ),
        );
      },
    );
  }

  static String _labelFor(SalaryChangeHistoryTableColumn column) {
    return switch (column) {
      SalaryChangeHistoryTableColumn.changeId => 'CHANGE ID',
      SalaryChangeHistoryTableColumn.employee => 'EMPLOYEE',
      SalaryChangeHistoryTableColumn.department => 'DEPARTMENT',
      SalaryChangeHistoryTableColumn.changeType => 'CHANGE TYPE',
      SalaryChangeHistoryTableColumn.effectiveDate => 'EFFECTIVE DATE',
      SalaryChangeHistoryTableColumn.previousSalary => 'PREVIOUS SALARY',
      SalaryChangeHistoryTableColumn.newSalary => 'NEW SALARY',
      SalaryChangeHistoryTableColumn.change => 'CHANGE',
      SalaryChangeHistoryTableColumn.status => 'STATUS',
    };
  }
}

class _SalaryChangeHistoryTableRow extends ConsumerWidget {
  final SalaryChangeHistoryTableRowData row;
  final bool isDark;

  const _SalaryChangeHistoryTableRow({required this.row, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salaryChangeHistoryTableWidthsProvider);

    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      SalaryChangeHistoryTableConfig.actionsWidth.w,
    ];

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
                for (var i = 0; i < dividerWidths.length; i++)
                  _DividerCell(width: dividerWidths[i], isLast: i == dividerWidths.length - 1),
              ],
            ),
          ),
          Row(
            children: [
              for (final column in state.columnOrder)
                _DataCell(width: state.widthFor(column), child: _buildCellContent(context, column)),
              _DataCell(
                width: SalaryChangeHistoryTableConfig.actionsWidth.w,
                child: _ViewButton(row: row),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCellContent(BuildContext context, SalaryChangeHistoryTableColumn column) {
    return switch (column) {
      SalaryChangeHistoryTableColumn.changeId => _ChangeIdCell(
        changeId: row.changeId,
        changeDate: row.changeDate,
        isDark: isDark,
      ),
      SalaryChangeHistoryTableColumn.employee => _DoubleLineCell(
        primary: row.employeeName,
        secondary: row.employeeId,
        primaryBold: true,
        isDark: isDark,
      ),
      SalaryChangeHistoryTableColumn.department => _DoubleLineCell(
        primary: row.department,
        secondary: row.jobTitle,
        isDark: isDark,
      ),
      SalaryChangeHistoryTableColumn.changeType => Align(
        alignment: Alignment.centerLeft,
        child: DigifyCapsule(
          label: row.changeType,
          backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
          textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
      SalaryChangeHistoryTableColumn.effectiveDate => _DateCell(date: row.effectiveDate, isDark: isDark),
      SalaryChangeHistoryTableColumn.previousSalary => _BodyText(text: row.previousSalaryLabel, isDark: isDark),
      SalaryChangeHistoryTableColumn.newSalary => _BodyText(text: row.newSalaryLabel, isDark: isDark, bold: true),
      SalaryChangeHistoryTableColumn.change => _ChangeCell(
        amount: row.changeAmountLabel,
        percent: row.changePercentLabel,
        isIncrease: row.isIncrease,
        isDecrease: row.isDecrease,
      ),
      SalaryChangeHistoryTableColumn.status => Align(
        alignment: Alignment.centerLeft,
        child: DigifyStatusCapsule(status: row.status),
      ),
    };
  }
}

class _DividerCell extends StatelessWidget {
  final double width;
  final bool isLast;

  const _DividerCell({required this.width, required this.isLast});

  @override
  Widget build(BuildContext context) {
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

class _HeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final bool isLast;
  final Alignment alignment;

  const _HeaderCell({required this.label, required this.width, required this.isLast, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      alignment: alignment,
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }
}

class _ResizableHeaderCell extends StatelessWidget {
  final String label;
  final double width;
  final ValueChanged<double> onResize;

  const _ResizableHeaderCell({required this.label, required this.width, required this.onResize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          _HeaderCell(label: label, width: width, isLast: false, alignment: Alignment.centerLeft),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 15.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) => onResize(details.delta.dx),
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

class _DataCell extends StatelessWidget {
  final double width;
  final Widget child;

  const _DataCell({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 16.h),
        child: child,
      ),
    );
  }
}

class _ChangeIdCell extends StatelessWidget {
  final String changeId;
  final String changeDate;
  final bool isDark;

  const _ChangeIdCell({required this.changeId, required this.changeDate, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          changeId,
          style: context.textTheme.labelMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(2.h),
        Text(
          changeDate,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            height: 1.35,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _DoubleLineCell extends StatelessWidget {
  final String primary;
  final String secondary;
  final bool isDark;
  final bool primaryBold;

  const _DoubleLineCell({
    required this.primary,
    required this.secondary,
    required this.isDark,
    this.primaryBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primary,
          style: context.textTheme.labelMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: primaryBold ? FontWeight.w500 : FontWeight.w400,
            height: 1.4,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(2.h),
        Text(
          secondary,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            height: 1.35,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _DateCell extends StatelessWidget {
  final String date;
  final bool isDark;

  const _DateCell({required this.date, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAsset(
          assetPath: Assets.icons.auditTrailIconDepartment.path,
          width: 14,
          height: 14,
          color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondary,
        ),
        Gap(4.w),
        Flexible(
          child: Text(
            date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 14.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  final bool isDark;
  final bool bold;

  const _BodyText({required this.text, required this.isDark, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodySmall?.copyWith(
        fontSize: 14.sp,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }
}

class _ChangeCell extends StatelessWidget {
  final String amount;
  final String percent;
  final bool isIncrease;
  final bool isDecrease;

  const _ChangeCell({required this.amount, required this.percent, required this.isIncrease, required this.isDecrease});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          amount,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 14.sp,
            height: 1.45,
            fontWeight: FontWeight.w600,
            color: isIncrease ? AppColors.success : (isDecrease ? AppColors.errorBorderDark : AppColors.primary),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          percent,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            height: 1.35,
            color: isIncrease ? AppColors.success : (isDecrease ? AppColors.errorBorderDark : AppColors.primary),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({required this.row});

  final SalaryChangeHistoryTableRowData row;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => SalaryChangeHistoryDetailDialog.show(context, row: row),
        child: DigifyAsset(assetPath: Assets.icons.viewIconBlue.path, width: 20, height: 20, color: AppColors.primary),
      ),
    );
  }
}

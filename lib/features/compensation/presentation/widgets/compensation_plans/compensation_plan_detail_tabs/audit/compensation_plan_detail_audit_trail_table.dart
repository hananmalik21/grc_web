import 'dart:math' as math;
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'compensation_plan_detail_audit_trail_data.dart';
import 'compensation_plan_detail_audit_trail_table_config.dart';

class CompensationPlanDetailAuditTrailTable extends StatefulWidget {
  final List<AuditTrailRowData> rows;

  const CompensationPlanDetailAuditTrailTable({super.key, required this.rows});

  @override
  State<CompensationPlanDetailAuditTrailTable> createState() => _CompensationPlanDetailAuditTrailTableState();
}

class _CompensationPlanDetailAuditTrailTableState extends State<CompensationPlanDetailAuditTrailTable> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    final totalItems = widget.rows.length;
    final pageSize = CompensationPlanDetailAuditTrailData.pageSize;
    final totalPages = totalItems == 0 ? 1 : (totalItems / pageSize).ceil();
    final safePage = _currentPage.clamp(1, totalPages);
    final start = (safePage - 1) * pageSize;
    final end = math.min(start + pageSize, totalItems);
    final pagedRows = widget.rows.sublist(start, end);

    final hasPrevious = safePage > 1;
    final hasNext = safePage < totalPages;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final baseWidth = CompensationPlanDetailAuditTrailTableConfig.baseWidth;
                final widthMultiplier = availableWidth > baseWidth ? availableWidth / baseWidth : 1.0;
                final totalWidth = baseWidth * widthMultiplier;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _AuditTrailHeaderRow(borderColor: borderColor, widthMultiplier: widthMultiplier),
                            for (final row in pagedRows)
                              _AuditTrailDataRow(row: row, borderColor: borderColor, widthMultiplier: widthMultiplier),
                          ],
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Row(
                              children: [
                                _ColumnDivider(
                                  width: CompensationPlanDetailAuditTrailTableConfig.dateTimeWidth * widthMultiplier,
                                  borderColor: borderColor,
                                ),
                                _ColumnDivider(
                                  width: CompensationPlanDetailAuditTrailTableConfig.userWidth * widthMultiplier,
                                  borderColor: borderColor,
                                ),
                                _ColumnDivider(
                                  width: CompensationPlanDetailAuditTrailTableConfig.actionWidth * widthMultiplier,
                                  borderColor: borderColor,
                                ),
                                _ColumnDivider(
                                  width: CompensationPlanDetailAuditTrailTableConfig.detailsWidth * widthMultiplier,
                                  borderColor: borderColor,
                                ),
                                _ColumnDivider(
                                  width: CompensationPlanDetailAuditTrailTableConfig.ipAddressWidth * widthMultiplier,
                                  borderColor: borderColor,
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            PaginationControls(
              currentPage: safePage,
              totalPages: totalPages,
              totalItems: totalItems,
              pageSize: pageSize,
              hasNext: hasNext,
              hasPrevious: hasPrevious,
              onPrevious: hasPrevious
                  ? () {
                      setState(() {
                        _currentPage = safePage - 1;
                      });
                    }
                  : null,
              onNext: hasNext
                  ? () {
                      setState(() {
                        _currentPage = safePage + 1;
                      });
                    }
                  : null,
              showBorder: true,
              style: PaginationStyle.simple,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CompensationPlanDetailAuditTrailTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    final pageSize = CompensationPlanDetailAuditTrailData.pageSize;
    final totalPages = widget.rows.isEmpty ? 1 : (widget.rows.length / pageSize).ceil();
    if (_currentPage > totalPages) {
      _currentPage = totalPages;
    }
  }
}

class _AuditTrailHeaderRow extends StatelessWidget {
  final Color borderColor;
  final double widthMultiplier;

  const _AuditTrailHeaderRow({required this.borderColor, required this.widthMultiplier});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          _HeaderCell(
            text: CompensationPlanDetailAuditTrailData.dateTimeHeader,
            width: CompensationPlanDetailAuditTrailTableConfig.dateTimeWidth * widthMultiplier,
          ),
          _HeaderCell(
            text: CompensationPlanDetailAuditTrailData.userHeader,
            width: CompensationPlanDetailAuditTrailTableConfig.userWidth * widthMultiplier,
          ),
          _HeaderCell(
            text: CompensationPlanDetailAuditTrailData.actionHeader,
            width: CompensationPlanDetailAuditTrailTableConfig.actionWidth * widthMultiplier,
          ),
          _HeaderCell(
            text: CompensationPlanDetailAuditTrailData.detailsHeader,
            width: CompensationPlanDetailAuditTrailTableConfig.detailsWidth * widthMultiplier,
          ),
          _HeaderCell(
            text: CompensationPlanDetailAuditTrailData.ipAddressHeader,
            width: CompensationPlanDetailAuditTrailTableConfig.ipAddressWidth * widthMultiplier,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;
  final bool isLast;

  const _HeaderCell({required this.text, required this.width, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 14.h),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
        ),
      ),
    );
  }
}

class _AuditTrailDataRow extends StatelessWidget {
  final AuditTrailRowData row;
  final Color borderColor;
  final double widthMultiplier;

  const _AuditTrailDataRow({required this.row, required this.borderColor, required this.widthMultiplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          _TableCell(
            text: row.dateTime,
            width: CompensationPlanDetailAuditTrailTableConfig.dateTimeWidth * widthMultiplier,
          ),
          _TableCell(text: row.user, width: CompensationPlanDetailAuditTrailTableConfig.userWidth * widthMultiplier),
          _ActionCell(
            text: row.action,
            width: CompensationPlanDetailAuditTrailTableConfig.actionWidth * widthMultiplier,
          ),
          _TableCell(
            text: row.details,
            width: CompensationPlanDetailAuditTrailTableConfig.detailsWidth * widthMultiplier,
          ),
          _TableCell(
            text: row.ipAddress,
            width: CompensationPlanDetailAuditTrailTableConfig.ipAddressWidth * widthMultiplier,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final double width;
  final bool isLast;

  const _TableCell({required this.text, required this.width, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 18.h),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _ActionCell extends StatelessWidget {
  final String text;
  final double width;

  const _ActionCell({required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 18.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DigifyCapsule(
            label: text,
            textColor: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }
}

class _ColumnDivider extends StatelessWidget {
  final double width;
  final Color borderColor;
  final bool isLast;

  const _ColumnDivider({required this.width, required this.borderColor, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: borderColor, width: 1.w),
              ),
      ),
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_transaction_display.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_transaction_table_body.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_transaction_table_config.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsTransactionSection extends StatelessWidget {
  const LeaveDetailsTransactionSection({
    super.key,
    required this.transactions,
    required this.isDark,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = LeaveDetailsTransactionTableConfig.defaultPageSize,
    this.onPrevious,
    this.onNext,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<LeaveBalanceTransactionDisplay> transactions;
  final bool isDark;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LeaveDetailsTransactionTableHeader(isDark: isDark),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 250.h, maxHeight: 400.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: LeaveDetailsTransactionTableBody(
                transactions: transactions,
                isLoading: isLoading,
                errorMessage: errorMessage,
                isDark: isDark,
              ),
            ),
          ),
          if (paginationInfo != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: paginationInfo!,
              currentPage: currentPage,
              pageSize: pageSize,
              onPrevious: onPrevious,
              onNext: onNext,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }
}

class LeaveDetailsTransactionTableHeader extends StatelessWidget {
  const LeaveDetailsTransactionTableHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText;
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    return Container(
      color: headerColor,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: LeaveDetailsTransactionTableConfig.cellPaddingHorizontal.w,
        vertical: LeaveDetailsTransactionTableConfig.headerPaddingVertical.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.dateWidth.w,
            child: _HeaderCell(text: 'Date', color: textColor),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.typeWidth.w,
            child: _HeaderCell(text: 'Type', color: textColor),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          Expanded(
            child: _HeaderCell(text: 'Description', color: textColor),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.amountWidth.w,
            child: _HeaderCell(text: 'Amount', color: textColor, alignment: Alignment.center),
          ),
          Gap(LeaveDetailsTransactionTableConfig.columnGap.w),
          SizedBox(
            width: LeaveDetailsTransactionTableConfig.balanceWidth.w,
            child: _HeaderCell(text: 'Balance', color: textColor, alignment: Alignment.center),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.text, required this.color, this.alignment = Alignment.centerLeft});

  final String text;
  final Color color;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

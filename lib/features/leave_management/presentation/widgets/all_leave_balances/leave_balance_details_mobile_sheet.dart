import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/number_format_utils.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_details_data_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_badge.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_leave_type_selector.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_top_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveBalanceDetailsMobileSheet {
  LeaveBalanceDetailsMobileSheet._();

  static Future<void> show(BuildContext context, {required LeaveBalanceSummaryItem item}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Leave Balance Details',
      child: _DetailsSheetBody(item: item),
    );
  }
}

class _DetailsSheetBody extends ConsumerStatefulWidget {
  const _DetailsSheetBody({required this.item});

  final LeaveBalanceSummaryItem item;

  @override
  ConsumerState<_DetailsSheetBody> createState() => _DetailsSheetBodyState();
}

class _DetailsSheetBodyState extends ConsumerState<_DetailsSheetBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(leaveDetailsDataProvider(widget.item.employeeGuid));
      ref.invalidate(leaveDetailsTransactionsResultProvider(widget.item.employeeGuid));
      ref.invalidate(leaveDetailsSelectedLeaveTypeIdProvider(widget.item.employeeGuid));
      ref.invalidate(leaveDetailsTransactionsPaginationProvider(widget.item.employeeGuid));
      ref.read(leaveTypesNotifierProvider.notifier).loadLeaveTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final asyncBalances = ref.watch(employeeLeaveBalancesProvider(widget.item.employeeGuid));
    final leaveTypesState = ref.watch(leaveTypesNotifierProvider);
    final selectedId = ref.watch(leaveDetailsSelectedLeaveTypeIdProvider(widget.item.employeeGuid));
    final effectiveId = selectedId ?? leaveTypesState.leaveTypes.firstOrNull?.id;
    final transactionPage = ref.watch(leaveDetailsTransactionPageProvider(widget.item.employeeGuid));

    final isLoading = asyncBalances.isLoading || leaveTypesState.isLoading;

    final balance = asyncBalances.value?.where((b) => b.leaveTypeId == effectiveId).firstOrNull;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Employee top row ──────────────────────────────────────
                _EmployeeTopRow(item: widget.item, isDark: isDark),
                Gap(12.h),

                // ── Current balance badges ────────────────────────────────
                _CurrentBalancesCard(item: widget.item, isDark: isDark),
                Gap(12.h),

                // ── Leave type selector ───────────────────────────────────
                _SectionLabel(label: 'Leave Type', isDark: isDark),
                Gap(8.h),
                Skeletonizer(
                  enabled: isLoading,
                  child: LeaveDetailsLeaveTypeSelector(
                    leaveTypes: leaveTypesState.leaveTypes,
                    selectedLeaveTypeId: effectiveId,
                    onTypeChanged: (type) {
                      ref.read(leaveDetailsSelectedLeaveTypeIdProvider(widget.item.employeeGuid).notifier).state =
                          type.id;
                    },
                    isDark: isDark,
                    isLoading: leaveTypesState.isLoading,
                  ),
                ),
                Gap(12.h),

                // ── Per-type accrual stats ────────────────────────────────
                _SectionLabel(label: 'Balance Summary', isDark: isDark),
                Gap(8.h),
                Skeletonizer(
                  enabled: isLoading,
                  child: _BalanceStatsGrid(balance: balance, isDark: isDark),
                ),
                Gap(12.h),

                // ── Transaction history ───────────────────────────────────
                _SectionLabel(label: 'Transaction History', isDark: isDark),
                Gap(8.h),
                _TransactionList(
                  transactionPage: transactionPage,
                  isDark: isDark,
                  employeeGuid: widget.item.employeeGuid,
                ),
              ],
            ),
          ),
        ),
        const DigifyDivider.horizontal(),
        _CloseFooter(),
      ],
    );
  }
}

// ── Employee top row ────────────────────────────────────────────────────────

class _EmployeeTopRow extends StatelessWidget {
  const _EmployeeTopRow({required this.item, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final bool isDark;

  String _yearsOfService() {
    if (item.joinDate == null) return '-';
    final years = DateTime.now().difference(item.joinDate!).inDays / 365.25;
    return '${years.toStringAsFixed(1)} yrs';
  }

  @override
  Widget build(BuildContext context) {
    final joinStr = item.joinDate != null ? DateFormat('MMM d, yyyy').format(item.joinDate!) : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.employeeName.trim().isEmpty ? '-' : item.employeeName,
          style: context.textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(2.h),
        Text(
          item.employeeNumber.isEmpty ? '-' : item.employeeNumber,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontSize: 11.sp,
          ),
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: LeaveDetailsTopCard(label: 'Join Date', value: joinStr, isDark: isDark),
            ),
            Gap(10.w),
            Expanded(
              child: LeaveDetailsTopCard(label: 'Years of Service', value: _yearsOfService(), isDark: isDark),
            ),
          ],
        ),
        Gap(8.h),
        SizedBox(
          width: double.infinity,
          child: LeaveDetailsTopCard(
            label: 'Department',
            value: item.department.isEmpty ? '-' : item.department,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

// ── Current balance badges ──────────────────────────────────────────────────

class _CurrentBalancesCard extends StatelessWidget {
  const _CurrentBalancesCard({required this.item, required this.isDark});

  final LeaveBalanceSummaryItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balances',
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _BadgeTile(
                  label: 'Annual Leave',
                  badge: LeaveBalanceBadge(
                    text: '${NumberFormatUtils.formatDays(item.annualLeave)} days',
                    type: LeaveBadgeType.annualLeave,
                  ),
                  isDark: isDark,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _BadgeTile(
                  label: 'Sick Leave',
                  badge: LeaveBalanceBadge(
                    text: '${NumberFormatUtils.formatDays(item.sickLeave)} days',
                    type: LeaveBadgeType.sickLeave,
                  ),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _BadgeTile(
                  label: 'Unpaid Leave',
                  badge: const LeaveBalanceBadge(text: '0 days', type: LeaveBadgeType.unpaidLeave),
                  isDark: isDark,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _BadgeTile(
                  label: 'Total Available',
                  badge: LeaveBalanceBadge(
                    text: '${NumberFormatUtils.formatDays(item.totalAvailable)} days',
                    type: LeaveBadgeType.totalAvailable,
                  ),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Per-type accrual stats 2x2 grid ────────────────────────────────────────

class _BalanceStatsGrid extends StatelessWidget {
  const _BalanceStatsGrid({required this.balance, required this.isDark});

  final dynamic balance;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    final accrued = balance?.accruedDays ?? 0.0;
    final consumed = balance?.takenDays ?? 0.0;
    final current = balance?.availableDays ?? 0.0;
    final opening = balance?.openingBalanceDays ?? 0.0;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Total Accrued',
                  value: '${NumberFormatUtils.formatDays(accrued)} days',
                  labelColor: labelColor,
                  valueColor: valueColor,
                  context: context,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _StatTile(
                  label: 'Total Consumed',
                  value: '${NumberFormatUtils.formatDays(consumed)} days',
                  labelColor: labelColor,
                  valueColor: valueColor,
                  context: context,
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Current Balance',
                  value: '${NumberFormatUtils.formatDays(current)} days',
                  labelColor: labelColor,
                  valueColor: AppColors.primary,
                  context: context,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _StatTile(
                  label: 'Opening Balance',
                  value: '${NumberFormatUtils.formatDays(opening)} days',
                  labelColor: labelColor,
                  valueColor: valueColor,
                  context: context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    required this.context,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ctx.textTheme.bodySmall?.copyWith(color: labelColor, fontSize: 10.sp),
        ),
        Gap(3.h),
        Text(
          value,
          style: ctx.textTheme.titleSmall?.copyWith(color: valueColor, fontWeight: FontWeight.w600, fontSize: 13.sp),
        ),
      ],
    );
  }
}

// ── Transaction history list ────────────────────────────────────────────────

class _TransactionList extends ConsumerWidget {
  const _TransactionList({required this.transactionPage, required this.isDark, required this.employeeGuid});

  final LeaveDetailsTransactionPageState transactionPage;
  final bool isDark;
  final String employeeGuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardBg = isDark ? AppColors.cardBackgroundDark : Colors.white;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    if (transactionPage.isLoading && transactionPage.transactions.isEmpty) {
      return const Center(child: AppLoadingIndicator(type: LoadingType.circle));
    }

    if (transactionPage.errorMessage != null && transactionPage.errorMessage!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          'Failed to load transactions',
          style: TextStyle(color: AppColors.error, fontSize: 12.sp),
        ),
      );
    }

    if (transactionPage.transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          'No transactions found',
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      );
    }

    return Skeletonizer(
      enabled: transactionPage.isLoading,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionPage.transactions.length,
              separatorBuilder: (_, _) => const DigifyDivider.horizontal(),
              itemBuilder: (context, index) =>
                  _TransactionCard(transaction: transactionPage.transactions[index], isDark: isDark),
            ),
          ),
          if (transactionPage.paginationInfo != null) ...[
            Gap(10.h),
            PaginationControls.fromPaginationInfo(
              paginationInfo: transactionPage.paginationInfo!,
              currentPage: transactionPage.currentPage,
              pageSize: transactionPage.pageSize,
              onPrevious: transactionPage.movePrevious,
              onNext: transactionPage.moveNext,
              isLoading: false,
              style: PaginationStyle.simple,
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction, required this.isDark});

  final dynamic transaction;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final mutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final isPositive = (transaction.amount as double) >= 0;
    final amountColor = isPositive ? AppColors.activeStatusTextLight : AppColors.error;
    final amountText = isPositive
        ? '+${(transaction.amount as double).toStringAsFixed(1)} days'
        : '${(transaction.amount as double).toStringAsFixed(1)} days';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('MMM d, yyyy').format(transaction.date as DateTime),
                  style: context.textTheme.bodySmall?.copyWith(color: mutedColor, fontSize: 11.sp),
                ),
              ),
              DigifyCapsule(label: transaction.type as String),
            ],
          ),
          Gap(4.h),
          Text(
            (transaction.description as String).isEmpty ? '-' : transaction.description as String,
            style: context.textTheme.bodySmall?.copyWith(color: textColor, fontSize: 12.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount: $amountText',
                style: context.textTheme.labelSmall?.copyWith(color: amountColor, fontWeight: FontWeight.w600),
              ),
              Text(
                'Balance: ${(transaction.balance as double).toStringAsFixed(1)} days',
                style: context.textTheme.labelSmall?.copyWith(color: mutedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textTheme.titleSmall?.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.label, required this.badge, required this.isDark});

  final String label;
  final Widget badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontSize: 11.sp,
          ),
        ),
        Gap(4.h),
        badge,
      ],
    );
  }
}

class _CloseFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
      child: SizedBox(
        width: double.infinity,
        child: AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop(), height: 46),
      ),
    );
  }
}

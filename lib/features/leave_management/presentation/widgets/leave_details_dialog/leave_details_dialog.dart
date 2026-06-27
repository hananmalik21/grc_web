import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balances_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_details_data_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'leave_details_dialog_styles.dart';
import 'leave_details_employee_section.dart';
import 'leave_details_leave_type_selector.dart';
import 'leave_details_summary_section.dart';
import 'leave_details_transaction_section.dart';

class LeaveDetailsDialog extends ConsumerStatefulWidget {
  const LeaveDetailsDialog({super.key, required this.item});

  final LeaveBalanceSummaryItem item;

  static Future<void> show(BuildContext context, {required LeaveBalanceSummaryItem item}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LeaveDetailsDialog(item: item),
    );
  }

  @override
  ConsumerState<LeaveDetailsDialog> createState() => _LeaveDetailsDialogState();
}

class _LeaveDetailsDialogState extends ConsumerState<LeaveDetailsDialog> {
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
    final isDark = context.theme.brightness == Brightness.dark;
    final asyncData = ref.watch(leaveDetailsDataProvider(widget.item.employeeGuid));
    final asyncBalances = ref.watch(employeeLeaveBalancesProvider(widget.item.employeeGuid));
    final leaveTypesState = ref.watch(leaveTypesNotifierProvider);

    final isLoading = asyncData.isLoading || asyncBalances.isLoading || leaveTypesState.isLoading;

    return AppDialog(
      title: 'Leave Balance Details',
      subtitle: '${widget.item.employeeName} • ${widget.item.employeeNumber}',
      width: 896.w,
      content: isLoading
          ? _buildSkeleton(isDark)
          : asyncData.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: Text(
                    'Failed to load details',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              data: (data) {
                final balances = asyncBalances.value ?? [];
                final selectedId = ref.watch(leaveDetailsSelectedLeaveTypeIdProvider(widget.item.employeeGuid));
                final selectedNotifier = ref.read(
                  leaveDetailsSelectedLeaveTypeIdProvider(widget.item.employeeGuid).notifier,
                );
                final leaveTypes = leaveTypesState.leaveTypes;
                final effectiveId = selectedId ?? leaveTypes.firstOrNull?.id;

                final balance = balances.where((b) => b.leaveTypeId == effectiveId).firstOrNull;
                final summary = {
                  'totalAccrued': balance?.accruedDays ?? 0.0,
                  'totalConsumed': balance?.takenDays ?? 0.0,
                  'currentBalance': balance?.availableDays ?? 0.0,
                  'entitlement': '30 days',
                };

                final transactionPage = ref.watch(leaveDetailsTransactionPageProvider(widget.item.employeeGuid));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LeaveDetailsEmployeeSection(item: widget.item, isDark: isDark),
                    Gap(leaveDetailsSectionGap.h),
                    LeaveDetailsLeaveTypeSelector(
                      leaveTypes: leaveTypes,
                      selectedLeaveTypeId: effectiveId,
                      onTypeChanged: (apiType) => selectedNotifier.state = apiType.id,
                      isDark: isDark,
                      isLoading: leaveTypesState.isLoading,
                    ),
                    Gap(leaveDetailsSectionGap.h),
                    LeaveDetailsSummarySection(summary: summary, isDark: isDark),
                    Gap(leaveDetailsSectionGap.h),
                    LeaveDetailsTransactionSection(
                      transactions: transactionPage.transactions,
                      isDark: isDark,
                      paginationInfo: transactionPage.paginationInfo,
                      currentPage: transactionPage.currentPage,
                      pageSize: transactionPage.pageSize,
                      onPrevious: transactionPage.movePrevious,
                      onNext: transactionPage.moveNext,
                      isLoading: transactionPage.isLoading,
                      errorMessage: transactionPage.errorMessage,
                    ),
                  ],
                );
              },
            ),
      actions: [
        Text(
          'Last updated: ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        AppButton(label: 'Close', type: AppButtonType.outline, onPressed: () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Export Report',
          type: AppButtonType.primary,
          onPressed: () {},
          svgPath: Assets.icons.downloadIcon.path,
        ),
      ],
    );
  }

  Widget _buildSkeleton(bool isDark) {
    final mockItem = LeaveBalanceSummaryItem(
      employeeId: 0,
      employeeGuid: '',
      employeeName: 'Employee Name',
      employeeNumber: '12345',
      joinDate: DateTime(2020),
      department: 'Department',
      annualLeave: 0,
      sickLeave: 0,
      totalAvailable: 0,
    );

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LeaveDetailsEmployeeSection(item: mockItem, isDark: isDark),
          Gap(leaveDetailsSectionGap.h),
          LeaveDetailsLeaveTypeSelector(
            leaveTypes: const [],
            selectedLeaveTypeId: null,
            onTypeChanged: (_) {},
            isDark: isDark,
            isLoading: true,
          ),
          Gap(leaveDetailsSectionGap.h),
          const LeaveDetailsSummarySection(
            summary: {'totalAccrued': 0, 'totalConsumed': 0, 'currentBalance': 0, 'entitlement': '30 days'},
            isDark: false,
          ),
          Gap(leaveDetailsSectionGap.h),
          const LeaveDetailsTransactionSection(transactions: [], isDark: false, isLoading: true),
        ],
      ),
    );
  }
}

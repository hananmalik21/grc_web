import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/providers/employee_leave_history_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_content.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_balance_cards.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_loading.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveRequestEmployeeDetailScreen extends ConsumerWidget {
  const LeaveRequestEmployeeDetailScreen({super.key, required this.employeeGuid});

  final String employeeGuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final listState = ref.watch(employeeLeaveHistoryNotifierProvider(employeeGuid));
    final notifier = ref.read(employeeLeaveHistoryNotifierProvider(employeeGuid).notifier);

    final isInitialLoading = listState.isLoading && listState.items.isEmpty;

    if (isInitialLoading) {
      return Container(
        color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
        alignment: Alignment.center,
        child: LeaveRequestEmployeeDetailLoading(isDark: isDark, localizations: localizations),
      );
    }

    final employeeName = listState.items.isNotEmpty ? listState.items.first.employeeName : '—';

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: LeaveRequestEmployeeDetailHeader(
                employeeName: employeeName,
                employeeGuid: employeeGuid,
                isDark: isDark,
                localizations: localizations,
                onExport: () {},
                onAddLeaveRequest: () => NewLeaveRequestDialog.show(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: LeaveRequestEmployeeDetailBalanceCards(isDark: isDark, localizations: localizations),
            ),
            Gap(24.h),
            LeaveRequestEmployeeDetailContent(
              listState: listState,
              isDark: isDark,
              localizations: localizations,
              onRefresh: () => notifier.refresh(),
              onPrevious: listState.pagination != null && listState.pagination!.hasPrevious
                  ? () => notifier.goToPage(listState.currentPage - 1)
                  : null,
              onNext: listState.pagination != null && listState.pagination!.hasNext
                  ? () => notifier.goToPage(listState.currentPage + 1)
                  : null,
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}

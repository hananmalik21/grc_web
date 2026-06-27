import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/leave_management/presentation/providers/employee_leave_history_state.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_empty.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_error.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_loading.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestEmployeeDetailContent extends StatelessWidget {
  const LeaveRequestEmployeeDetailContent({
    super.key,
    required this.listState,
    required this.isDark,
    required this.localizations,
    this.onRefresh,
    this.onPrevious,
    this.onNext,
  });

  final EmployeeLeaveHistoryState listState;
  final bool isDark;
  final AppLocalizations localizations;
  final VoidCallback? onRefresh;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: _buildBody(),
          ),
          if (listState.pagination != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: listState.pagination!,
              currentPage: listState.currentPage,
              pageSize: listState.pageSize,
              onPrevious: onPrevious,
              onNext: onNext,
              isLoading: listState.isLoading,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (listState.error != null) {
      return LeaveRequestEmployeeDetailError(error: listState.error!);
    }
    if (listState.items.isEmpty && !listState.isLoading) {
      return LeaveRequestEmployeeDetailEmpty(localizations: localizations);
    }
    if (listState.items.isEmpty && listState.isLoading) {
      return LeaveRequestEmployeeDetailLoading(isDark: isDark, localizations: localizations);
    }
    return LeaveRequestEmployeeDetailTable(
      requests: listState.items,
      employeeGuid: listState.employeeGuid,
      page: listState.currentPage,
      pageSize: listState.pageSize,
      isDark: isDark,
      localizations: localizations,
      onRefresh: onRefresh,
    );
  }
}

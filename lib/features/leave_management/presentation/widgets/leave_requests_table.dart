import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/widgets/mock/mock_leave_request.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_table_width_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_actions_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:grc/features/leave_management/presentation/mixins/leave_requests_list_logic_mixin.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_requests_table/leave_request_details_dialog.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_requests_table/leave_requests_table_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_requests_table/leave_requests_table_row.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveRequestsTable extends ConsumerWidget with LeaveRequestsListLogicMixin {
  const LeaveRequestsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final requestsAsync = ref.watch(leaveRequestsProvider);
    final filter = ref.watch(leaveFilterProvider);
    final pagination = ref.watch(leaveRequestsPaginationProvider);
    final notifierState = ref.watch(leaveRequestsNotifierProvider);
    final widths = ref.watch(leaveRequestsTableWidthsProvider);

    return Container(
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
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeaveRequestsTableHeader(isDark: isDark, localizations: localizations),
                  requestsAsync.when(
                    data: (paginatedResponse) {
                      final filtered = getFilteredRequests(paginatedResponse, filter);
                      if (filtered.isEmpty) {
                        return _buildEmptyState(localizations);
                      }
                      final approveLoading = ref.watch(leaveRequestsApproveLoadingProvider);
                      final rejectLoading = ref.watch(leaveRequestsRejectLoadingProvider);
                      final deleteLoading = ref.watch(leaveRequestsDeleteLoadingProvider);
                      return Column(
                        children: filtered
                            .map(
                              (request) => LeaveRequestsTableRow(
                                request: request,
                                localizations: localizations,
                                isDark: isDark,
                                isApproveLoading: approveLoading.contains(request.guid),
                                isRejectLoading: rejectLoading.contains(request.guid),
                                isDeleteLoading: deleteLoading.contains(request.guid),
                                onView: () {
                                  LeaveRequestDetailsDialog.show(
                                    context,
                                    request: request,
                                    department: request.department,
                                    position: request.position,
                                    onApprove: request.status == RequestStatus.pending
                                        ? () => LeaveRequestsActions.approveLeaveRequest(
                                            context,
                                            ref,
                                            request,
                                            localizations,
                                          )
                                        : null,
                                    onReject: request.status == RequestStatus.pending
                                        ? () => LeaveRequestsActions.rejectLeaveRequest(
                                            context,
                                            ref,
                                            request,
                                            localizations,
                                          )
                                        : null,
                                  );
                                },
                                onViewEmployeeHistory: request.employeeGuid != null
                                    ? () => context.push(
                                        AppRoutes.leaveManagementEmployeeLeaveHistory,
                                        extra: request.employeeGuid,
                                      )
                                    : null,
                                onApprove: () =>
                                    LeaveRequestsActions.approveLeaveRequest(context, ref, request, localizations),
                                onReject: () =>
                                    LeaveRequestsActions.rejectLeaveRequest(context, ref, request, localizations),
                                onDelete: () =>
                                    LeaveRequestsActions.deleteLeaveRequest(context, ref, request, localizations),
                                onUpdate: () =>
                                    LeaveRequestsActions.updateLeaveRequest(context, ref, request, localizations),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () => _buildSkeletonLoadingRows(widths, isDark, localizations),
                    error: (error, stack) => _buildErrorState(localizations, error.toString()),
                  ),
                ],
              ),
            ),
          ),
          if (notifierState.data != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: notifierState.data!.pagination,
              currentPage: pagination.page,
              pageSize: pagination.pageSize,
              onPrevious: notifierState.data!.pagination.hasPrevious
                  ? () {
                      ref.read(leaveRequestsPaginationProvider.notifier).state = (
                        page: pagination.page - 1,
                        pageSize: pagination.pageSize,
                      );
                    }
                  : null,
              onNext: notifierState.data!.pagination.hasNext
                  ? () {
                      ref.read(leaveRequestsPaginationProvider.notifier).state = (
                        page: pagination.page + 1,
                        pageSize: pagination.pageSize,
                      );
                    }
                  : null,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return SizedBox(
      width: 1200.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            localizations.noResultsFound,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoadingRows(LeaveRequestsTableColumnWidths widths, bool isDark, AppLocalizations localizations) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          5,
          (index) => LeaveRequestsTableRow(
            request: MockLeaveRequest.create(),
            localizations: localizations,
            isDark: isDark,
            isApproveLoading: false,
            isRejectLoading: false,
            isDeleteLoading: false,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations localizations, String error) {
    return SizedBox(
      width: 1200.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            'Error: $error',
            style: TextStyle(fontSize: 16.sp, color: AppColors.error),
          ),
        ),
      ),
    );
  }
}

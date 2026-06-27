import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/leave_management/presentation/widgets/loading/leave_requests_skeleton_loader.dart';
import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_actions_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_details_mobile_sheet.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_form_mobile_sheet.dart';
import 'package:grc/features/leave_management/presentation/mixins/leave_requests_list_logic_mixin.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LeaveRequestsMobileList extends ConsumerWidget with LeaveRequestsListLogicMixin {
  const LeaveRequestsMobileList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final notifierState = ref.watch(leaveRequestsNotifierProvider);
    final pagination = ref.watch(leaveRequestsPaginationProvider);
    final filter = ref.watch(leaveFilterProvider);

    final approveLoading = ref.watch(leaveRequestsApproveLoadingProvider);
    final rejectLoading = ref.watch(leaveRequestsRejectLoadingProvider);
    final deleteLoading = ref.watch(leaveRequestsDeleteLoadingProvider);

    if (notifierState.isLoading) {
      return LeaveRequestsSkeletonLoader(isDark: isDark);
    }

    if (notifierState.error != null && notifierState.data == null) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        iconBackground: AppColors.errorBg,
        iconPath: Assets.icons.warningIcon.path,
        iconColor: AppColors.error,
        title: 'Unable to Load Requests',
        subtitle: notifierState.error!,
      );
    }

    final data = notifierState.data;
    if (data == null) return LeaveRequestsSkeletonLoader(isDark: isDark);

    final requests = getFilteredRequests(data, filter);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (requests.isEmpty)
          MobileStateCard(
            isDark: isDark,
            borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            iconBackground: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
            iconPath: Assets.icons.leaveManagement.emptyLeave.path,
            title: localizations.noResultsFound,
            subtitle: 'No leave requests match the current filter',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            separatorBuilder: (_, _) => Gap(10.h),
            itemBuilder: (context, index) {
              final request = requests[index];
              return LeaveRequestCard(
                request: request,
                localizations: localizations,
                isDark: isDark,
                isApproveLoading: approveLoading.contains(request.guid),
                isRejectLoading: rejectLoading.contains(request.guid),
                isDeleteLoading: deleteLoading.contains(request.guid),
                onView: () => LeaveRequestDetailsMobileSheet.show(
                  context,
                  request: request,
                  department: request.department,
                  position: request.position,
                  onApprove: request.status == RequestStatus.pending
                      ? () => LeaveRequestsActions.approveLeaveRequest(context, ref, request, localizations)
                      : null,
                  onReject: request.status == RequestStatus.pending
                      ? () => LeaveRequestsActions.rejectLeaveRequest(context, ref, request, localizations)
                      : null,
                ),
                onViewEmployeeHistory: request.employeeGuid != null
                    ? () => context.push(AppRoutes.leaveManagementEmployeeLeaveHistory, extra: request.employeeGuid)
                    : null,
                onApprove: () => LeaveRequestsActions.approveLeaveRequest(context, ref, request, localizations),
                onReject: () => LeaveRequestsActions.rejectLeaveRequest(context, ref, request, localizations),
                onDelete: () => LeaveRequestsActions.deleteLeaveRequest(context, ref, request, localizations),
                onUpdate: () => EditLeaveRequestMobileSheet.show(context, ref, request),
              );
            },
          ),
        if (data.pagination.totalPages > 0) ...[
          Gap(12.h),
          PaginationControls.fromPaginationInfo(
            paginationInfo: data.pagination,
            currentPage: pagination.page,
            pageSize: pagination.pageSize,
            onPrevious: data.pagination.hasPrevious
                ? () {
                    ref.read(leaveRequestsPaginationProvider.notifier).state = (
                      page: pagination.page - 1,
                      pageSize: pagination.pageSize,
                    );
                  }
                : null,
            onNext: data.pagination.hasNext
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
      ],
    );
  }
}

class LeaveRequestCard extends StatelessWidget with LeaveRequestPermissionMixin, LeaveRequestsListLogicMixin {
  const LeaveRequestCard({
    super.key,
    required this.request,
    required this.localizations,
    required this.isDark,
    required this.isApproveLoading,
    required this.isRejectLoading,
    required this.isDeleteLoading,
    this.onView,
    this.onViewEmployeeHistory,
    this.onApprove,
    this.onReject,
    this.onDelete,
    this.onUpdate,
  });

  final TimeOffRequest request;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isApproveLoading;
  final bool isRejectLoading;
  final bool isDeleteLoading;
  final VoidCallback? onView;
  final VoidCallback? onViewEmployeeHistory;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(request: request, localizations: localizations, isDark: isDark, onView: onView),
          const DigifyDivider(),
          _CardBody(request: request, isDark: isDark),
          const DigifyDivider(),
          _CardActions(
            request: request,
            isDark: isDark,
            isApproveLoading: isApproveLoading,
            isRejectLoading: isRejectLoading,
            isDeleteLoading: isDeleteLoading,
            onView: onView,
            onViewEmployeeHistory: onViewEmployeeHistory,
            onApprove: onApprove,
            onReject: onReject,
            onDelete: onDelete,
            onUpdate: onUpdate,
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.request, required this.localizations, required this.isDark, this.onView});

  final TimeOffRequest request;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onView,
                  child: Text(
                    request.employeeName.isEmpty ? '-' : request.employeeName,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gap(2.h),
                Text(
                  '#${request.id}  ·  EMP${request.employeeId.toString().padLeft(3, '0')}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Gap(8.w),
          _StatusBadge(request: request),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget with LeaveRequestsListLogicMixin {
  const _StatusBadge({required this.request});

  final TimeOffRequest request;

  @override
  Widget build(BuildContext context) {
    return DigifyStatusCapsule(status: getStatusLabel(request.status));
  }
}

class _CardBody extends StatelessWidget with LeaveRequestsListLogicMixin {
  const _CardBody({required this.request, required this.isDark});

  final TimeOffRequest request;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final labelStyle = context.textTheme.bodySmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      fontSize: 11.sp,
    );
    final valueStyle = context.textTheme.bodyMedium?.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Leave Type',
                  labelStyle: labelStyle,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      request.leaveTypeInfo?.leaveNameEn ?? LeaveTypeMapper.getShortLabel(request.type),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.lightDark,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _InfoTile(
                  label: 'Days',
                  labelStyle: labelStyle,
                  child: Text(formatTotalDays(request.totalDays), style: valueStyle),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Start Date',
                  labelStyle: labelStyle,
                  child: Text(dateFormat.format(request.startDate), style: valueStyle),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _InfoTile(
                  label: 'End Date',
                  labelStyle: labelStyle,
                  child: Text(dateFormat.format(request.endDate), style: valueStyle),
                ),
              ),
            ],
          ),
          if (request.reason.isNotEmpty) ...[
            Gap(10.h),
            _InfoTile(
              label: 'Reason',
              labelStyle: labelStyle,
              child: Text(request.reason, style: valueStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
          if (request.department != null || request.position != null) ...[
            Gap(10.h),
            Row(
              children: [
                if (request.department != null)
                  Expanded(
                    child: _InfoTile(
                      label: 'Department',
                      labelStyle: labelStyle,
                      child: Text(request.department!, style: valueStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                if (request.department != null && request.position != null) Gap(12.w),
                if (request.position != null)
                  Expanded(
                    child: _InfoTile(
                      label: 'Position',
                      labelStyle: labelStyle,
                      child: Text(request.position!, style: valueStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.labelStyle, required this.child});

  final String label;
  final TextStyle? labelStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Gap(3.h),
        child,
      ],
    );
  }
}

class _CardActions extends StatelessWidget with LeaveRequestPermissionMixin, LeaveRequestsListLogicMixin {
  const _CardActions({
    required this.request,
    required this.isDark,
    required this.isApproveLoading,
    required this.isRejectLoading,
    required this.isDeleteLoading,
    this.onView,
    this.onViewEmployeeHistory,
    this.onApprove,
    this.onReject,
    this.onDelete,
    this.onUpdate,
  });

  final TimeOffRequest request;
  final bool isDark;
  final bool isApproveLoading;
  final bool isRejectLoading;
  final bool isDeleteLoading;
  final VoidCallback? onView;
  final VoidCallback? onViewEmployeeHistory;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: _buildActions()),
    );
  }

  List<Widget> _buildActions() {
    final actions = <Widget>[];

    if (request.status == RequestStatus.pending) {
      if (canViewLeaveRequest) {
        actions.add(AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: onView));
      }
      if (canApproveLeaveRequest) {
        if (actions.isNotEmpty) actions.add(Gap(8.w));
        actions.add(
          AppMobileButton(
            svgPath: Assets.icons.checkIconGreen.path,
            backgroundColor: AppColors.success,
            onPressed: onApprove,
            isLoading: isApproveLoading,
          ),
        );
        actions.add(Gap(8.w));
        actions.add(
          AppMobileButton.danger(svgPath: Assets.icons.closeIcon.path, onPressed: onReject, isLoading: isRejectLoading),
        );
      }
    } else if (request.status == RequestStatus.draft) {
      if (canUpdateLeaveRequest) {
        actions.add(AppMobileButton.primary(svgPath: Assets.icons.editIconGreen.path, onPressed: onUpdate));
      }
      if (canDeleteLeaveRequest) {
        if (actions.isNotEmpty) actions.add(Gap(8.w));
        actions.add(
          AppMobileButton.danger(
            svgPath: Assets.icons.deleteIconRed.path,
            onPressed: onDelete,
            isLoading: isDeleteLoading,
          ),
        );
      }
    } else {
      if (canViewLeaveRequest) {
        actions.add(AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: onView));
      }
    }

    return actions;
  }
}

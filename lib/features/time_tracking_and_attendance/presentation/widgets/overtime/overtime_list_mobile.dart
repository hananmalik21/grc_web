import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_management.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_actions_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/overtime_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OvertimeListMobile extends ConsumerWidget {
  const OvertimeListMobile({super.key, required this.onEdit});

  final Function(OvertimeRecord)? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(overtimeManagementProvider);
    final notifier = ref.read(overtimeManagementProvider.notifier);
    final records = state.records ?? [];
    final isLoading = state.isLoading;

    if (!isLoading && records.isEmpty) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
        icon: Icon(
          Icons.inbox_outlined,
          size: 32.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        title: 'No Overtime Records Found',
        subtitle: 'No overtime requests match your current filters.',
      );
    }

    // skeletonRecords logic moved to OvertimeListSkeleton

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading && records.isEmpty)
            OvertimeListSkeleton(isDark: isDark, isLoading: isLoading)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              itemCount: records.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) => _OvertimeCard(
                record: records[index],
                isDark: isDark,
                state: state,
                onEdit: onEdit,
                onApprove: (r) => OvertimeActions.approveOvertimeRequest(context, ref, r),
                onReject: (r) => OvertimeActions.rejectOvertimeRequest(context, ref, r),
                onCancel: (r) => OvertimeActions.cancelDraftOvertimeRequest(context, ref, r),
              ),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: state.currentPage,
            totalPages: state.totalItems == 0 ? 1 : (state.totalItems / state.pageSize).ceil(),
            hasPrevious: state.currentPage > 1,
            hasNext: state.hasMore,
            onPrevious: state.currentPage > 1 && !isLoading ? () => notifier.goToPage(state.currentPage - 1) : null,
            onNext: state.hasMore && !isLoading ? () => notifier.goToPage(state.currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _OvertimeCard extends StatelessWidget with OvertimePermissionMixin {
  const _OvertimeCard({
    required this.record,
    required this.isDark,
    required this.state,
    required this.onEdit,
    required this.onApprove,
    required this.onReject,
    required this.onCancel,
  });

  final OvertimeRecord record;
  final bool isDark;
  final OvertimeManagement state;
  final Function(OvertimeRecord)? onEdit;
  final Function(OvertimeRecord) onApprove;
  final Function(OvertimeRecord) onReject;
  final Function(OvertimeRecord) onCancel;

  @override
  Widget build(BuildContext context) {
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final status = OvertimeStatus.fromString(record.approvalInformation?.status ?? '');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(fallbackInitial: record.employeeNameDisplay, size: 36.w),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.employeeNameDisplay.toUpperCase(),
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(2.h),
                    Text(
                      record.employeeIdDisplay,
                      style: context.textTheme.labelSmall?.copyWith(color: labelColor, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: status.name),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 10.h,
            children: [
              _InfoCell(label: 'Date', value: record.dateDisplay, labelColor: labelColor, isDark: isDark),
              _InfoCell(label: 'Type', value: record.typeDisplay, labelColor: labelColor, isDark: isDark),
              _InfoCell(
                label: 'OT Hours',
                value: '${record.overtimeHoursDisplay} hrs',
                labelColor: labelColor,
                isDark: isDark,
              ),
              _InfoCell(label: 'Rate', value: '${record.rateDisplay}x', labelColor: labelColor, isDark: isDark),
              _InfoCell(label: 'Amount', value: 'KWD ${record.amountDisplay}', labelColor: labelColor, isDark: isDark),
            ],
          ),
          if (_hasActions(status)) ...[
            Gap(12.h),
            const DigifyDivider.thin(),
            Gap(10.h),
            _ActionsRow(
              record: record,
              status: status,
              state: state,
              onEdit: onEdit,
              onApprove: onApprove,
              onReject: onReject,
              onCancel: onCancel,
            ),
          ],
        ],
      ),
    );
  }

  bool _hasActions(OvertimeStatus status) {
    if (status == OvertimeStatus.draft) return canUpdateOvertime || canApproveOvertime;
    if (status == OvertimeStatus.submitted || status == OvertimeStatus.pending) return canApproveOvertime;
    return false;
  }
}

class _ActionsRow extends StatelessWidget with OvertimePermissionMixin {
  const _ActionsRow({
    required this.record,
    required this.status,
    required this.state,
    required this.onEdit,
    required this.onApprove,
    required this.onReject,
    required this.onCancel,
  });

  final OvertimeRecord record;
  final OvertimeStatus status;
  final OvertimeManagement state;
  final Function(OvertimeRecord)? onEdit;
  final Function(OvertimeRecord) onApprove;
  final Function(OvertimeRecord) onReject;
  final Function(OvertimeRecord) onCancel;

  @override
  Widget build(BuildContext context) {
    final guid = record.otRequestGuid ?? '';

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: _buildActions(guid));
  }

  List<Widget> _buildActions(String guid) {
    if (status == OvertimeStatus.draft) {
      final isCanceling = state.cancelingOvertimeGuid == guid;
      return [
        if (canUpdateOvertime)
          AppMobileButton.primary(
            onPressed: isCanceling ? null : () => onEdit?.call(record),
            svgPath: Assets.icons.editIconGreen.path,
            isLoading: false,
          ),
        if (canApproveOvertime) ...[
          Gap(8.w),
          AppMobileButton.danger(
            onPressed: isCanceling ? null : () => onCancel(record),
            svgPath: Assets.icons.closeIcon.path,
            isLoading: isCanceling,
          ),
        ],
      ];
    }

    if (status == OvertimeStatus.submitted || status == OvertimeStatus.pending) {
      if (!canApproveOvertime) return [];
      final isApproving = state.approvingOvertimeGuid == guid;
      final isRejecting = state.rejectingOvertimeGuid == guid;
      return [
        AppMobileButton(
          onPressed: isApproving || isRejecting ? null : () => onApprove(record),
          isLoading: isApproving,
          svgPath: Assets.icons.checkIconGreen.path,
          backgroundColor: AppColors.success,
        ),
        Gap(8.w),
        AppMobileButton.danger(
          onPressed: isApproving || isRejecting ? null : () => onReject(record),
          isLoading: isRejecting,
          svgPath: Assets.icons.closeIcon.path,
        ),
      ];
    }

    return [];
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({required this.label, required this.value, required this.labelColor, required this.isDark});

  final String label;
  final String value;
  final Color labelColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.38.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: labelColor),
          ),
          Gap(2.h),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

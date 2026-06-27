import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_table_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/requisitions_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/requisitions_actions_confirmation_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/requisition_detail_page.dart';
import 'package:grc/core/enums/hiring_enums.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_priority_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/create_requisition_mobile_sheet.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_api_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RequisitionsListMobile extends ConsumerWidget {
  const RequisitionsListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isLoading = ref.watch(requisitionsTableIsLoadingProvider);
    final errorMessage = ref.watch(requisitionsTableErrorProvider);
    final liveRowsAsync = ref.watch(requisitionsTableRowsProvider);
    final liveRows = liveRowsAsync.valueOrNull ?? const [];
    final skeletonRows = ref.watch(requisitionsSkeletonRowsProvider);
    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;
    final currentPage = ref.watch(requisitionsCurrentPageProvider);
    final totalPages = ref.watch(requisitionsTotalPagesProvider);
    final hasNext = ref.watch(requisitionsHasNextProvider);
    final hasPrevious = ref.watch(requisitionsHasPreviousProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null && liveRows.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
                iconBackground: AppColors.errorBg,
                icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
                title: loc.hiringRequisitionsTableErrorTitle,
                subtitle: errorMessage,
                action: GestureDetector(
                  onTap: () => ref.invalidate(requisitionsPageProvider),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                    decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      loc.retry,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.buttonTextLight),
                    ),
                  ),
                ),
              ),
            )
          else
            Skeletonizer(
              enabled: isLoading,
              child: rows.isEmpty && !isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: MobileStateCard(
                        isDark: isDark,
                        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                        icon: Icon(
                          Icons.description_outlined,
                          size: 32.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        title: loc.hiringRequisitionsTableEmptyTitle,
                        subtitle: loc.hiringRequisitionsTableEmptyMessage,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Gap(10.h),
                      itemBuilder: (context, index) => _RequisitionCard(row: rows[index], isDark: isDark),
                    ),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: currentPage,
            totalPages: totalPages,
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            onPrevious: hasPrevious && !isLoading
                ? () => ref.read(requisitionsCurrentPageProvider.notifier).state = currentPage - 1
                : null,
            onNext: hasNext && !isLoading
                ? () => ref.read(requisitionsCurrentPageProvider.notifier).state = currentPage + 1
                : null,
          ),
        ],
      ),
    );
  }
}

class _RequisitionCard extends ConsumerWidget with RequisitionsPermissionMixin, RequisitionsActionsConfirmationMixin {
  const _RequisitionCard({required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final isDraft = row.statusEnum == RequisitionStatus.draft;
    final isPending = row.statusEnum == RequisitionStatus.submitted;
    final isApproving = ref.watch(approveRequisitionActionLoadingProvider(row.id));
    final isDeleting = ref.watch(deleteRequisitionActionLoadingProvider(row.id));
    final isRejecting = ref.watch(rejectRequisitionActionLoadingProvider(row.id));
    final targetStart = row.targetStartLabel(locale: Localizations.localeOf(context).toString());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.goNamed(RequisitionDetailPage.routeName, extra: row),
                      child: Text(
                        row.requisitionCode,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      row.jobTitle,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(6.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: [
                        DigifyCapsule(
                          label: row.gradeNumber,
                          backgroundColor: Colors.transparent,
                          textColor: primaryColor,
                          borderColor: tileBorderColor,
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        ),
                        DigifyCapsule(
                          label: row.employmentTypeLabel,
                          backgroundColor: isDark ? AppColors.grayBgDark : const Color(0xFFECEEF2),
                          textColor: primaryColor,
                          borderColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: row.status),
            ],
          ),
          Gap(12.h),
          Text(row.department, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          Gap(2.h),
          Text(row.roleTitle, style: context.textTheme.bodySmall?.copyWith(color: subtitleColor)),
          Text(
            row.hasHiringManager
                ? '${loc.hiringRequisitionsHiringManagerLabel} ${row.hiringManager}'
                : row.hiringManager,
            style: context.textTheme.bodySmall?.copyWith(color: subtitleColor),
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.location, style: context.textTheme.bodySmall?.copyWith(color: primaryColor)),
                    Gap(4.h),
                    DigifyCapsule(
                      label: row.workModeLabel,
                      backgroundColor: Colors.transparent,
                      textColor: primaryColor,
                      borderColor: tileBorderColor,
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    loc.hiringRequisitionsTableColOpenings,
                    style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 10.sp),
                  ),
                  Gap(2.h),
                  Text('${row.openings}', style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          Gap(12.h),
          Text(row.compensationRange, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          Text(row.compensationTypeLabel, style: context.textTheme.bodySmall?.copyWith(color: subtitleColor)),
          Gap(12.h),
          Text(
            row.hasApprovalProgress
                ? '${row.approvalLabel} ${loc.hiringRequisitionsApprovalsLabel}'
                : row.approvalLabel,
            style: context.textTheme.bodySmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
          ),
          Gap(12.h),
          Row(
            children: [
              if (row.hasPriority)
                RequisitionsPriorityCapsule(priority: row.priorityLabel)
              else
                Text(
                  row.priorityLabel,
                  style: context.textTheme.bodySmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
                ),
              const Spacer(),
              DigifyAsset(assetPath: Assets.icons.clockIcon.path, color: subtitleColor, width: 14.w, height: 14.w),
              Gap(6.w),
              Text(
                targetStart,
                style: context.textTheme.bodySmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
              ),
            ],
          ),
          if (canViewRequisitions || canCreateRequisition || canUpdateRequisition) ...[
            Gap(12.h),
            const DigifyDivider.thin(),
            Gap(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (canViewRequisitions)
                  AppMobileButton(
                    svgPath: Assets.icons.viewIconBlue.path,
                    backgroundColor: AppColors.viewIconBlue,
                    foregroundColor: AppColors.cardBackground,
                    onPressed: () => context.goNamed(RequisitionDetailPage.routeName, extra: row),
                  ),
                if (canCreateRequisition) ...[
                  if (canViewRequisitions) Gap(12.w),
                  AppMobileButton(
                    svgPath: Assets.icons.copyGray.path,
                    type: AppButtonType.secondary,
                    backgroundColor: AppColors.dashCompensation,
                    foregroundColor: AppColors.cardBackground,
                    onPressed: () => CreateRequisitionMobileSheet.show(context, requisitionToDuplicate: row),
                  ),
                ],
                if ((canViewRequisitions || canCreateRequisition) && canUpdateRequisition && (isPending || isDraft))
                  Gap(12.w),
                if (canUpdateRequisition && isPending) ...[
                  AppMobileButton(
                    svgPath: Assets.icons.checkIconGreen.path,
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.cardBackground,
                    isLoading: isApproving,
                    onPressed: isApproving
                        ? null
                        : () async {
                            final ok = await confirmApprove(context, itemName: row.requisitionCode);
                            if (ok != true || !context.mounted) return;
                            await ref
                                .read(approveRequisitionControllerProvider)
                                .approve(context, requisitionGuid: row.id);
                          },
                  ),
                  Gap(12.w),
                  AppMobileButton(
                    svgPath: Assets.icons.closeIcon.path,
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.cardBackground,
                    isLoading: isRejecting,
                    onPressed: isRejecting
                        ? null
                        : () async {
                            final reason = await confirmReject(context, itemName: row.requisitionCode);
                            if (reason == null || reason.trim().isEmpty || !context.mounted) {
                              return;
                            }
                            await ref
                                .read(rejectRequisitionControllerProvider)
                                .reject(context, requisitionGuid: row.id, rejectionReason: reason.trim());
                          },
                  ),
                ],
                if (canUpdateRequisition && isDraft) ...[
                  AppMobileButton(
                    svgPath: Assets.icons.editIcon.path,
                    type: AppButtonType.secondary,
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.cardBackground,
                    onPressed: () {
                      CreateRequisitionMobileSheet.show(context, requisitionToEdit: row);
                    },
                  ),
                  Gap(12.w),
                  AppMobileButton(
                    svgPath: Assets.icons.deleteIconRed.path,
                    backgroundColor: AppColors.deleteIconRed,
                    foregroundColor: AppColors.cardBackground,
                    isLoading: isDeleting,
                    onPressed: isDeleting
                        ? null
                        : () async {
                            final ok = await confirmDeleteDraft(context, itemName: row.requisitionCode);
                            if (ok != true || !context.mounted) return;
                            await ref
                                .read(deleteRequisitionControllerProvider)
                                .delete(context, requisitionGuid: row.id);
                          },
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

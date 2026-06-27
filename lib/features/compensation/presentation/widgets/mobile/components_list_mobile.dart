import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/compensation/presentation/models/component_table_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/components_table_rows_provider.dart';
import 'package:grc/features/compensation/presentation/screens/components_tab/update_component_mobile_sheet.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/components_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ComponentsListMobile extends ConsumerWidget {
  const ComponentsListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isLoading = ref.watch(componentsTableIsLoadingProvider);
    final errorMessage = ref.watch(componentsTableErrorProvider);
    final liveRowsAsync = ref.watch(componentsTableRowsProvider);
    final liveRows = liveRowsAsync.valueOrNull ?? const [];
    final skeletonRows = ref.watch(componentsSkeletonRowsProvider);
    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;
    final currentPage = ref.watch(componentsCurrentPageProvider);
    final totalPages = ref.watch(componentsTotalPagesProvider);
    final hasNext = ref.watch(componentsHasNextProvider);
    final hasPrevious = ref.watch(componentsHasPreviousProvider);

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
                title: 'Failed to load components',
                subtitle: errorMessage,
                action: GestureDetector(
                  onTap: () => ref.invalidate(componentsPageProvider),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                    decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      'Retry',
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
                          Icons.layers_clear_rounded,
                          size: 32.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        title: 'No Components Found',
                        subtitle: 'No components match your search or filters.',
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Gap(10.h),
                      itemBuilder: (context, index) => _ComponentCard(row: rows[index], isDark: isDark),
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
                ? () => ref.read(componentsCurrentPageProvider.notifier).state = currentPage - 1
                : null,
            onNext: hasNext && !isLoading
                ? () => ref.read(componentsCurrentPageProvider.notifier).state = currentPage + 1
                : null,
          ),
        ],
      ),
    );
  }
}

class _ComponentCard extends ConsumerWidget with ComponentsPermissionMixin {
  const _ComponentCard({required this.row, required this.isDark});

  final ComponentTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    final deletingGuid = ref.watch(componentsDeletionControllerProvider);
    final isDeleting = row.component?.componentGuid != null && deletingGuid == row.component?.componentGuid;

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
                    Text(
                      row.name,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(2.h),
                    Text(
                      row.code,
                      style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: row.status),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              DigifyCapsule(label: row.category, textColor: AppColors.primary, backgroundColor: AppColors.infoBg),
              const Spacer(),
              _InfoRow(
                label: 'Calculation',
                value: row.calculation,
                valueColor: primaryColor,
                labelColor: subtitleColor,
              ),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(12.h),
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: row.payroll != 'Not Mapped' ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(6.w),
                  Text(
                    row.payroll,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: row.payroll != 'Not Mapped' ? AppColors.success : AppColors.error,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.employeeSelfService.learning.path,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.grayBorderDark,
                    width: 14.w,
                    height: 14.w,
                  ),
                  Gap(6.w),
                  Text(
                    '${row.usedInPlans} plans',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canUpdateComponent)
                AppMobileButton(
                  svgPath: Assets.icons.editIcon.path,
                  type: AppButtonType.secondary,
                  backgroundColor: AppColors.success,
                  onPressed: isDeleting || row.component == null
                      ? null
                      : () async {
                          final updated = await UpdateComponentMobileSheet.show(context, row.component!);
                          if (updated == true && context.mounted) {
                            ref.read(componentsTabRefreshTickProvider.notifier).state++;
                          }
                        },
                  foregroundColor: AppColors.cardBackground,
                ),
              if (canDeleteComponent) ...[
                Gap(12.w),
                AppMobileButton.danger(
                  svgPath: Assets.icons.deleteIconRed.path,
                  isLoading: isDeleting,
                  onPressed: () => _showDeleteConfirmation(context, ref),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final componentGuid = row.component?.componentGuid;
    if (componentGuid == null) return;

    final result = await AppConfirmationDialog.show(
      context,
      title: 'Delete Component',
      message: 'Are you sure you want to delete this component?',
      itemName: row.name,
      confirmLabel: 'Delete',
      type: ConfirmationType.danger,
    );

    if (result == true && context.mounted) {
      try {
        await ref.read(componentsDeletionControllerProvider.notifier).deleteComponent(componentGuid: componentGuid);
        if (context.mounted) {
          ToastService.show(context: context, message: 'Component deleted successfully', type: ToastType.success);
        }
      } catch (e) {
        if (context.mounted) {
          ToastService.show(
            context: context,
            message: 'Failed to delete component: ${e.toString()}',
            type: ToastType.error,
          );
        }
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.valueColor, required this.labelColor});

  final String label;
  final String value;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: labelColor),
        ),
        Gap(2.h),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: valueColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

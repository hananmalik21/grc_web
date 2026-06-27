import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/get_requisition_detail_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_api_providers.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/utils/requisition_ui_placeholder.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RequisitionDetailHeader extends ConsumerWidget {
  const RequisitionDetailHeader({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final loc = AppLocalizations.of(context)!;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isActivating = ref.watch(activateRequisitionActionLoadingProvider(row.id));
    final isClosing = ref.watch(closeRequisitionActionLoadingProvider(row.id));
    final isHolding = ref.watch(holdRequisitionActionLoadingProvider(row.id));

    ref.listen(activateRequisitionResultProvider(row.id), (_, next) {
      if (next == null) return;
      next.when(
        data: (_) {
          ToastService.success(context, loc.activate);
          _invalidateDetail(ref);
        },
        error: (e, _) => ToastService.error(context, e.toString()),
        loading: () {},
      );
    });

    ref.listen(closeRequisitionResultProvider(row.id), (_, next) {
      if (next == null) return;
      next.when(
        data: (_) {
          ToastService.success(context, loc.close);
          _invalidateDetail(ref);
        },
        error: (e, _) => ToastService.error(context, e.toString()),
        loading: () {},
      );
    });

    ref.listen(holdRequisitionResultProvider(row.id), (_, next) {
      if (next == null) return;
      next.when(
        data: (_) {
          ToastService.success(context, loc.hiringRequisitionDetailActionPutOnHold);
          _invalidateDetail(ref);
        },
        error: (e, _) => ToastService.error(context, e.toString()),
        loading: () {},
      );
    });

    void onActivate() => _confirmAndActivate(context, ref, loc);
    void onClose() => _confirmAndClose(context, ref, loc);
    void onHold() => _confirmAndHold(context, ref, loc);

    if (isMobile) {
      return _buildMobileHeader(
        context,
        textPrimary,
        loc,
        row.canPutOnHold,
        row.canClose,
        row.canActivate,
        onActivate: onActivate,
        isActivating: isActivating,
        onClose: onClose,
        isClosing: isClosing,
        onHold: onHold,
        isHolding: isHolding,
      );
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: _buildDesktopHeader(
        context,
        textPrimary,
        loc,
        row.canPutOnHold,
        row.canClose,
        row.canActivate,
        onActivate: onActivate,
        isActivating: isActivating,
        onClose: onClose,
        isClosing: isClosing,
        onHold: onHold,
        isHolding: isHolding,
      ),
    );
  }

  Future<void> _confirmAndActivate(BuildContext context, WidgetRef ref, AppLocalizations loc) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.hiringRequisitionActivateConfirmTitle,
      message: loc.hiringRequisitionActivateConfirmMessage,
      itemName: row.jobTitle,
      confirmLabel: loc.activate,
      type: ConfirmationType.success,
      svgPath: Assets.icons.activateIcon.path,
    );

    if (confirmed == true && context.mounted) {
      ref.read(activateRequisitionControllerProvider).activate(row.id);
    }
  }

  Future<void> _confirmAndClose(BuildContext context, WidgetRef ref, AppLocalizations loc) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.hiringRequisitionCloseConfirmTitle,
      message: loc.hiringRequisitionCloseConfirmMessage,
      itemName: row.jobTitle,
      confirmLabel: loc.close,
      type: ConfirmationType.danger,
      svgPath: Assets.icons.closeIcon.path,
    );

    if (confirmed == true && context.mounted) {
      ref.read(closeRequisitionControllerProvider).close(row.id);
    }
  }

  Future<void> _confirmAndHold(BuildContext context, WidgetRef ref, AppLocalizations loc) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.hiringRequisitionHoldConfirmTitle,
      message: loc.hiringRequisitionHoldConfirmMessage,
      itemName: row.jobTitle,
      confirmLabel: loc.hiringRequisitionDetailActionPutOnHold,
      type: ConfirmationType.warning,
      svgPath: Assets.icons.hiring.hold.path,
    );

    if (confirmed == true && context.mounted) {
      ref.read(holdRequisitionControllerProvider).hold(row.id);
    }
  }

  void _invalidateDetail(WidgetRef ref) {
    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider) ?? 1;
    ref.invalidate(
      getRequisitionDetailProvider(GetRequisitionDetailParams(enterpriseId: enterpriseId, requisitionGuid: row.id)),
    );
  }

  Widget _buildMobileHeader(
    BuildContext context,
    Color textPrimary,
    AppLocalizations loc,
    bool canPutOnHold,
    bool canClose,
    bool canActivate, {
    required VoidCallback onActivate,
    required bool isActivating,
    required VoidCallback onClose,
    required bool isClosing,
    required VoidCallback onHold,
    required bool isHolding,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAssetButton(
              onTap: () => context.pop(),
              assetPath: Assets.icons.employeeManagement.backArrow.path,
              padding: 0,
            ),
            const Spacer(),
            AppMobileButton.outline(svgPath: Assets.icons.hiring.careerSite.path, onPressed: () {}),
            if (canActivate) ...[
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.checkIconGreen.path,
                backgroundColor: AppColors.success,
                isLoading: isActivating,
                onPressed: isActivating ? null : onActivate,
              ),
            ],
            if (canPutOnHold) ...[
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.hiring.hold.path,
                backgroundColor: AppColors.informationIconColor,
                isLoading: isHolding,
                onPressed: isHolding ? null : onHold,
              ),
            ],
            if (canClose) ...[
              Gap(8.w),
              AppMobileButton(
                type: AppButtonType.outline,
                svgPath: Assets.icons.closeIcon.path,
                borderColor: AppColors.error,
                foregroundColor: AppColors.error,
                isLoading: isClosing,
                onPressed: isClosing ? null : onClose,
              ),
            ],
          ],
        ),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.jobTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontSize: 18.sp,
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    row.requisitionCode,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Gap(12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!RequisitionUiPlaceholder.isPlaceholder(row.approvalStatusLabel))
                  DigifyStatusCapsule(status: row.approvalStatusLabel),
                if (row.openStatusLabel != null) ...[
                  Gap(4.h),
                  DigifyStatusCapsule(status: row.openStatusLabel!, showDotWhenActive: true),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(
    BuildContext context,
    Color textPrimary,
    AppLocalizations loc,
    bool canPutOnHold,
    bool canClose,
    bool canActivate, {
    required VoidCallback onActivate,
    required bool isActivating,
    required VoidCallback onClose,
    required bool isClosing,
    required VoidCallback onHold,
    required bool isHolding,
  }) {
    final titleAndCode = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                row.jobTitle,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 22.sp,
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gap(12.w),
            if (!RequisitionUiPlaceholder.isPlaceholder(row.approvalStatusLabel))
              DigifyStatusCapsule(status: row.approvalStatusLabel),
            if (row.openStatusLabel != null) ...[
              Gap(6.w),
              DigifyStatusCapsule(status: row.openStatusLabel!, showDotWhenActive: true),
            ],
          ],
        ),
        Gap(4.h),
        Text(
          row.requisitionCode,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(
          label: loc.hiringRequisitionDetailActionViewOnCareerSite,
          svgPath: Assets.icons.hiring.careerSite.path,
          onPressed: () {},
        ),
        if (canActivate) ...[
          Gap(8.w),
          AppButton(
            label: loc.activate,
            svgPath: Assets.icons.checkIconGreen.path,
            backgroundColor: AppColors.success,
            isLoading: isActivating,
            onPressed: isActivating ? null : onActivate,
          ),
        ],
        if (canPutOnHold) ...[
          Gap(8.w),
          AppButton(
            label: loc.hiringRequisitionDetailActionPutOnHold,
            svgPath: Assets.icons.hiring.hold.path,
            backgroundColor: AppColors.informationIconColor,
            isLoading: isHolding,
            onPressed: isHolding ? null : onHold,
          ),
        ],
        if (canClose) ...[
          Gap(8.w),
          AppButton.dangerOutline(
            label: loc.close,
            svgPath: Assets.icons.closeIcon.path,
            isLoading: isClosing,
            onPressed: isClosing ? null : onClose,
          ),
        ],
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
        Gap(24.w),
        Expanded(child: titleAndCode),
        actionButtons,
      ],
    );
  }
}

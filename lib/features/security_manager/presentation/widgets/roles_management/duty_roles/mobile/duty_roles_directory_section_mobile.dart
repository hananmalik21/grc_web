import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/create_duty_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/duty_role_details_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/edit_duty_role_dialog/edit_duty_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles/mobile/duty_role_card_mobile.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles/mobile/duty_roles_list_skeleton_mobile.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DutyRolesDirectorySectionMobile extends ConsumerWidget with RolesManagementPermissionMixin {
  const DutyRolesDirectorySectionMobile({required this.onExport, this.isExporting = false, super.key});

  final VoidCallback onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(dutyRolesProvider);
    final notifier = ref.read(dutyRolesProvider.notifier);
    final borderColor = context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;

    return RolesManagementSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 12.h),
            child: _DutyRolesDirectoryHeaderMobile(
              title: l10n.dutyRolesDirectoryTitle,
              roleCountLabel: l10n.rolesDirectoryRoleCount(state.totalItems),
              onExport: isExporting ? null : onExport,
              onCreate: canCreateRole ? () => CreateDutyRoleDialog.show(context) : null,
              exportLabel: l10n.export,
              createLabel: l10n.createDutyRole,
            ),
          ),
          Divider(height: 1, thickness: 1, color: borderColor),
          if (state.isLoading)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 8.h),
              child: const DutyRolesListSkeletonMobile(),
            )
          else if (state.error != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: _DutyRolesDirectoryError(message: state.error!),
            )
          else if (state.paginatedRoles.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.h),
              child: RolesManagementEmptyBody(message: l10n.dutyRolesDirectoryEmpty),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 12.h),
              itemCount: state.paginatedRoles.length,
              separatorBuilder: (_, _) => Gap(12.h),
              itemBuilder: (context, index) {
                final role = state.paginatedRoles[index];
                return DutyRoleCardMobile(
                  role: role,
                  deleteIsLoading: state.deletingDutyRoleGuid == role.dutyRoleGuid,
                  onView: () => DutyRoleDetailsDialog.show(context, role: role),
                  onEdit: canUpdateRole ? () => EditDutyRoleDialog.show(context, role: role) : null,
                  onDelete: canDeleteRole ? () => _handleDelete(context, ref, role) : null,
                );
              },
            ),
          DigifyDivider.horizontal(),
          PaginationControls.fromPaginationInfo(
            paginationInfo: PaginationInfo(
              currentPage: state.safeCurrentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.effectivePageSize,
              hasNext: state.hasNext,
              hasPrevious: state.hasPrevious,
            ),
            currentPage: state.safeCurrentPage,
            pageSize: state.effectivePageSize,
            isLoading: false,
            onPrevious: notifier.previousPage,
            onNext: notifier.nextPage,
            onPageTap: notifier.goToPage,
            showBorder: false,
          ),
        ],
      ),
    );
  }
}

Future<void> _handleDelete(BuildContext context, WidgetRef ref, DutyRoleItem role) async {
  if (role.dutyRoleGuid.isEmpty) {
    ToastService.error(context, 'This duty role cannot be deleted (missing id).');
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    barrierDismissible: false,
    builder: (dialogContext) {
      return AppConfirmationDialog.delete(
        title: 'Delete Duty Role',
        message: 'Are you sure you want to delete this duty role?',
        itemName: '${role.name} (${role.code})',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
        onConfirm: () => Navigator.of(dialogContext).pop(true),
        onCancel: () => Navigator.of(dialogContext).pop(false),
      );
    },
  );

  if (confirmed != true || !context.mounted) return;

  final errorMessage = await ref.read(dutyRolesProvider.notifier).deleteDutyRole(role.dutyRoleGuid);
  if (!context.mounted) return;

  if (errorMessage != null) {
    ToastService.error(context, errorMessage);
    return;
  }

  ToastService.success(context, '${role.name} deleted successfully', title: 'Deleted');
  await ref.read(dutyRolesProvider.notifier).refresh(showLoading: true);
}

class _DutyRolesDirectoryError extends StatelessWidget {
  const _DutyRolesDirectoryError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.error_outline, color: AppColors.error, size: 40.r),
        Gap(12.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _DutyRolesDirectoryHeaderMobile extends StatelessWidget {
  const _DutyRolesDirectoryHeaderMobile({
    required this.title,
    required this.roleCountLabel,
    required this.onExport,
    required this.exportLabel,
    required this.createLabel,
    this.onCreate,
  });

  final String title;
  final String roleCountLabel;
  final VoidCallback? onExport;
  final VoidCallback? onCreate;
  final String exportLabel;
  final String createLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: primaryText),
              ),
              Gap(4.h),
              Text(roleCountLabel, style: context.textTheme.bodySmall?.copyWith(color: AppColors.grayBorderDark)),
            ],
          ),
        ),
        Gap(12.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              label: exportLabel,
              child: _DutyDirectoryIconAction(
                svgPath: Assets.icons.downloadIcon.path,
                onPressed: onExport,
                isDark: isDark,
                tooltip: exportLabel,
              ),
            ),
            if (onCreate != null) ...[
              Gap(8.w),
              Semantics(
                button: true,
                label: createLabel,
                child: _DutyDirectoryIconAction(
                  svgPath: Assets.icons.addDivisionIcon.path,
                  onPressed: onCreate,
                  isDark: isDark,
                  isPrimary: true,
                  tooltip: createLabel,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DutyDirectoryIconAction extends StatelessWidget {
  const _DutyDirectoryIconAction({
    required this.svgPath,
    required this.onPressed,
    required this.isDark,
    required this.tooltip,
    this.isPrimary = false,
  });

  final String svgPath;
  final VoidCallback? onPressed;
  final bool isDark;
  final bool isPrimary;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.all(11.w),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primary : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground),
            borderRadius: BorderRadius.circular(10.r),
            border: isPrimary ? null : Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            boxShadow: isPrimary ? AppShadows.primaryShadow : null,
          ),
          child: DigifyAsset(
            assetPath: svgPath,
            width: 19.w,
            height: 19.w,
            color: isPrimary ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
          ),
        ),
      ),
    );

    return Tooltip(message: tooltip, child: child);
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/data_role_details_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/edit_data_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/data_roles/mobile/data_role_card_mobile.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/data_roles/mobile/data_roles_list_skeleton_mobile.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataRolesDirectorySectionMobile extends ConsumerWidget with RolesManagementPermissionMixin {
  const DataRolesDirectorySectionMobile({required this.onExport, this.isExporting = false, super.key});

  final VoidCallback onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dataRolesProvider);
    final notifier = ref.read(dataRolesProvider.notifier);
    final borderColor = context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;

    return RolesManagementSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 12.h),
            child: _DataRolesDirectoryHeaderMobile(
              title: 'Data Roles Directory',
              roleCountLabel: '(${state.totalItems} roles)',
              onExport: isExporting ? null : onExport,
              isExporting: isExporting,
              onCreate: canCreateRole ? () => CreateDataRoleDialog.show(context) : null,
            ),
          ),
          Divider(height: 1, thickness: 1, color: borderColor),
          if (state.isLoading)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 8.h),
              child: const DataRolesListSkeletonMobile(),
            )
          else if (state.error != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: _DataRolesDirectoryError(message: state.error!),
            )
          else if (state.roles.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.h),
              child: const RolesManagementEmptyBody(message: 'No data roles found for the current search and filter.'),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 12.h),
              itemCount: state.roles.length,
              separatorBuilder: (_, _) => Gap(12.h),
              itemBuilder: (context, index) {
                final role = state.roles[index];
                return DataRoleCardMobile(
                  role: role,
                  deleteIsLoading: state.deletingDataRoleGuid == role.dataRoleGuid,
                  onView: () => DataRoleDetailsDialog.show(context, role: role),
                  onEdit: canUpdateRole ? () => EditDataRoleDialog.show(context, role: role) : null,
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

Future<void> _handleDelete(BuildContext context, WidgetRef ref, DataRoleItem role) async {
  if (role.dataRoleGuid.isEmpty) {
    ToastService.error(context, 'This data role cannot be deleted (missing id).');
    return;
  }

  final confirmed = await DeleteConfirmationDialog.show(
    context,
    title: 'Delete Data Role',
    message: 'Are you sure you want to delete this data role?',
    itemName: '${role.name} (${role.code})',
  );

  if (confirmed != true || !context.mounted) return;

  final ok = await ref.read(dataRolesProvider.notifier).deleteDataRole(role.dataRoleGuid);
  if (!context.mounted) return;

  if (!ok) {
    ToastService.error(context, ref.read(dataRolesProvider).error ?? 'Failed to delete data role');
    return;
  }

  ToastService.success(context, '${role.name} deleted successfully', title: 'Deleted');
  await ref.read(dataRolesProvider.notifier).refresh(showLoading: true);
}

class _DataRolesDirectoryError extends StatelessWidget {
  const _DataRolesDirectoryError({required this.message});

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

class _DataRolesDirectoryHeaderMobile extends StatelessWidget {
  const _DataRolesDirectoryHeaderMobile({
    required this.title,
    required this.roleCountLabel,
    required this.onExport,
    this.isExporting = false,
    this.onCreate,
  });

  final String title;
  final String roleCountLabel;
  final VoidCallback? onExport;
  final bool isExporting;
  final VoidCallback? onCreate;

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
            AppMobileButton.outline(
              svgPath: Assets.icons.downloadIcon.path,
              onPressed: onExport,
              isLoading: isExporting,
            ),
            if (onCreate != null) ...[Gap(8.w), AppMobileButton.primary(icon: Icons.add, onPressed: onCreate)],
          ],
        ),
      ],
    );
  }
}

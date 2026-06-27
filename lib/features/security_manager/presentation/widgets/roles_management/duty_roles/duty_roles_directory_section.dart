import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/create_duty_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles/duty_role_card_skeleton.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles/duty_roles_role_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DutyRolesDirectorySection extends StatelessWidget {
  const DutyRolesDirectorySection({
    super.key,
    required this.state,
    required this.onPrevious,
    required this.onNext,
    required this.onPageTap,
    required this.onExport,
    this.isExporting = false,
  });

  final DutyRolesState state;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<int> onPageTap;
  final VoidCallback onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return RolesManagementSurfaceCard(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 500.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _DirectoryHeader(totalRoles: state.totalItems, onExport: onExport, isExporting: isExporting),
                  Gap(18.h),
                  _Body(state: state),
                ],
              ),
            ),
            if (!state.isLoading && state.error == null)
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
                onPrevious: onPrevious,
                onNext: onNext,
                onPageTap: onPageTap,
                showBorder: false,
              ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final DutyRolesState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const DutyRolesListSkeleton();
    }

    if (state.error != null) {
      return _ErrorBody(message: state.error!);
    }

    final roles = state.paginatedRoles;

    if (roles.isEmpty) {
      return const RolesManagementEmptyBody(message: 'No duty roles found for the current search and filter.');
    }

    return Column(
      children: [
        for (int i = 0; i < roles.length; i++) ...[DutyRoleCard(role: roles[i]), if (i != roles.length - 1) Gap(14.h)],
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 40.r),
          Gap(12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DirectoryHeader extends StatelessWidget with RolesManagementPermissionMixin {
  const _DirectoryHeader({required this.totalRoles, required this.onExport, this.isExporting = false});

  final int totalRoles;
  final VoidCallback onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final countText = '($totalRoles roles)';

    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Duty Roles Directory',
                style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
              ),
              Gap(8.w),
              Text(countText, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.grayBorderDark)),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Export',
                  onPressed: isExporting ? null : onExport,
                  isLoading: isExporting,
                  svgPath: Assets.icons.downloadIcon.path,
                  width: double.infinity,
                ),
              ),
              if (canCreateRole) ...[
                Gap(10.w),
                Expanded(
                  child: AppButton.primary(
                    label: 'Create Duty Role',
                    onPressed: () => CreateDutyRoleDialog.show(context),
                    icon: Icons.add,
                    width: double.infinity,
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                'Duty Roles Directory',
                style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
              ),
              Gap(8.w),
              Text(countText, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.grayBorderDark)),
            ],
          ),
        ),
        AppButton.outline(
          label: 'Export',
          onPressed: isExporting ? null : onExport,
          isLoading: isExporting,
          svgPath: Assets.icons.downloadIcon.path,
        ),
        if (canCreateRole) ...[
          Gap(10.w),
          AppButton.primary(
            label: 'Create Duty Role',
            onPressed: () => CreateDutyRoleDialog.show(context),
            icon: Icons.add,
          ),
        ],
      ],
    );
  }
}

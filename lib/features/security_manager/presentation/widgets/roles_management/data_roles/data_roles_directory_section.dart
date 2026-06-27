import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/data_roles/data_roles_list_skeleton.dart';
import 'package:flutter/foundation.dart' show AsyncCallback;
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/data_roles/data_roles_role_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataRolesDirectorySection extends StatelessWidget {
  const DataRolesDirectorySection({
    super.key,
    required this.state,
    required this.onPrevious,
    required this.onNext,
    required this.onPageTap,
    required this.onExport,
    this.isExporting = false,
  });

  final DataRolesState state;
  final AsyncCallback onPrevious;
  final AsyncCallback onNext;
  final Future<void> Function(int) onPageTap;
  final VoidCallback onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return RolesManagementSurfaceCard(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _DirectoryHeader(totalRoles: state.totalItems, onExport: onExport, isExporting: isExporting),
                Gap(18.h),
                if (state.isLoading)
                  const DataRolesListSkeleton()
                else if (state.roles.isEmpty)
                  const RolesManagementEmptyBody(message: 'No data roles found for the current search and filter.')
                else
                  Column(
                    children: [
                      for (int index = 0; index < state.roles.length; index++) ...[
                        DataRoleCard(role: state.roles[index]),
                        if (index != state.roles.length - 1) Gap(14.h),
                      ],
                    ],
                  ),
              ],
            ),
          ),
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
            isLoading: false,
            showBorder: false,
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
                'Data Roles Directory',
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
                    label: 'Create New Role',
                    onPressed: () => CreateDataRoleDialog.show(context),
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
                'Data Roles Directory',
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
            label: 'Create New Role',
            onPressed: () => CreateDataRoleDialog.show(context),
            icon: Icons.add,
          ),
        ],
      ],
    );
  }
}

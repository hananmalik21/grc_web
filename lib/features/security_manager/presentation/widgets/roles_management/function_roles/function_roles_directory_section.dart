import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/function_roles/function_role_card_skeleton.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/function_roles/function_roles_role_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FunctionRolesDirectorySection extends ConsumerWidget {
  const FunctionRolesDirectorySection({required this.onExport, this.isExporting = false, super.key});

  final VoidCallback onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(functionRolesProvider);
    final notifier = ref.read(functionRolesProvider.notifier);

    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.primaryShadow),
      child: RolesManagementSurfaceCard(
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
                    if (state.isLoading || state.isRefreshing)
                      const FunctionRolesListSkeleton()
                    else if (state.paginatedRoles.isEmpty)
                      const RolesManagementEmptyBody(
                        message: 'No function roles found for the current search and filter.',
                      )
                    else
                      Column(
                        children: [
                          for (int i = 0; i < state.paginatedRoles.length; i++) ...[
                            FunctionRoleCard(role: state.paginatedRoles[i]),
                            if (i != state.paginatedRoles.length - 1) Gap(14.h),
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
                isLoading: false,
                onPrevious: notifier.previousPage,
                onNext: notifier.nextPage,
                onPageTap: notifier.goToPage,
                showBorder: false,
              ),
            ],
          ),
        ),
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

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                'Function Roles Directory',
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
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
            onPressed: () => FunctionRoleFormDialog.showCreate(context),
            svgPath: Assets.icons.addDivisionIcon.path,
          ),
        ],
      ],
    );
  }
}

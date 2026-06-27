import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/application_role_detail_screen.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/application_role_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

const _pageSize = 5;

class ApplicationRolesDirectorySection extends ConsumerStatefulWidget {
  const ApplicationRolesDirectorySection({super.key});

  @override
  ConsumerState<ApplicationRolesDirectorySection> createState() => _ApplicationRolesDirectorySectionState();
}

class _ApplicationRolesDirectorySectionState extends ConsumerState<ApplicationRolesDirectorySection> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final roles = ref.watch(applicationRolesProvider).filteredRoles;
    final totalItems = roles.length;
    final totalPages = (totalItems / _pageSize).ceil().clamp(1, double.infinity).toInt();

    // Clamp page in case filters reduce the total.
    final safePage = _currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);
    if (safePage != _currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _currentPage = safePage);
      });
    }

    final startIndex = (safePage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalItems);
    final pageRoles = roles.sublist(startIndex, endIndex);

    return RolesManagementSurfaceCard(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _DirectoryHeader(totalRoles: totalItems),
                Gap(18.h),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 400.h),
                  child: pageRoles.isEmpty
                      ? const Align(
                          alignment: Alignment.topCenter,
                          child: RolesManagementEmptyBody(
                            message: 'No application roles found for the current filter.',
                          ),
                        )
                      : Column(
                          children: [
                            for (int i = 0; i < pageRoles.length; i++) ...[
                              ApplicationRoleCard(
                                role: pageRoles[i],
                                onView: () =>
                                    context.pushNamed(ApplicationRoleDetailScreen.routeName, extra: pageRoles[i]),
                              ),
                              if (i != pageRoles.length - 1) Gap(14.h),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
          if (totalItems > 0)
            PaginationControls(
              currentPage: safePage,
              totalPages: totalPages,
              totalItems: totalItems,
              pageSize: _pageSize,
              hasNext: safePage < totalPages,
              hasPrevious: safePage > 1,
              onPrevious: () => setState(() => _currentPage = safePage - 1),
              onNext: () => setState(() => _currentPage = safePage + 1),
            ),
        ],
      ),
    );
  }
}

class _DirectoryHeader extends StatelessWidget with RolesManagementPermissionMixin {
  const _DirectoryHeader({required this.totalRoles});

  final int totalRoles;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final countText = '($totalRoles roles)';

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                'Application Roles Directory',
                style: context.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(8.w),
              Text(countText, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.grayBorderDark)),
            ],
          ),
        ),
        AppButton.outline(label: 'Export', onPressed: () {}, svgPath: Assets.icons.downloadIcon.path),
        if (canCreateRole) ...[
          Gap(10.w),
          AppButton.primary(label: 'Create New Role', onPressed: () {}, svgPath: Assets.icons.addDivisionIcon.path),
        ],
      ],
    );
  }
}

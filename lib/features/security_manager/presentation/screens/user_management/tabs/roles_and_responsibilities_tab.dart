import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_form_job_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_form_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/job_role_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_form_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RolesAndResponsibilitiesTab extends ConsumerWidget {
  const RolesAndResponsibilitiesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobRolesAsync = ref.watch(userFormJobRolesProvider);
    final assignedRoles = ref.watch(userFormProvider).assignedRoles;
    final notifier = ref.read(userFormProvider.notifier);
    final pageNotifier = ref.read(userFormJobRolesCurrentPageProvider.notifier);

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Assigned Roles',
        subtitle: 'Select job roles to assign to this user.',
        iconAssetPath: Assets.icons.securityIcon.path,
      ),
      child: jobRolesAsync.when(
        loading: () => const _JobRolesSkeletonGrid(),
        error: (e, _) => const _JobRolesError(),
        data: (pageData) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 360.h),
              child: pageData.roles.isEmpty
                  ? const _JobRolesEmpty()
                  : _JobRolesGrid(roles: pageData.roles, assignedRoles: assignedRoles, onToggle: notifier.setRole),
            ),
            Gap(12.h),
            PaginationControls(
              currentPage: pageData.currentPage,
              totalPages: pageData.totalPages,
              totalItems: pageData.totalItems,
              pageSize: pageData.pageSize,
              hasNext: pageData.hasNext,
              hasPrevious: pageData.hasPrevious,
              onPrevious: pageData.hasPrevious ? () => pageNotifier.state = pageData.currentPage - 1 : null,
              onNext: pageData.hasNext ? () => pageNotifier.state = pageData.currentPage + 1 : null,
              isLoading: false,
              showBorder: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _JobRolesGrid extends StatelessWidget {
  const _JobRolesGrid({required this.roles, required this.assignedRoles, required this.onToggle});

  final List<JobRole> roles;
  final List<int> assignedRoles;
  final void Function(int) onToggle;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isMobile ? 1 : 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 10.h,
        mainAxisExtent: 78.h,
      ),
      itemCount: roles.length,
      itemBuilder: (_, index) {
        final role = roles[index];
        return JobRoleCard(
          role: role,
          isSelected: assignedRoles.contains(role.jobRoleId),
          onTap: () => onToggle(role.jobRoleId),
        );
      },
    );
  }
}

class _JobRolesSkeletonGrid extends StatelessWidget {
  const _JobRolesSkeletonGrid();

  static final _placeholder = JobRole(
    jobRoleId: 0,
    jobRoleGuid: '',
    enterpriseId: 0,
    roleCode: 'ROLE_CODE',
    roleName: 'Loading role name here',
    jobTitle: 'Loading title',
    description: 'Loading description',
    status: 'ACTIVE',
    inheritedJobRoleGuids: const [],
    dutyRoles: const [],
    functionRoles: const [],
    dataRoles: const [],
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.isMobile ? 1 : 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 10.h,
          mainAxisExtent: 78.h,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: DecoratedBox(decoration: BoxDecoration(shape: BoxShape.rectangle)),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _placeholder.roleName,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      _placeholder.jobTitle,
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      _placeholder.description ?? '',
                      style: textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4.r)),
                child: Text(_placeholder.roleCode, style: textTheme.labelSmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobRolesEmpty extends StatelessWidget {
  const _JobRolesEmpty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Text(
          'No job roles found for this enterprise.',
          style: TextStyle(
            fontSize: 14.sp,
            color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _JobRolesError extends StatelessWidget {
  const _JobRolesError();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 32.sp),
            Gap(8.h),
            Text(
              'Failed to load job roles',
              style: TextStyle(
                fontSize: 14.sp,
                color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

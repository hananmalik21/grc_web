import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_selection_tile.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InheritedDataRolesSection extends StatelessWidget {
  const InheritedDataRolesSection({
    super.key,
    required this.isLoading,
    required this.selectedCount,
    required this.searchController,
    required this.roles,
    required this.selectedGuids,
    required this.onSearchChanged,
    required this.onRoleToggle,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  final bool isLoading;
  final int selectedCount;
  final TextEditingController searchController;
  final List<DataRoleItem> roles;
  final Set<String> selectedGuids;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onRoleToggle;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8.w,
          runSpacing: 4.h,
          children: [
            Text('Inherited Data Roles', style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary)),
            Text(
              '($selectedCount selected)',
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        Gap(8.h),
        Text(
          'Optional. Inherit access definitions from selected data roles.',
          style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, height: 1.35),
        ),
        Gap(12.h),
        DigifyTextField.search(
          controller: searchController,
          hintText: 'Search by name, code or data type...',
          filled: true,
          fillColor: Colors.transparent,
          onChanged: onSearchChanged,
        ),
        Gap(14.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 280.h,
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: isLoading
                      ? const _InheritedDataRoleListSkeleton()
                      : roles.isEmpty
                      ? Center(
                          child: Text(
                            'No data roles found.',
                            style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          itemCount: roles.length,
                          separatorBuilder: (_, _) => Gap(8.h),
                          itemBuilder: (context, index) {
                            final role = roles[index];
                            return RolesSelectionTile(
                              title: role.name,
                              code: role.code,
                              moduleName: role.dataType,
                              leadingIconPath: role.iconPath.isNotEmpty
                                  ? role.iconPath
                                  : DataRoleFormConfig.tabsSettingsIconPath,
                              isActive: role.isActive,
                              isSelected: selectedGuids.contains(role.dataRoleGuid),
                              onTap: () => onRoleToggle(role.dataRoleGuid),
                            );
                          },
                        ),
                ),
              ),
              PaginationControls(
                currentPage: currentPage,
                totalPages: totalPages,
                totalItems: totalItems,
                pageSize: pageSize,
                hasNext: hasNext,
                hasPrevious: hasPrevious,
                onPrevious: hasPrevious ? onPreviousPage : null,
                onNext: hasNext ? onNextPage : null,
                showBorder: true,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InheritedDataRoleListSkeleton extends StatelessWidget {
  const _InheritedDataRoleListSkeleton();

  static const _count = 5;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _count,
        separatorBuilder: (_, _) => Gap(8.h),
        itemBuilder: (_, _) => const RolesSelectionTile(
          title: 'Role name placeholder',
          code: 'DATA_CODE',
          moduleName: 'TYPE',
          isSelected: false,
        ),
      ),
    );
  }
}

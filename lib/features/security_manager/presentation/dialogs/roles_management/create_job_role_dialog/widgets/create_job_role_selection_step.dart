import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_selection_item.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_shared_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

typedef SelectionPagination = ({
  PaginationInfo info,
  VoidCallback onPrevious,
  VoidCallback onNext,
  ValueChanged<int> onPageTap,
});

typedef JobRoleSelectionRowBuilder =
    Widget Function(String code, bool isSelected, bool isLocked, VoidCallback? onToggle);

class CreateJobRoleSelectionStep extends StatelessWidget {
  const CreateJobRoleSelectionStep({
    super.key,
    required this.searchController,
    required this.searchHintText,
    required this.selectedTitle,
    required this.emptyMessage,
    required this.roleCodes,
    required this.selectedCodes,
    this.lockedCodes = const {},
    this.roleNames = const {},
    required this.onSearchChanged,
    required this.onToggleItem,
    required this.itemIconPath,
    this.isLoading = false,
    this.pagination,
    this.itemBuilder,
  });

  final TextEditingController searchController;
  final String searchHintText;
  final String selectedTitle;
  final String emptyMessage;
  final List<String> roleCodes;
  final Map<String, String> roleNames;
  final Set<String> selectedCodes;
  final Set<String> lockedCodes;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onToggleItem;
  final String itemIconPath;
  final bool isLoading;
  final SelectionPagination? pagination;
  final JobRoleSelectionRowBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField.search(controller: searchController, hintText: searchHintText, onChanged: onSearchChanged),
        Gap(20.h),
        CreateJobRoleSelectionSummaryBanner(title: selectedTitle, selectedCount: selectedCodes.length),
        Gap(18.h),
        SizedBox(
          height: 380.h,
          child: Column(
            children: [
              Expanded(
                child: _RoleList(
                  isLoading: isLoading,
                  roleCodes: roleCodes,
                  roleNames: roleNames,
                  selectedCodes: selectedCodes,
                  lockedCodes: lockedCodes,
                  emptyMessage: emptyMessage,
                  itemIconPath: itemIconPath,
                  onToggleItem: onToggleItem,
                  itemBuilder: itemBuilder,
                ),
              ),
              if (pagination != null) ...[
                Gap(12.h),
                PaginationControls.fromPaginationInfo(
                  paginationInfo: pagination!.info,
                  currentPage: pagination!.info.currentPage,
                  pageSize: pagination!.info.pageSize,
                  onPrevious: pagination!.onPrevious,
                  onNext: pagination!.onNext,
                  onPageTap: pagination!.onPageTap,
                  isLoading: false,
                  showBorder: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RoleList extends StatelessWidget {
  const _RoleList({
    required this.isLoading,
    required this.roleCodes,
    required this.selectedCodes,
    required this.lockedCodes,
    required this.emptyMessage,
    required this.itemIconPath,
    required this.onToggleItem,
    this.roleNames = const {},
    this.itemBuilder,
  });

  final bool isLoading;
  final List<String> roleCodes;
  final Map<String, String> roleNames;
  final Set<String> selectedCodes;
  final Set<String> lockedCodes;
  final String emptyMessage;
  final String itemIconPath;
  final ValueChanged<String> onToggleItem;
  final JobRoleSelectionRowBuilder? itemBuilder;

  static const _skeletonCount = 5;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _SkeletonList(itemIconPath: itemIconPath);
    if (roleCodes.isEmpty) return RolesManagementEmptyBody(message: emptyMessage);

    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: roleCodes.length,
      separatorBuilder: (_, _) => Gap(10.h),
      itemBuilder: (_, index) {
        final code = roleCodes[index];
        final isSelected = selectedCodes.contains(code);
        final isLocked = lockedCodes.contains(code);
        final onTap = isLocked ? null : () => onToggleItem(code);
        if (itemBuilder != null) {
          return itemBuilder!(code, isSelected, isLocked, onTap);
        }
        return CreateJobRoleSelectionItem(
          label: roleNames[code] ?? code,
          subtitle: roleNames.containsKey(code) ? code : null,
          isSelected: isSelected,
          isLocked: isLocked,
          iconPath: itemIconPath,
          onTap: onTap,
        );
      },
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList({required this.itemIconPath});

  final String itemIconPath;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _RoleList._skeletonCount,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, index) => CreateJobRoleSelectionItem(
          label: 'Skeleton Role Label $index',
          subtitle: 'SKELETON_CODE_$index',
          isSelected: false,
          isLocked: false,
          iconPath: itemIconPath,
          onTap: () {},
        ),
      ),
    );
  }
}

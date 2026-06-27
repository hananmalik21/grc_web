import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/widgets/create_duty_role_function_role_item.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_duty_role_dialog/widgets/create_duty_role_shared_widgets.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_selection_step.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateDutyRoleFunctionRolesStep extends StatelessWidget {
  const CreateDutyRoleFunctionRolesStep({
    super.key,
    required this.searchController,
    required this.searchHintText,
    required this.selectedTitle,
    required this.emptyMessage,
    required this.roleCodes,
    required this.selectedCodes,
    required this.onSearchChanged,
    required this.onToggleItem,
    this.roleNames = const {},
    this.lockedCodes = const {},
    this.isLoading = false,
    this.pagination,
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
  final bool isLoading;
  final SelectionPagination? pagination;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField.search(controller: searchController, hintText: searchHintText, onChanged: onSearchChanged),
        Gap(20.h),
        CreateDutyRoleSelectionSummaryBanner(title: selectedTitle, selectedCount: selectedCodes.length),
        Gap(18.h),
        SizedBox(
          height: 380.h,
          child: Column(
            children: [
              Expanded(
                child: _FunctionRoleList(
                  isLoading: isLoading,
                  roleCodes: roleCodes,
                  roleNames: roleNames,
                  selectedCodes: selectedCodes,
                  lockedCodes: lockedCodes,
                  emptyMessage: emptyMessage,
                  onToggleItem: onToggleItem,
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

class _FunctionRoleList extends StatelessWidget {
  const _FunctionRoleList({
    required this.isLoading,
    required this.roleCodes,
    required this.selectedCodes,
    required this.emptyMessage,
    required this.onToggleItem,
    this.roleNames = const {},
    this.lockedCodes = const {},
  });

  final bool isLoading;
  final List<String> roleCodes;
  final Map<String, String> roleNames;
  final Set<String> selectedCodes;
  final Set<String> lockedCodes;
  final String emptyMessage;
  final ValueChanged<String> onToggleItem;

  static const _skeletonCount = 5;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _SkeletonList();
    if (roleCodes.isEmpty) return RolesManagementEmptyBody(message: emptyMessage);

    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: roleCodes.length,
      separatorBuilder: (_, _) => Gap(10.h),
      itemBuilder: (_, index) {
        final code = roleCodes[index];
        return CreateDutyRoleFunctionRoleItem(
          label: roleNames[code] ?? code,
          subtitle: roleNames.containsKey(code) ? code : null,
          isSelected: selectedCodes.contains(code) || lockedCodes.contains(code),
          isLocked: lockedCodes.contains(code),
          onTap: () => onToggleItem(code),
        );
      },
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _FunctionRoleList._skeletonCount,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, index) => CreateDutyRoleFunctionRoleItem(
          label: 'Skeleton Role Label $index',
          subtitle: 'SKELETON_CODE_$index',
          isSelected: false,
          onTap: () {},
        ),
      ),
    );
  }
}

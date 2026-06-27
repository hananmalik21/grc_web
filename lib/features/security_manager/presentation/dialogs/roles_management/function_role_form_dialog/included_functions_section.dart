import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/domain/models/security_function.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog/widgets/security_function_list_summary.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/inherited_assignment_list_tile.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class IncludedFunctionsSection extends StatelessWidget {
  const IncludedFunctionsSection({
    super.key,
    required this.isLoading,
    required this.selectedCount,
    required this.searchController,
    required this.functions,
    required this.selectedGuids,
    this.inheritedFunctionGuids = const {},
    required this.onSearchChanged,
    required this.onFunctionToggle,
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
  final List<SecurityFunction> functions;
  final Set<String> selectedGuids;
  final Set<String> inheritedFunctionGuids;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFunctionToggle;
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
            Text('Included Functions', style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary)),
            Text(
              '($selectedCount selected)',
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        Gap(12.h),
        DigifyTextField.search(
          controller: searchController,
          hintText: 'Search by name, code or module...',
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
                      ? const _FunctionListSkeleton()
                      : functions.isEmpty
                      ? Center(
                          child: Text(
                            'No functions found.',
                            style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          itemCount: functions.length,
                          separatorBuilder: (_, _) => Gap(8.h),
                          itemBuilder: (context, index) {
                            final fn = functions[index];
                            final inherited = inheritedFunctionGuids.contains(fn.functionGuid);
                            return FunctionSelectionTile(
                              function: fn,
                              isSelected: selectedGuids.contains(fn.functionGuid),
                              isInherited: inherited,
                              onTap: inherited ? null : () => onFunctionToggle(fn.functionGuid),
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

class _FunctionListSkeleton extends StatelessWidget {
  const _FunctionListSkeleton();

  static const _count = 5;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _count,
        separatorBuilder: (_, _) => Gap(8.h),
        itemBuilder: (_, _) => const FunctionSelectionTile(
          function: skeletonSecurityFunction,
          isSelected: false,
          onTap: _noop,
          isInherited: false,
        ),
      ),
    );
  }
}

void _noop() {}

class FunctionSelectionTile extends StatelessWidget {
  const FunctionSelectionTile({
    super.key,
    required this.function,
    required this.isSelected,
    required this.onTap,
    this.isInherited = false,
  });

  final SecurityFunction function;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isInherited;

  @override
  Widget build(BuildContext context) {
    if (isInherited) {
      return InheritedAssignmentListTile(
        titleWidget: SecurityFunctionListSummary(function: function),
        gapAfterLock: 12,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.infoBg : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? AppColors.infoBorder : AppColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DigifyCheckbox(value: isSelected, onChanged: (_) => onTap?.call()),
            Gap(12.w),
            Expanded(child: SecurityFunctionListSummary(function: function)),
            if (function.functionType.isNotEmpty) _FunctionTypeBadge(type: function.functionType),
          ],
        ),
      ),
    );
  }
}

class _FunctionTypeBadge extends StatelessWidget {
  const _FunctionTypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        type,
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.textSecondary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class SetupGuidanceBanner extends StatelessWidget {
  const SetupGuidanceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: DigifyAsset(
              assetPath: Assets.icons.infoCircleBlue.path,
              width: 17,
              height: 17,
              color: AppColors.infoText,
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Setup Guidance',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.infoText,
                  ),
                ),
                Gap(4.h),
                Text(
                  'Keep the role focused on a single module and select only '
                  'the functions this role truly needs.',
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.roleActionBlue, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

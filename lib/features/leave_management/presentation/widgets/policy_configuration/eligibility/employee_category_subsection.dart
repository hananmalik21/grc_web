import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility/skeletons/employee_category_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeCategorySubsection extends ConsumerWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;
  final bool isEditing;

  const EmployeeCategorySubsection({
    super.key,
    required this.eligibility,
    required this.isDark,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupsAsync = ref.watch(policyConfigurationTabLookupsPreloadProvider);
    final values = ref.watch(policyConfigurationTabLookupValuesForCodeProvider(AbsLookupCode.empCategory));
    final selectedCodes = eligibility.employeeCategoryCodes;
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          EligibilitySubsectionHeader(
            title: 'Employee Category',
            iconPath: Assets.icons.leaveManagement.globe.path,
            isDark: isDark,
          ),
          Gap(12.h),
          lookupsAsync.when(
            data: (_) => _buildContent(values, selectedCodes, isEditing, draftNotifier),
            loading: () => const EmployeeCategorySkeleton(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    List<AbsLookupValue> items,
    List<String> selectedCodes,
    bool isEditing,
    PolicyDraftNotifier draftNotifier,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 10.w;
        final isCompact = constraints.maxWidth < 520.w;
        final itemWidth = isCompact ? constraints.maxWidth : (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: 10.h,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.72),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                  ),
                  child: DigifyCheckbox(
                    value: selectedCodes.contains(item.lookupValueCode),
                    onChanged: isEditing
                        ? (checked) => draftNotifier.toggleEmployeeCategoryCode(item.lookupValueCode, checked ?? false)
                        : null,
                    labelWidget: Text(
                      item.lookupValueName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

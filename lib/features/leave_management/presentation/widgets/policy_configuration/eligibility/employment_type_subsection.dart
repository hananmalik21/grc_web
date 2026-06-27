import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility/skeletons/employment_type_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmploymentTypeSubsection extends ConsumerWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;
  final bool isEditing;

  const EmploymentTypeSubsection({super.key, required this.eligibility, required this.isDark, required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupsAsync = ref.watch(policyConfigurationTabLookupsPreloadProvider);
    final values = ref.watch(policyConfigurationTabLookupValuesForCodeProvider(AbsLookupCode.empType));
    final selectedCodes = eligibility.employmentTypeCodes;
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
            title: 'Employment Type',
            iconPath: Assets.icons.workforce.totalPosition.path,
            isDark: isDark,
          ),
          Gap(12.h),
          lookupsAsync.when(
            data: (_) => _buildContent(values, selectedCodes, isEditing, draftNotifier),
            loading: () => const EmploymentTypeSkeleton(),
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

    final mid = (items.length / 2).ceil();
    final first = items.sublist(0, mid);
    final second = items.sublist(mid);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < first.length; i++) ...[
                if (i > 0) Gap(12.h),
                DigifyCheckbox(
                  value: selectedCodes.contains(first[i].lookupValueCode),
                  onChanged: isEditing
                      ? (checked) => draftNotifier.toggleEmploymentTypeCode(first[i].lookupValueCode, checked ?? false)
                      : null,
                  label: first[i].lookupValueName,
                ),
              ],
            ],
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < second.length; i++) ...[
                if (i > 0) Gap(12.h),
                DigifyCheckbox(
                  value: selectedCodes.contains(second[i].lookupValueCode),
                  onChanged: isEditing
                      ? (checked) => draftNotifier.toggleEmploymentTypeCode(second[i].lookupValueCode, checked ?? false)
                      : null,
                  label: second[i].lookupValueName,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:grc/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility/checkbox_group_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility/skeletons/gender_religion_marital_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GenderReligionMaritalSubsection extends ConsumerWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;
  final bool isEditing;

  const GenderReligionMaritalSubsection({
    super.key,
    required this.eligibility,
    required this.isDark,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupsAsync = ref.watch(policyConfigurationTabLookupsPreloadProvider);
    final genderValues = ref.watch(policyConfigurationTabLookupValuesForCodeProvider(AbsLookupCode.gender));
    final religionValues = ref.watch(policyConfigurationTabLookupValuesForCodeProvider(AbsLookupCode.religionCode));
    final maritalValues = ref.watch(policyConfigurationTabLookupValuesForCodeProvider(AbsLookupCode.maritalStatus));
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    final genderOptions = genderValues.map((v) => v.lookupValueName).toList();
    final religionOptions = religionValues.map((v) => v.lookupValueName).toList();
    final maritalOptions = maritalValues.map((v) => v.lookupValueName).toList();

    final genderSelected = _selectedNames(eligibility.genderCodes, genderValues);
    final religionSelected = _selectedNames(eligibility.religionCodes, religionValues);
    final maritalSelected = _selectedNames(eligibility.maritalStatusCodes, maritalValues);

    return lookupsAsync.when(
      data: (_) => _buildContent(
        genderOptions,
        religionOptions,
        maritalOptions,
        genderSelected,
        religionSelected,
        maritalSelected,
        genderValues,
        religionValues,
        maritalValues,
        draftNotifier,
      ),
      loading: () => GenderReligionMaritalSkeleton(isDark: isDark),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    List<String> genderOptions,
    List<String> religionOptions,
    List<String> maritalOptions,
    List<String> genderSelected,
    List<String> religionSelected,
    List<String> maritalSelected,
    List<AbsLookupValue> genderValues,
    List<AbsLookupValue> religionValues,
    List<AbsLookupValue> maritalValues,
    PolicyDraftNotifier draftNotifier,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final gender = CheckboxGroupCard(
          title: 'Gender',
          iconPath: Assets.icons.employeesBlueIcon.path,
          options: genderOptions,
          selectedValues: genderSelected,
          isDark: isDark,
          onToggle: isEditing
              ? (name, checked) => draftNotifier.toggleGenderCode(_codeForName(name, genderValues)!, checked)
              : null,
        );
        final religion = CheckboxGroupCard(
          title: 'Religion',
          iconPath: Assets.icons.leaveManagement.globe.path,
          options: religionOptions,
          selectedValues: religionSelected,
          isDark: isDark,
          onToggle: isEditing
              ? (name, checked) => draftNotifier.toggleReligionCode(_codeForName(name, religionValues)!, checked)
              : null,
        );
        final marital = CheckboxGroupCard(
          title: 'Marital Status',
          iconPath: Assets.icons.leaveManagement.martialStatus.path,
          options: maritalOptions,
          selectedValues: maritalSelected,
          isDark: isDark,
          onToggle: isEditing
              ? (name, checked) => draftNotifier.toggleMaritalStatusCode(_codeForName(name, maritalValues)!, checked)
              : null,
        );
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [gender, Gap(14.h), religion, Gap(14.h), marital],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: gender),
            Gap(14.w),
            Expanded(child: religion),
            Gap(14.w),
            Expanded(child: marital),
          ],
        );
      },
    );
  }

  List<String> _selectedNames(List<String> codes, List<AbsLookupValue> values) {
    return codes
        .map((code) => values.where((v) => v.lookupValueCode == code).firstOrNull?.lookupValueName)
        .whereType<String>()
        .toList();
  }

  static String? _codeForName(String? name, List<AbsLookupValue> values) {
    if (name == null || name.isEmpty) return null;
    final v = values.where((e) => e.lookupValueName == name).firstOrNull;
    return v?.lookupValueCode;
  }
}

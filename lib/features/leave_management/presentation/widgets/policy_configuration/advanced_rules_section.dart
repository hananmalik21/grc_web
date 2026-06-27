import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/days_and_notice_period_subsection.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/supporting_documentation_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/advanced_rules/weekend_holiday_checkboxes_subsection.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/skeletons/advanced_rules_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvancedRulesSection extends ConsumerWidget {
  final bool isDark;
  final AdvancedRules advanced;
  final bool isEditing;

  const AdvancedRulesSection({super.key, required this.isDark, required this.advanced, required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupsAsync = ref.watch(policyConfigurationTabLookupsPreloadProvider);

    return lookupsAsync.when(
      data: (_) => _buildContent(context),
      loading: () => AdvancedRulesSkeleton(isDark: isDark),
      error: (_, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Advanced Rules',
      iconPath: Assets.icons.leaveManagement.filter.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.h,
        children: [
          DaysAndNoticePeriodSubsection(advanced: advanced, isDark: isDark, isEditing: isEditing),
          WeekendHolidayCheckboxesSubsection(advanced: advanced, isEditing: isEditing),
          SupportingDocumentationCard(advanced: advanced, isDark: isDark, isEditing: isEditing),
        ],
      ),
    );
  }
}

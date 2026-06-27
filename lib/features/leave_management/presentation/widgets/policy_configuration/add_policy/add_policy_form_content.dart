import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/add_policy_basic_info_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/skeletons/add_policy_basic_info_skeleton.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/add_policy_carry_forward_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/add_policy_encashment_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/advanced_rules_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_criteria_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/forfeit_rules_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/grade_based_entitlements_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPolicyFormContent extends ConsumerWidget {
  const AddPolicyFormContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final draft = ref.watch(policyDraftProvider);
    final leaveTypesState = ref.watch(policyConfigurationTabLeaveTypesNotifierProvider);
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    if (draft == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref.read(policyDraftProvider.notifier).setDraft(PolicyDetail.empty());
      });
      return const SizedBox.shrink();
    }

    final leaveTypes = leaveTypesState.leaveTypes;
    final selectedLeaveType = draft.leaveTypeId > 0
        ? leaveTypes.where((t) => t.id == draft.leaveTypeId).firstOrNull
        : null;
    final config = draft.toConfiguration();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        if (leaveTypesState.isLoading)
          const AddPolicyBasicInfoSkeleton()
        else
          AddPolicyBasicInfoSection(
            policyName: draft.policyName ?? '',
            selectedLeaveType: selectedLeaveType,
            leaveTypes: leaveTypes,
            onPolicyNameChanged: draftNotifier.updatePolicyName,
            onLeaveTypeChanged: (t) {
              if (t != null) draftNotifier.updateLeaveType(t.id, t.nameEn, t.nameAr);
            },
          ),
        EligibilityCriteriaSection(isDark: isDark, eligibility: config.eligibilityCriteria, isEditing: true),
        GradeBasedEntitlementsSection(
          isDark: isDark,
          gradeRows: draft.gradeRows,
          effectiveStartDate: draft.effectiveStartDate,
          effectiveEndDate: draft.effectiveEndDate,
          enableProRata: draft.enableProRata,
          accrualMethodCode: draft.accrualMethod.code,
          isEditing: true,
        ),
        AdvancedRulesSection(isDark: isDark, advanced: config.advancedRules, isEditing: true),
        AddPolicyCarryForwardSection(isDark: isDark, carryForward: config.carryForwardRules, notifier: draftNotifier),
        ForfeitRulesSection(
          isDark: isDark,
          forfeit: config.forfeitRules,
          carryForwardLimit: config.carryForwardRules.carryForwardLimit,
          gracePeriod: config.carryForwardRules.gracePeriod,
          isEditing: true,
        ),
        AddPolicyEncashmentSection(isDark: isDark, encashment: config.encashmentRules, notifier: draftNotifier),
      ],
    );
  }
}

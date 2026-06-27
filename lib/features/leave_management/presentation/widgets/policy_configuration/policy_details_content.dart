import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/dto/abs_policies_dto.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_edit_mode_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/advanced_rules_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/carry_forward_rules_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_criteria_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/encashment_rules_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/forfeit_rules_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/grade_based_entitlements_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

const String _kUpdatedBy = 'ADMIN';

Future<void> _performSave(
  BuildContext context,
  WidgetRef ref,
  PolicyListItem policy,
  PolicyEditModeNotifier editNotifier,
) async {
  final detail = policy.detail;
  if (detail == null) return;

  final draft = ref.read(policyDraftProvider);
  final detailToSave = draft ?? detail;

  ref.read(policySaveInProgressProvider.notifier).state = true;
  try {
    final repo = ref.read(absPoliciesRepositoryProvider);
    final request = UpdatePolicyRequestDto.fromDetail(detailToSave, updatedBy: _kUpdatedBy);
    final updated = await repo.updatePolicy(policy.policyGuid, request);
    if (updated != null) {
      ref.read(policyConfigurationTabAbsPoliciesNotifierProvider.notifier).replacePolicyWith(updated);
      ref.read(policyDraftProvider.notifier).clear();
      editNotifier.saveChanges();
      if (context.mounted) {
        ToastService.success(context, 'Policy updated successfully');
      }
    }
  } catch (_) {
    if (context.mounted) {
      ToastService.error(context, 'Failed to update policy');
    }
  } finally {
    ref.read(policySaveInProgressProvider.notifier).state = false;
  }
}

class PolicyDetailsContent extends ConsumerWidget {
  final PolicyListItem? selectedPolicy;
  final bool isDark;

  const PolicyDetailsContent({super.key, required this.selectedPolicy, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(policyEditModeProvider);
    final isSaving = ref.watch(policySaveInProgressProvider);
    final editNotifier = ref.read(policyEditModeProvider.notifier);

    if (selectedPolicy == null) {
      return const Gap(0);
    }

    final detail = selectedPolicy!.detail;
    if (detail == null) {
      return _buildMessage(context, 'Policy details not available');
    }

    final draft = ref.watch(policyDraftProvider);
    final detailForDisplay = draft ?? detail;
    final config = detailForDisplay.toConfiguration();

    return Column(
      key: ValueKey(selectedPolicy!.policyGuid),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PolicyDetailsHeader(
          policyName: config.policyName,
          leaveTypeName: config.leaveTypeName,
          leaveTypeNameArabic: config.leaveTypeNameArabic,
          lastModified: config.lastModified,
          selectedBy: config.selectedBy,
          isDark: isDark,
          isEditing: isEditing,
          isSaving: isSaving,
          onEditPressed: () {
            ref.read(policyDraftProvider.notifier).setDraft(detail);
            editNotifier.startEditing();
          },
          onCancelPressed: () {
            ref.read(policyDraftProvider.notifier).clear();
            editNotifier.cancelEditing();
          },
          onSavePressed: () => _performSave(context, ref, selectedPolicy!, editNotifier),
        ),
        EligibilityCriteriaSection(isDark: isDark, eligibility: config.eligibilityCriteria, isEditing: isEditing),
        GradeBasedEntitlementsSection(
          isDark: isDark,
          gradeRows: detailForDisplay.gradeRows,
          effectiveStartDate: detailForDisplay.effectiveStartDate,
          effectiveEndDate: detailForDisplay.effectiveEndDate,
          enableProRata: detailForDisplay.enableProRata,
          accrualMethodCode: detailForDisplay.accrualMethod.code,
          isEditing: isEditing,
        ),
        AdvancedRulesSection(isDark: isDark, advanced: config.advancedRules, isEditing: isEditing),
        CarryForwardRulesSection(isDark: isDark, carryForward: config.carryForwardRules, isEditing: isEditing),
        ForfeitRulesSection(
          isDark: isDark,
          forfeit: config.forfeitRules,
          carryForwardLimit: config.carryForwardRules.carryForwardLimit,
          gracePeriod: config.carryForwardRules.gracePeriod,
          isEditing: isEditing,
        ),
        EncashmentRulesSection(isDark: isDark, encashment: config.encashmentRules, isEditing: isEditing),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: context.textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}

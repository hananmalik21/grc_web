import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_edit_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin PolicyConfigurationMobileLogicMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void clearSelection(WidgetRef ref) {
    ref.read(policyDraftProvider.notifier).clear();
    ref.read(policyEditModeProvider.notifier).cancelEditing();
    ref.read(policyConfigurationTabSelectedPolicyGuidProvider.notifier).setSelectedPolicyGuid(null);
  }

  Future<void> openPolicyDetails(BuildContext context, WidgetRef ref, PolicyListItem policy) async {
    clearSelection(ref);
    await openDetailsSheet(context, policy);
    clearSelection(ref);
  }

  Future<void> openDetailsSheet(BuildContext context, PolicyListItem policy);

  void goToPage(WidgetRef ref, int page) {
    final pagination = ref.read(policyConfigurationTabAbsPoliciesPaginationProvider);
    ref.read(policyConfigurationTabAbsPoliciesPaginationProvider.notifier).state = (
      page: page,
      pageSize: pagination.pageSize,
    );
  }

  void handleSelectedPolicyCleanup(WidgetRef ref, BuildContext context, PolicyListItem? selectedPolicy) {
    if (selectedPolicy != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          clearSelection(ref);
        }
      });
    }
  }
}

import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/add_policy_form_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddPolicyDialog extends ConsumerStatefulWidget {
  const AddPolicyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const AddPolicyDialog(),
    );
  }

  @override
  ConsumerState<AddPolicyDialog> createState() => _AddPolicyDialogState();
}

class _AddPolicyDialogState extends ConsumerState<AddPolicyDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(addPolicyDialogUiStateProvider.notifier).reset();
      ref.read(policyConfigurationTabLeaveTypesNotifierProvider.notifier).loadLeaveTypes();
    });
  }

  void _closeDialog() {
    ref.read(addPolicyDialogUiStateProvider.notifier).reset();
    context.pop();
  }

  Future<void> _onCreate(PolicyDetail? draft) async {
    final success = await ref.read(addPolicyCreateProvider).create(draft, context);
    if (success && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ProviderScope(
      overrides: <Override>[policyDraftProvider.overrideWith((ref) => PolicyDraftNotifier())],
      child: AppDialog(
        title: localizations.addNewPolicy,
        subtitle: localizations.policyConfigurationDescription,
        width: 850.w,
        content: const AddPolicyFormContent(),
        actions: [
          Consumer(
            builder: (context, formRef, _) {
              final draft = formRef.watch(policyDraftProvider);
              final uiState = formRef.watch(addPolicyDialogUiStateProvider);
              final isLoading = uiState.isLoading;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton.outline(label: localizations.cancel, onPressed: isLoading ? null : _closeDialog),
                  Gap(12.w),
                  AppButton.primary(
                    label: localizations.createNewPolicy,
                    onPressed: isLoading ? null : () => _onCreate(draft),
                    isLoading: isLoading,
                  ),
                ],
              );
            },
          ),
        ],
        onClose: _closeDialog,
      ),
    );
  }
}

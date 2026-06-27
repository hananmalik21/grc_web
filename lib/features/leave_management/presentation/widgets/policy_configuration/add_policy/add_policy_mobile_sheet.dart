import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/add_policy/add_policy_form_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPolicyMobileSheet {
  AddPolicyMobileSheet._();

  static Future<void> show(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: localizations.addNewPolicy,
      barrierDismissible: false,
      child: ProviderScope(
        overrides: [policyDraftProvider.overrideWith((ref) => PolicyDraftNotifier())],
        child: const _AddPolicySheetContent(),
      ),
    );
  }
}

class _AddPolicySheetContent extends ConsumerStatefulWidget {
  const _AddPolicySheetContent();

  @override
  ConsumerState<_AddPolicySheetContent> createState() => _AddPolicySheetContentState();
}

class _AddPolicySheetContentState extends ConsumerState<_AddPolicySheetContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(addPolicyDialogUiStateProvider.notifier).reset();
      ref.read(policyConfigurationTabLeaveTypesNotifierProvider.notifier).loadLeaveTypes();
    });
  }

  void _close() {
    ref.read(addPolicyDialogUiStateProvider.notifier).reset();
    Navigator.of(context).pop();
  }

  Future<void> _onCreate(PolicyDetail? draft) async {
    final success = await ref.read(addPolicyCreateProvider).create(draft, context);
    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final draft = ref.watch(policyDraftProvider);
    final uiState = ref.watch(addPolicyDialogUiStateProvider);
    final isLoading = uiState.isLoading;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8.h, bottom: 16.h),
            child: const AddPolicyFormContent(),
          ),
        ),
        _SheetActions(
          isDark: isDark,
          cancelLabel: localizations.cancel,
          createLabel: localizations.createNewPolicy,
          isLoading: isLoading,
          onCancel: isLoading ? null : _close,
          onCreate: isLoading ? null : () => _onCreate(draft),
        ),
      ],
    );
  }
}

class _SheetActions extends StatelessWidget {
  const _SheetActions({
    required this.isDark,
    required this.cancelLabel,
    required this.createLabel,
    required this.isLoading,
    required this.onCancel,
    required this.onCreate,
  });

  final bool isDark;
  final String cancelLabel;
  final String createLabel;
  final bool isLoading;
  final VoidCallback? onCancel;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ).copyWith(bottom: 12.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE5E7EB))),
      ),
      child: Row(
        spacing: 12.w,
        children: [
          Expanded(
            child: AppButton.outline(label: cancelLabel, onPressed: onCancel),
          ),
          Expanded(
            child: AppButton.primary(label: createLabel, onPressed: onCreate, isLoading: isLoading),
          ),
        ],
      ),
    );
  }
}

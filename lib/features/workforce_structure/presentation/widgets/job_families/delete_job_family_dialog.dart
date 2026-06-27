import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_delete_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteJobFamilyDialog extends ConsumerWidget {
  final JobFamily jobFamily;

  const DeleteJobFamilyDialog({super.key, required this.jobFamily});

  static Future<void> show(BuildContext context, {required JobFamily jobFamily}) {
    return showDialog(
      context: context,
      builder: (_) => DeleteJobFamilyDialog(jobFamily: jobFamily),
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    try {
      await ref.deleteJobFamily(id: jobFamily.id);

      if (context.mounted) {
        context.pop();
        ToastService.success(context, 'Job family deleted successfully', title: 'Deleted');
      }
    } catch (e) {
      if (context.mounted) {
        context.pop();
        ToastService.error(context, 'Failed to delete job family', title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(jobFamilyDeleteStateProvider);
    final isDeleting = deleteState.deletingId == jobFamily.id;
    final localizations = AppLocalizations.of(context);

    return AppConfirmationDialog.delete(
      title: localizations?.delete ?? 'Delete Job Family',
      message: 'Are you sure you want to delete this job family? This action cannot be undone.',
      itemName: jobFamily.nameEnglish,
      confirmLabel: localizations?.delete ?? 'Delete',
      cancelLabel: localizations?.cancel ?? 'Cancel',
      isLoading: isDeleting,
      onConfirm: () => _handleDelete(context, ref),
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}

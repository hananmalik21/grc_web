import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteWorkPatternDialog extends ConsumerStatefulWidget {
  final WorkPattern workPattern;
  final int enterpriseId;

  const DeleteWorkPatternDialog({super.key, required this.workPattern, required this.enterpriseId});

  static Future<bool?> show(BuildContext context, WorkPattern workPattern, int enterpriseId) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => DeleteWorkPatternDialog(workPattern: workPattern, enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<DeleteWorkPatternDialog> createState() => _DeleteWorkPatternDialogState();
}

class _DeleteWorkPatternDialogState extends ConsumerState<DeleteWorkPatternDialog> {
  bool _isDeleting = false;

  Future<void> _handleDelete() async {
    setState(() => _isDeleting = true);

    try {
      await ref
          .read(workPatternsNotifierProvider(widget.enterpriseId).notifier)
          .deleteWorkPattern(workPatternId: widget.workPattern.workPatternId, hard: true);

      if (mounted) {
        context.pop(true);
        ToastService.success(context, 'Work pattern deleted successfully', title: 'Deleted');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        ToastService.error(context, 'Failed to delete work pattern: ${e.toString()}', title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmationDialog.delete(
      title: 'Delete Work Pattern',
      message: 'Are you sure you want to delete this work pattern? This action cannot be undone.',
      itemName: widget.workPattern.patternNameEn,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isLoading: _isDeleting,
      onConfirm: _handleDelete,
      onCancel: () => context.pop(false),
    );
  }
}

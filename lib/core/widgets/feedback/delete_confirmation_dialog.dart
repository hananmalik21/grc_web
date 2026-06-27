import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.itemName,
    required this.onConfirm,
    this.onCancel,
    this.isLoading = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? itemName,
    String? confirmText,
    String? cancelText,
    bool isLoading = false,
  }) {
    final localizations = AppLocalizations.of(context);

    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: !isLoading,
      builder: (context) => AppConfirmationDialog.delete(
        title: title,
        message: message,
        itemName: itemName,
        confirmLabel: confirmText ?? localizations?.delete ?? 'Delete',
        cancelLabel: cancelText ?? localizations?.cancel ?? 'Cancel',
        isLoading: isLoading,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppConfirmationDialog.delete(
      title: title,
      message: message,
      itemName: itemName,
      confirmLabel: localizations?.delete ?? 'Delete',
      cancelLabel: localizations?.cancel ?? 'Cancel',
      onConfirm: onConfirm,
      onCancel: onCancel,
      isLoading: isLoading,
    );
  }
}

import 'package:grc/core/widgets/forms/digify_multi_select_dialog.dart';
import 'package:flutter/material.dart';

class ScopeBatchSelectionDialog<T> {
  static Future<List<String>?> show<T>({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<T> items,
    required List<String> selectedIds,
    required String Function(T item) idBuilder,
    required String Function(T item) labelBuilder,
    String searchHint = 'Search...',
    String emptyMessage = 'No items found',
    IconData headerIcon = Icons.fact_check_rounded,
    bool isLoading = false,
    String? errorMessage,
    VoidCallback? onRetry,
  }) {
    return DigifyMultiSelectDialog.show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      items: items,
      selectedIds: selectedIds,
      idBuilder: idBuilder,
      labelBuilder: labelBuilder,
      searchHint: searchHint,
      emptyMessage: emptyMessage,
      headerIcon: headerIcon,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onRetry: onRetry,
    );
  }
}

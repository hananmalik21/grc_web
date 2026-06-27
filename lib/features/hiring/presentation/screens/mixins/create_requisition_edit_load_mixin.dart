import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

mixin CreateRequisitionEditLoadMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  RequisitionTableRowData? get requisitionToEdit;
  RequisitionTableRowData? get requisitionToDuplicate => null;

  @override
  void initState() {
    super.initState();
    scheduleCreateRequisitionEditLoad();
  }

  void scheduleCreateRequisitionEditLoad() {
    final duplicateRow = requisitionToDuplicate;
    if (duplicateRow != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadCreateRequisitionForDuplicate(duplicateRow);
      });
      return;
    }

    final row = requisitionToEdit;
    if (row == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCreateRequisitionForEdit(row);
    });
  }

  Future<void> loadCreateRequisitionForEdit(RequisitionTableRowData row) async {
    final error = await ref.read(createRequisitionProvider.notifier).loadRequisitionForEdit(row);
    if (!mounted) return;
    if (error != null) {
      onCreateRequisitionEditLoadFailed(error);
    }
  }

  Future<void> loadCreateRequisitionForDuplicate(RequisitionTableRowData row) async {
    final error = await ref.read(createRequisitionProvider.notifier).loadRequisitionForDuplicate(row);
    if (!mounted) return;
    if (error != null) {
      onCreateRequisitionEditLoadFailed(error);
    }
  }

  void onCreateRequisitionEditLoadFailed(String message) {
    ToastService.error(context, message);
    context.pop();
  }

  bool get isEditingRequisition => requisitionToEdit != null;

  bool get isDuplicatingRequisition => requisitionToDuplicate != null;

  bool get showCreateRequisitionEditLoading {
    if (!isEditingRequisition && !isDuplicatingRequisition) return false;
    final state = ref.watch(createRequisitionProvider);
    return !state.isEditHydrated;
  }
}

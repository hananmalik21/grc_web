import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/delete_structure_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprise_stats_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/cascade_delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

int _orgUnitsCountFromConflict(ConflictException e) {
  if (e.details == null) return 0;
  final references = e.details!['references'] as Map<String, dynamic>?;
  if (references != null) {
    final summary = references['reference_summary'] as List?;
    if (summary != null && summary.isNotEmpty) {
      final first = summary[0] as Map<String, dynamic>?;
      final count = first?['count'] as int? ?? 0;
      if (count > 0) return count;
    }
  }
  return e.details!['org_units_count'] as int? ?? 0;
}

/// State for delete structure operation
class DeleteStructureState {
  final bool isDeleting;
  final bool isCascadeDeleting;
  final String? errorMessage;
  final bool hasError;

  const DeleteStructureState({
    this.isDeleting = false,
    this.isCascadeDeleting = false,
    this.errorMessage,
    this.hasError = false,
  });

  DeleteStructureState copyWith({bool? isDeleting, bool? isCascadeDeleting, String? errorMessage, bool? hasError}) {
    return DeleteStructureState(
      isDeleting: isDeleting ?? this.isDeleting,
      isCascadeDeleting: isCascadeDeleting ?? this.isCascadeDeleting,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// Notifier for delete structure operation
class DeleteStructureNotifier extends StateNotifier<DeleteStructureState> {
  DeleteStructureNotifier({required this.deleteStructureUseCase}) : super(const DeleteStructureState());

  final DeleteStructureUseCase deleteStructureUseCase;

  Future<void> runDeleteFlow(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String structureId,
    required AppLocalizations localizations,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider,
    required AutoDisposeStateNotifierProvider<DeleteStructureNotifier, DeleteStructureState> deleteStructureProvider,
  }) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Consumer(
        builder: (ctx, ref, _) {
          final state = ref.watch(deleteStructureProvider);
          final notifier = ref.read(deleteStructureProvider.notifier);
          return AppConfirmationDialog.delete(
            title: localizations.deleteStructureTitle,
            message: localizations.confirmDeleteStructure,
            itemName: title,
            confirmLabel: localizations.delete,
            cancelLabel: localizations.cancel,
            isLoading: state.isDeleting,
            onConfirm: () => notifier._onFirstConfirm(
              ctx,
              ref,
              structureId: structureId,
              title: title,
              localizations: localizations,
              structureListProvider: structureListProvider,
              deleteStructureProvider: deleteStructureProvider,
            ),
            onCancel: () {
              if (!state.isDeleting) ctx.pop(false);
            },
          );
        },
      ),
    );
  }

  Future<void> _onFirstConfirm(
    BuildContext context,
    WidgetRef ref, {
    required String structureId,
    required String title,
    required AppLocalizations localizations,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider,
    required AutoDisposeStateNotifierProvider<DeleteStructureNotifier, DeleteStructureState> deleteStructureProvider,
  }) async {
    state = state.copyWith(isDeleting: true, hasError: false, errorMessage: null);

    try {
      await deleteStructureUseCase(structureId: structureId, hard: true);
      state = state.copyWith(isDeleting: false);
      if (context.mounted) {
        context.pop(true);
        ToastService.success(context, localizations.structureDeletedSuccess);
        ref.read(structureListProvider.notifier).refresh();
        ref.read(enterpriseStatsNotifierProvider.notifier).refresh();
      }
    } on ConflictException catch (e) {
      state = state.copyWith(isDeleting: false);
      if (!context.mounted) return;
      context.pop(false);

      final orgUnitsCount = _orgUnitsCountFromConflict(e);
      await _showCascadeDialog(
        context,
        ref,
        deleteStructureProvider: deleteStructureProvider,
        structureId: structureId,
        title: title,
        orgUnitsCount: orgUnitsCount,
        errorMessage: e.message,
        localizations: localizations,
        structureListProvider: structureListProvider,
      );
    } on AppException catch (e) {
      state = state.copyWith(isDeleting: false, hasError: true, errorMessage: e.message);
      if (context.mounted) ToastService.error(context, e.message);
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        hasError: true,
        errorMessage: 'Failed to delete structure: ${e.toString()}',
      );
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete structure: ${e.toString()}');
      }
    }
  }

  Future<void> _showCascadeDialog(
    BuildContext context,
    WidgetRef ref, {
    required AutoDisposeStateNotifierProvider<DeleteStructureNotifier, DeleteStructureState> deleteStructureProvider,
    required String structureId,
    required String title,
    required int orgUnitsCount,
    required String errorMessage,
    required AppLocalizations localizations,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider,
  }) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (cascadeContext) => Consumer(
        builder: (ctx, ref, _) {
          final state = ref.watch(deleteStructureProvider);
          final notifier = ref.read(deleteStructureProvider.notifier);
          return CascadeDeleteConfirmationDialog(
            structureName: title,
            orgUnitsCount: orgUnitsCount,
            errorMessage: errorMessage,
            confirmLabel: localizations.deletePermanently,
            cancelLabel: localizations.cancel,
            isLoading: state.isCascadeDeleting,
            onConfirm: () => notifier._onCascadeConfirm(
              ctx,
              ref,
              structureId: structureId,
              localizations: localizations,
              structureListProvider: structureListProvider,
            ),
            onCancel: () {
              if (!state.isCascadeDeleting) ctx.pop(false);
            },
          );
        },
      ),
    );
  }

  Future<void> _onCascadeConfirm(
    BuildContext context,
    WidgetRef ref, {
    required String structureId,
    required AppLocalizations localizations,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider,
  }) async {
    state = state.copyWith(isCascadeDeleting: true);

    try {
      await deleteStructureUseCase(structureId: structureId, autoFallback: true);
      state = state.copyWith(isCascadeDeleting: false);
      if (context.mounted) {
        context.pop(true);
        ToastService.success(context, localizations.structureDeletedSuccess);
        ref.read(structureListProvider.notifier).refresh();
        ref.read(enterpriseStatsNotifierProvider.notifier).refresh();
      }
    } on AppException catch (e) {
      state = state.copyWith(isCascadeDeleting: false);
      if (context.mounted) ToastService.error(context, e.message);
    } catch (e) {
      state = state.copyWith(isCascadeDeleting: false);
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete structure: ${e.toString()}');
      }
    }
  }

  /// Delete structure (for one-off use without dialogs).
  Future<Map<String, dynamic>?> deleteStructure({
    required String structureId,
    bool hard = true,
    bool autoFallback = false,
  }) async {
    state = state.copyWith(isDeleting: true, hasError: false, errorMessage: null);

    try {
      final result = await deleteStructureUseCase(structureId: structureId, hard: hard, autoFallback: autoFallback);
      state = state.copyWith(isDeleting: false);
      return result;
    } on ConflictException catch (e) {
      state = state.copyWith(isDeleting: false, hasError: true, errorMessage: e.message);
      rethrow;
    } on AppException catch (e) {
      state = state.copyWith(isDeleting: false, hasError: true, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        hasError: true,
        errorMessage: 'Failed to delete structure: ${e.toString()}',
      );
      rethrow;
    }
  }

  void reset() {
    state = const DeleteStructureState();
  }
}

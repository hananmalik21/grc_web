import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprise_stats_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> handleStructureActivate(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String description,
  required String? structureId,
  required int? enterpriseId,
  required AppLocalizations localizations,
  required AutoDisposeStateNotifierProvider<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>
  saveEnterpriseStructureProvider,
  required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider,
}) async {
  if (structureId == null) {
    if (context.mounted) ToastService.error(context, 'Structure ID is required');
    return;
  }
  if (!context.mounted) return;

  final id = structureId;
  final saveNotifier = ref.read(saveEnterpriseStructureProvider.notifier);
  final listNotifier = ref.read(structureListProvider.notifier);
  final statsNotifier = ref.read(enterpriseStatsNotifierProvider.notifier);

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AppConfirmationDialog(
      title: localizations.activateStructureTitle,
      message: localizations.confirmActivateStructure,
      itemName: title,
      confirmLabel: localizations.activate,
      cancelLabel: localizations.cancel,
      type: ConfirmationType.success,
      onConfirm: () {
        dialogContext.pop();
        _runActivate(
          context: context,
          saveNotifier: saveNotifier,
          listNotifier: listNotifier,
          statsNotifier: statsNotifier,
          title: title,
          description: description,
          structureId: id,
          enterpriseId: enterpriseId,
        );
      },
      onCancel: () => dialogContext.pop(),
    ),
  );
}

Future<void> _runActivate({
  required BuildContext context,
  required SaveEnterpriseStructureNotifier saveNotifier,
  required StructureListNotifier listNotifier,
  required EnterpriseStatsNotifier statsNotifier,
  required String title,
  required String description,
  required String structureId,
  required int? enterpriseId,
}) async {
  try {
    await saveNotifier.saveStructure(
      structureName: title,
      description: description,
      levels: const [],
      enterpriseId: enterpriseId,
      isActive: true,
      structureId: structureId,
    );
    if (!context.mounted) return;
    ToastService.success(context, 'Structure activated successfully');
    listNotifier.setStructureActive(structureId, true);
    statsNotifier.refresh();
  } on AppException catch (e) {
    if (!context.mounted) return;
    ToastService.error(context, e.message);
  } catch (e) {
    if (!context.mounted) return;
    ToastService.error(context, 'Failed to activate structure: ${e.toString()}');
  }
}

import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> handleStructureDelete(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String? structureId,
  required AppLocalizations localizations,
  required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider,
}) async {
  if (structureId == null) {
    if (context.mounted) ToastService.error(context, 'Structure ID is required');
    return;
  }

  await ref
      .read(deleteStructureProvider.notifier)
      .runDeleteFlow(
        context,
        ref,
        title: title,
        structureId: structureId,
        localizations: localizations,
        structureListProvider: structureListProvider,
        deleteStructureProvider: deleteStructureProvider,
      );
}

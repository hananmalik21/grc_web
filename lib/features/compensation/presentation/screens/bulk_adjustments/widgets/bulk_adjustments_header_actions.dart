import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_metadata_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_table_selection_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulkAdjustmentsHeaderActions extends ConsumerWidget {
  const BulkAdjustmentsHeaderActions({required this.onCreatePressed, super.key});

  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isSubmitting = ref.watch(bulkAdjustmentsMetadataProvider.select((state) => state.isSubmitting));
    final hasSelection = ref.watch(bulkAdjustmentsTableSelectionProvider).isNotEmpty;

    return AppButton.primary(
      label: localizations.bulkAdjustmentsCreateAdjustment,
      isLoading: isSubmitting,
      svgPath: Assets.icons.addDivisionIcon.path,
      onPressed: hasSelection && !isSubmitting ? onCreatePressed : null,
    );
  }
}

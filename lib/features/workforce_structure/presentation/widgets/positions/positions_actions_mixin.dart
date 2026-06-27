import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/position_details_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/position_details_mobile_sheet.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/position_form_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin PositionsActionsMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void showPositionDetailsDialog(BuildContext context, Position position) {
    if (context.isMobileLayout) {
      DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.custom,
        title: AppLocalizations.of(context)!.positionDetails,
        child: PositionDetailsMobileSheet(
          position: position,
          onEdit: () => showPositionFormDialog(context, position, true),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => PositionDetailsDialog(position: position),
    );
  }

  void showPositionFormDialog(BuildContext context, Position position, bool isEdit) {
    PositionFormDialog.show(context, position: position, isEdit: isEdit);
  }

  Future<void> showDeleteConfirmation(Position position) async {
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.delete,
      message: 'Are you sure you want to delete this position? This action cannot be undone.',
      itemName: position.titleEnglish,
      confirmLabel: localizations.delete,
      cancelLabel: localizations.cancel,
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(positionNotifierProvider.notifier).deletePosition(position.id);
      if (!mounted) return;
      ToastService.success(context, 'Position deleted successfully', title: 'Deleted');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to delete position: ${e.toString()}', title: 'Error');
    }
  }
}

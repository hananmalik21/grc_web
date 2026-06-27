import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/create_requisition_edit_load_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_config.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_step_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateRequisitionMobileSheet extends ConsumerStatefulWidget {
  static const String routeName = 'createRequisitionMobileSheet';

  final RequisitionTableRowData? requisitionToEdit;
  final RequisitionTableRowData? requisitionToDuplicate;
  const CreateRequisitionMobileSheet({super.key, this.requisitionToEdit, this.requisitionToDuplicate});

  static Future<bool> show(
    BuildContext context, {
    RequisitionTableRowData? requisitionToEdit,
    RequisitionTableRowData? requisitionToDuplicate,
  }) async {
    final isEditing = requisitionToEdit != null;
    final isDuplicating = requisitionToDuplicate != null;
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: isEditing
          ? 'Edit Requisition'
          : isDuplicating
          ? 'Duplicate Requisition'
          : 'Create New Requisition',
      barrierDismissible: false,
      child: ProviderScope(
        overrides: [
          if (isEditing || isDuplicating) createRequisitionProvider.overrideWith(CreateRequisitionNotifier.new),
        ],
        child: CreateRequisitionMobileSheet(
          requisitionToEdit: requisitionToEdit,
          requisitionToDuplicate: requisitionToDuplicate,
        ),
      ),
    );
    return result == true;
  }

  @override
  ConsumerState<CreateRequisitionMobileSheet> createState() => _CreateRequisitionMobileSheetState();
}

class _CreateRequisitionMobileSheetState extends ConsumerState<CreateRequisitionMobileSheet>
    with CreateRequisitionEditLoadMixin<CreateRequisitionMobileSheet> {
  @override
  RequisitionTableRowData? get requisitionToEdit => widget.requisitionToEdit;

  @override
  RequisitionTableRowData? get requisitionToDuplicate => widget.requisitionToDuplicate;

  void _onNext(BuildContext context) {
    final notifier = ref.read(createRequisitionProvider.notifier);
    final error = notifier.tryGoNext();
    if (error != null) {
      ToastService.error(context, error);
    }
  }

  Future<void> _onSaveDraft(BuildContext context) async {
    final notifier = ref.read(createRequisitionProvider.notifier);
    final error = await notifier.saveDraftRequisition();
    if (!context.mounted) return;
    if (error != null) {
      ToastService.error(context, error);
      return;
    }

    ref.read(requisitionsTabRefreshTickProvider.notifier).state++;
    ToastService.success(context, AppLocalizations.of(context)!.draftSaved);
    context.pop(true);
  }

  Future<void> _onSave(BuildContext context) async {
    if (isEditingRequisition) {
      ToastService.error(context, 'Update requisition is not available yet');
      return;
    }

    final notifier = ref.read(createRequisitionProvider.notifier);
    final error = await notifier.submitRequisition();
    if (!context.mounted) return;
    if (error != null) {
      ToastService.error(context, error);
      return;
    }

    ref.read(requisitionsTabRefreshTickProvider.notifier).state++;
    ToastService.success(context, 'Requisition created successfully!');
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createRequisitionProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);
    final stepCount = CreateRequisitionConfig.steps.length;
    return DigifyStepperSheetContent(
      currentStep: state.currentStep,
      totalSteps: stepCount,
      stepLabel: CreateRequisitionConfig.steps[state.currentStep].label,
      isDark: context.isDark,
      canGoPrevious: state.currentStep > 0 && !showCreateRequisitionEditLoading,
      isLastStep: state.currentStep == stepCount - 1,
      isLoading: showCreateRequisitionEditLoading || state.isSubmitting,
      isSavingDraft: state.isSavingDraft,
      previousLabel: 'Back',
      nextLabel: 'Continue',
      saveLabel: isEditingRequisition ? 'Update Requisition' : 'Submit Requisition',
      saveDraftLabel: l10n.saveAsDraft,
      onPrevious: notifier.previousStep,
      onNext: () => _onNext(context),
      onSave: () async => _onSave(context),
      onSaveDraft: showCreateRequisitionEditLoading ? null : () => _onSaveDraft(context),
      body: showCreateRequisitionEditLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [AppLoadingIndicator(), Gap(4.h), Text('Loading requisition data...')],
            )
          : CreateRequisitionStepBody(currentStep: state.currentStep),
    );
  }
}

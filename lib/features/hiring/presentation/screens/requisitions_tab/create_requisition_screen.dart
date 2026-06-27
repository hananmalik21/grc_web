import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/create_requisition_edit_load_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_config.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_header.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_step_body.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateRequisitionScreen extends StatelessWidget {
  static const String routeName = 'hiring-requisition-create';
  static const String editRouteName = 'hiring-requisition-edit';
  static const String duplicateRouteName = 'hiring-requisition-duplicate';

  final RequisitionTableRowData? requisitionToEdit;
  final RequisitionTableRowData? requisitionToDuplicate;

  const CreateRequisitionScreen({super.key, this.requisitionToEdit, this.requisitionToDuplicate});

  @override
  Widget build(BuildContext context) {
    final needsFreshProvider = requisitionToEdit != null || requisitionToDuplicate != null;
    return ProviderScope(
      overrides: [if (needsFreshProvider) createRequisitionProvider.overrideWith(CreateRequisitionNotifier.new)],
      child: _CreateRequisitionScreenBody(
        requisitionToEdit: requisitionToEdit,
        requisitionToDuplicate: requisitionToDuplicate,
      ),
    );
  }
}

class _CreateRequisitionScreenBody extends ConsumerStatefulWidget {
  final RequisitionTableRowData? requisitionToEdit;
  final RequisitionTableRowData? requisitionToDuplicate;
  const _CreateRequisitionScreenBody({this.requisitionToEdit, this.requisitionToDuplicate});

  @override
  ConsumerState<_CreateRequisitionScreenBody> createState() => _CreateRequisitionScreenBodyState();
}

class _CreateRequisitionScreenBodyState extends ConsumerState<_CreateRequisitionScreenBody>
    with CreateRequisitionEditLoadMixin<_CreateRequisitionScreenBody> {
  @override
  RequisitionTableRowData? get requisitionToEdit => widget.requisitionToEdit;

  @override
  RequisitionTableRowData? get requisitionToDuplicate => widget.requisitionToDuplicate;

  String _localizedValidationMessage(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    if (message == 'Organization unit is required') {
      return l10n.hiringCreateRequisitionOrgUnitRequired;
    }
    return message;
  }

  Future<void> _onSaveDraft() async {
    final notifier = ref.read(createRequisitionProvider.notifier);
    final error = await notifier.saveDraftRequisition();
    if (!mounted) return;
    if (error != null) {
      ToastService.error(context, error);
      return;
    }

    ref.read(requisitionsTabRefreshTickProvider.notifier).state++;
    ToastService.success(context, AppLocalizations.of(context)!.draftSaved);
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(createRequisitionProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);
    final isLastStep = state.currentStep == CreateRequisitionConfig.steps.length - 1;
    final canGoBack = state.currentStep > 0;
    if (showCreateRequisitionEditLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [AppLoadingIndicator(), Gap(4.h), Text('Loading requisition data...')],
      );
    }

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreateRequisitionHeader(
              title: isEditingRequisition ? 'Edit Requisition' : 'Create New Requisition',
              description: isEditingRequisition
                  ? 'Update the details of this job requisition'
                  : 'Create a new comprehensive job requisition',
              submitLabel: isEditingRequisition ? 'Update Requisition' : 'Create Requisition',
              canGoBack: canGoBack,
              isLastStep: isLastStep,
              isSubmitting: state.isSubmitting,
              isSavingDraft: state.isSavingDraft,
              onBack: notifier.previousStep,
              onCancel: () => context.pop(),
              onSaveDraft: showCreateRequisitionEditLoading ? null : _onSaveDraft,
              onContinue: () async {
                if (!isLastStep) {
                  final error = notifier.tryGoNext();
                  if (error != null) {
                    ToastService.error(context, _localizedValidationMessage(context, error));
                  }
                  return;
                }

                if (isEditingRequisition) {
                  ToastService.error(context, 'Update requisition is not available yet');
                  return;
                }

                final error = await notifier.submitRequisition();
                if (!context.mounted) return;
                if (error != null) {
                  ToastService.error(context, _localizedValidationMessage(context, error));
                  return;
                }

                ref.read(requisitionsTabRefreshTickProvider.notifier).state++;
                ToastService.success(context, 'Requisition created successfully!');
                context.pop(true);
              },
            ),
            Gap(24.h),
            CreateRequisitionStepper(currentStep: state.currentStep),
            Gap(24.h),
            CreateRequisitionStepBody(currentStep: state.currentStep),
            Gap(48.h),
          ],
        ),
      ),
    );
  }
}

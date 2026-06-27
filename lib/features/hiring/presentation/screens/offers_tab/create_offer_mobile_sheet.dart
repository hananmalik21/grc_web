import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/hiring/application/offers/providers/create_offer_compensation_providers.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_compensation_validation.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_config.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_step_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferMobileSheet extends ConsumerWidget {
  const CreateOfferMobileSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    container.read(createOfferProvider.notifier).reset();
    container.read(createOfferCompensationProvider.notifier).reset();

    final l10n = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: l10n.createOffer,
      barrierDismissible: false,
      child: const CreateOfferMobileSheet(),
    );
  }

  void _onNext(BuildContext context, WidgetRef ref) {
    final state = ref.read(createOfferProvider);
    final compensationError = state.currentStep == 1 ? ref.validateCreateOfferCompensationStep() : null;
    final error = ref.read(createOfferProvider.notifier).tryGoNext(compensationStepError: compensationError);
    if (error != null) ToastService.error(context, error);
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final compensationError = ref.validateCreateOfferCompensationStep();
    final result = await ref
        .read(createOfferProvider.notifier)
        .submit(compensationState: ref.read(createOfferCompensationProvider), compensationStepError: compensationError);
    if (!context.mounted) return;

    if (!result.success) {
      ToastService.error(context, result.message ?? 'Failed to create job offer');
      return;
    }

    ToastService.success(context, result.message ?? 'Offer created successfully!');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createOfferProvider);
    final notifier = ref.read(createOfferProvider.notifier);
    final stepCount = CreateOfferConfig.steps.length;

    return DigifyStepperSheetContent(
      currentStep: state.currentStep,
      totalSteps: stepCount,
      stepLabel: CreateOfferConfig.steps[state.currentStep].label,
      isDark: context.isDark,
      canGoPrevious: state.currentStep > 0,
      isLastStep: state.currentStep == stepCount - 1,
      isLoading: state.isSubmitting,
      previousLabel: l10n.previous,
      nextLabel: l10n.next,
      saveLabel: l10n.createOffer,
      onPrevious: notifier.previousStep,
      onNext: () => _onNext(context, ref),
      onSave: () => _onSave(context, ref),
      body: CreateOfferStepBody(currentStep: state.currentStep),
    );
  }
}

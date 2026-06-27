import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/application/offers/providers/create_offer_compensation_providers.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_compensation_validation.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_config.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_header.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_step_body.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateOfferScreen extends StatelessWidget {
  static const String routeName = 'hiring-offer-create';

  const CreateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateOfferScreenBody();
  }
}

class _CreateOfferScreenBody extends ConsumerStatefulWidget {
  const _CreateOfferScreenBody();

  @override
  ConsumerState<_CreateOfferScreenBody> createState() => _CreateOfferScreenBodyState();
}

class _CreateOfferScreenBodyState extends ConsumerState<_CreateOfferScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(createOfferProvider.notifier).reset();
      ref.read(createOfferCompensationProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(createOfferProvider);
    final notifier = ref.read(createOfferProvider.notifier);
    final isLastStep = state.currentStep == CreateOfferConfig.steps.length - 1;
    final canGoBack = state.currentStep > 0;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreateOfferHeader(
              title: 'Create Comprehensive Job Offer',
              description: 'Generate a detailed offer letter with complete compensation package',
              submitLabel: 'Create Comprehensive Job Offer',
              canGoBack: canGoBack,
              isLastStep: isLastStep,
              isSubmitting: state.isSubmitting,
              onBack: notifier.previousStep,
              onCancel: () => context.pop(),
              onContinue: () async {
                if (!isLastStep) {
                  final compensationError = state.currentStep == 1 ? ref.validateCreateOfferCompensationStep() : null;
                  final error = notifier.tryGoNext(compensationStepError: compensationError);
                  if (error != null) {
                    ToastService.error(context, error);
                  }
                  return;
                }

                final compensationError = ref.validateCreateOfferCompensationStep();
                final result = await notifier.submit(
                  compensationState: ref.read(createOfferCompensationProvider),
                  compensationStepError: compensationError,
                );
                if (!context.mounted) return;

                if (!result.success) {
                  ToastService.error(context, result.message ?? 'Failed to create job offer');
                  return;
                }

                ToastService.success(context, result.message ?? 'Offer created successfully!');
                context.pop(true);
              },
            ),
            Gap(24.h),
            CreateOfferStepper(currentStep: state.currentStep),
            Gap(24.h),
            CreateOfferStepBody(currentStep: state.currentStep),
            Gap(48.h),
          ],
        ),
      ),
    );
  }
}

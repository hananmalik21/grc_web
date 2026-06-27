import 'package:flutter/material.dart';
import 'create_offer_basic_details_step.dart';
import 'create_offer_compensation_step.dart';
import 'create_offer_benefits_step.dart';
import 'create_offer_terms_conditions_step.dart';

class CreateOfferStepBody extends StatelessWidget {
  final int currentStep;

  const CreateOfferStepBody({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return const CreateOfferBasicDetailsStep();
      case 1:
        return const CreateOfferCompensationStep();
      case 2:
        return const CreateOfferBenefitsStep();
      case 3:
        return const CreateOfferTermsConditionsStep();
      default:
        return const SizedBox.shrink();
    }
  }
}

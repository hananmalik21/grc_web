import 'package:grc/features/hiring/application/offers/providers/create_offer_compensation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension CreateOfferCompensationValidation on WidgetRef {
  String? validateCreateOfferCompensationStep() {
    final compensationNotifier = read(createOfferCompensationProvider.notifier);
    if (!compensationNotifier.validate(skipEffectiveDateValidation: true)) {
      return read(createOfferCompensationProvider).errorMessage ?? 'Compensation details are incomplete';
    }
    return null;
  }
}

import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/hiring/application/offers/controllers/create_offer_compensation_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:grc/features/hiring/application/offers/providers/create_offer_eligible_plans_request_provider.dart';

final createOfferCompensationProvider = NotifierProvider<CompensationPlansSelectionNotifier, AddCompensationPlansState>(
  CreateOfferCompensationController.new,
);

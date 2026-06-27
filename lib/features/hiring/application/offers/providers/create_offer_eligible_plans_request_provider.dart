import 'package:grc/features/hiring/application/offers/controllers/create_offer_provider.dart';
import 'package:grc/features/hiring/application/offers/providers/offers_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferEligiblePlansRequest {
  final String positionId;
  final int enterpriseId;

  const CreateOfferEligiblePlansRequest({required this.positionId, required this.enterpriseId});
}

final createOfferEligiblePlansRequestProvider = Provider<CreateOfferEligiblePlansRequest?>((ref) {
  final enterpriseId = ref.watch(offersTabEnterpriseIdProvider);
  final positionId = ref.watch(createOfferProvider.select((s) => s.selectedPosition?.id.trim()));

  if (enterpriseId == null || positionId == null || positionId.isEmpty) {
    return null;
  }

  return CreateOfferEligiblePlansRequest(positionId: positionId, enterpriseId: enterpriseId);
});

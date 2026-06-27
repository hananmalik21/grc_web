import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_common_providers.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/hiring/application/offers/controllers/create_offer_provider.dart';
import 'package:grc/features/hiring/application/offers/providers/create_offer_eligible_plans_request_provider.dart';

class CreateOfferCompensationController extends CompensationPlansSelectionNotifier {
  @override
  AddCompensationPlansState build() {
    ref.listen(createOfferEligiblePlansRequestProvider, (previous, next) {
      if (next != null) {
        fetchEligiblePlansByPosition(next);
      } else {
        clearEligiblePlans();
      }
    });

    final request = ref.read(createOfferEligiblePlansRequestProvider);
    if (request != null) {
      Future.microtask(() => fetchEligiblePlansByPosition(request));
    }

    return _initialState();
  }

  @override
  AddCompensationPlansState initialState() => _initialState();

  AddCompensationPlansState _initialState() {
    return const AddCompensationPlansState(selectedCurrency: 'USD');
  }

  @override
  (double?, double?) budgetRange() {
    final position = ref.read(createOfferProvider).selectedPosition;
    if (position == null) return (null, null);
    return (
      CompensationPlansSelectionNotifier.parseBudget(position.budgetedMin),
      CompensationPlansSelectionNotifier.parseBudget(position.budgetedMax),
    );
  }

  @override
  DateTime? resolvedEffectiveStartDate() => null;

  Future<void> fetchEligiblePlansByPosition(CreateOfferEligiblePlansRequest request) async {
    final requestId = ++latestRequestId;
    state = state.copyWith(
      isEligiblePlansLoading: true,
      clearError: true,
      eligiblePlans: [],
      addedPlans: [],
      clearSelectedPlan: true,
    );

    try {
      final useCase = ref.read(getEligiblePlansByPositionUseCaseProvider);
      final plans = await useCase(positionId: request.positionId, enterpriseId: request.enterpriseId);

      if (requestId != latestRequestId) return;
      applyFetchedPlans(plans);
    } catch (e) {
      if (requestId != latestRequestId) return;
      state = state.copyWith(isEligiblePlansLoading: false, errorMessage: e.toString());
    }
  }
}

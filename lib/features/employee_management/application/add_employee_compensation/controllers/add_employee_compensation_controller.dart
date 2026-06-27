import 'package:grc/features/compensation/domain/models/compensation_plans/eligible_plans_criteria.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_common_providers.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/employee_management/application/add_employee_compensation/providers/add_employee_compensation_context_providers.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';

class AddEmployeeCompensationController extends CompensationPlansSelectionNotifier {
  @override
  AddCompensationPlansState build() {
    ref.listen(addEmployeeEligiblePlansCriteriaProvider, (previous, next) {
      if (next != null) {
        fetchEligiblePlansByCriteria(next);
      } else {
        clearEligiblePlans();
      }
    });

    ref.listen(addEmployeeAssignmentProvider.select((s) => s.asgStart), (_, next) {
      _syncEffectiveDateFromAssignment(next);
    });

    final criteria = ref.read(addEmployeeEligiblePlansCriteriaProvider);
    if (criteria != null) {
      Future.microtask(() => fetchEligiblePlansByCriteria(criteria));
    }

    return _initialState();
  }

  @override
  AddCompensationPlansState initialState() => _initialState();

  AddCompensationPlansState _initialState() {
    final asgStart = ref.read(addEmployeeAssignmentProvider).asgStart;
    return AddCompensationPlansState(effectiveDate: asgStart, endDate: null, selectedCurrency: 'USD');
  }

  void _syncEffectiveDateFromAssignment(DateTime? asgStart) {
    if (asgStart == null) return;
    setEffectiveDate(asgStart);
  }

  @override
  void setEffectiveDate(DateTime date) {
    final asgStart = ref.read(addEmployeeAssignmentProvider).asgStart;
    super.setEffectiveDate(asgStart ?? date);
  }

  @override
  (double?, double?) budgetRange() {
    final position = ref.read(addEmployeeJobEmploymentProvider).selectedPosition;
    if (position == null) return (null, null);
    return (
      CompensationPlansSelectionNotifier.parseBudget(position.budgetedMin),
      CompensationPlansSelectionNotifier.parseBudget(position.budgetedMax),
    );
  }

  @override
  DateTime? resolvedEffectiveStartDate() {
    return ref.read(addEmployeeAssignmentProvider).asgStart ??
        ref.read(addEmployeeJobEmploymentProvider).enterpriseHireDate;
  }

  Future<void> fetchEligiblePlansByCriteria(EligiblePlansCriteria criteria) async {
    final requestId = ++latestRequestId;
    state = state.copyWith(
      isEligiblePlansLoading: true,
      clearError: true,
      eligiblePlans: [],
      addedPlans: [],
      clearSelectedPlan: true,
    );

    try {
      final useCase = ref.read(getEligiblePlansByCriteriaUseCaseProvider);
      final plans = await useCase(criteria: criteria);

      if (requestId != latestRequestId) return;
      applyFetchedPlans(plans);
    } catch (e) {
      if (requestId != latestRequestId) return;
      state = state.copyWith(isEligiblePlansLoading: false, errorMessage: e.toString());
    }
  }
}

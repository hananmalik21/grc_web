import 'package:grc/features/employee_management/domain/models/create_employee_compensation_component.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/domain/models/employee_compensation/create_employee_compensation_request.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_common_providers.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/employee_details_provider.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/compensation_plans_selection_notifier.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/employees/employee_compensation_list_provider.dart';
import 'package:grc/features/compensation/presentation/providers/employees/compensation_employees_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

export 'package:grc/features/compensation/presentation/providers/create_employee_compensation/compensation_plans_selection_notifier.dart';

class AddCompensationPlansState {
  final DateTime? effectiveDate;
  final DateTime? endDate;

  final Map<int, Map<int, double>> componentAmounts;
  final String selectedCurrency;
  final bool isEligiblePlansLoading;
  final bool isCreating;
  final List<CompensationPlan> eligiblePlans;
  final CompensationPlan? selectedPlan;
  final List<CompensationPlan> addedPlans;
  final String? errorMessage;
  final bool success;

  int get activePlansCount => addedPlans.length;

  static bool planHasEarningComponent(CompensationPlan plan) {
    return (plan.components ?? <PlanComponent>[]).any(
      (comp) => (comp.component?.categoryCode ?? '').trim().toUpperCase() == 'EARNING',
    );
  }

  static List<CompensationPlan> sortAddedPlansWithEarningFirst(List<CompensationPlan> plans) {
    final earningPlans = <CompensationPlan>[];
    final otherPlans = <CompensationPlan>[];
    for (final plan in plans) {
      if (planHasEarningComponent(plan)) {
        earningPlans.add(plan);
      } else {
        otherPlans.add(plan);
      }
    }
    return [...earningPlans, ...otherPlans];
  }

  List<CompensationPlan> get addedPlansWithEarningFirst => sortAddedPlansWithEarningFirst(addedPlans);

  List<PlanComponent> effectiveComponentsForPlan(CompensationPlan plan) {
    final seenCodes = <String>{};
    for (final p in addedPlans) {
      if (p.planId == plan.planId) break;
      for (final comp in p.components ?? <PlanComponent>[]) {
        final code = (comp.component?.code ?? '').toUpperCase();
        if (code.isNotEmpty) seenCodes.add(code);
      }
    }
    return (plan.components ?? <PlanComponent>[]).where((comp) {
      final code = (comp.component?.code ?? '').toUpperCase();
      return code.isEmpty || !seenCodes.contains(code);
    }).toList();
  }

  Map<String, List<PlanComponent>> groupedEffectiveComponentsForPlan(CompensationPlan plan) {
    final grouped = <String, List<PlanComponent>>{};
    for (final comp in effectiveComponentsForPlan(plan)) {
      final raw = comp.component?.categoryCode ?? '';
      final type = raw.trim().isNotEmpty ? raw.trim().toUpperCase() : 'OTHER';
      grouped.putIfAbsent(type, () => []).add(comp);
    }

    for (final components in grouped.values) {
      components.sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
    }

    final ordered = <String, List<PlanComponent>>{};
    if (grouped.containsKey('EARNING')) {
      ordered['EARNING'] = grouped['EARNING']!;
    }
    for (final key in grouped.keys) {
      if (key != 'EARNING') ordered[key] = grouped[key]!;
    }
    return ordered;
  }

  double amountFor(int planId, int componentId) => componentAmounts[planId]?[componentId] ?? 0.0;

  double get grossTotal {
    var total = 0.0;
    final seenCodes = <String>{};
    for (final plan in addedPlans) {
      final planAmounts = componentAmounts[plan.planId] ?? {};
      for (final comp in plan.components ?? <PlanComponent>[]) {
        final code = (comp.component?.code ?? '').toUpperCase();
        if (code.isNotEmpty && !seenCodes.add(code)) continue;
        total += planAmounts[comp.componentId] ?? 0.0;
      }
    }
    return total;
  }

  List<CreateEmployeeCompensationComponent> toCreateEmployeeCompensationComponents({
    DateTime? effectiveStartOverride,
    bool includeEffectiveEndDate = true,
  }) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final start = effectiveStartOverride ?? effectiveDate;
    final startDate = start != null ? dateFormat.format(start) : '';
    final endDateStr = includeEffectiveEndDate && endDate != null ? dateFormat.format(endDate!) : null;

    return [
      for (final plan in addedPlans)
        for (final comp in effectiveComponentsForPlan(plan))
          CreateEmployeeCompensationComponent(
            planId: plan.planId,
            componentId: comp.componentId,
            amount: amountFor(plan.planId, comp.componentId),
            currencyCode: selectedCurrency,
            effectiveStartDate: startDate,
            effectiveEndDate: endDateStr,
            activeFlag: 'Y',
          ),
    ];
  }

  Map<String, double> get componentTotalsByType {
    final totals = <String, double>{};
    final seenCodes = <String>{};
    for (final plan in addedPlans) {
      final planAmounts = componentAmounts[plan.planId] ?? {};
      for (final comp in plan.components ?? <PlanComponent>[]) {
        final code = (comp.component?.code ?? '').toUpperCase();
        if (code.isNotEmpty && !seenCodes.add(code)) continue;
        final categoryCode = comp.component?.categoryCode ?? '';
        final type = categoryCode.isNotEmpty ? categoryCode.toUpperCase() : 'OTHER';
        totals[type] = (totals[type] ?? 0.0) + (planAmounts[comp.componentId] ?? 0.0);
      }
    }

    final ordered = <String, double>{};
    if (totals.containsKey('EARNING')) {
      ordered['EARNING'] = totals['EARNING']!;
    }
    for (final key in totals.keys) {
      if (key != 'EARNING') ordered[key] = totals[key]!;
    }
    return ordered;
  }

  const AddCompensationPlansState({
    this.effectiveDate,
    this.endDate,
    this.componentAmounts = const {},
    required this.selectedCurrency,
    this.isEligiblePlansLoading = false,
    this.isCreating = false,
    this.eligiblePlans = const [],
    this.selectedPlan,
    this.addedPlans = const [],
    this.errorMessage,
    this.success = false,
  });

  AddCompensationPlansState copyWith({
    DateTime? effectiveDate,
    DateTime? endDate,
    Map<int, Map<int, double>>? componentAmounts,
    String? selectedCurrency,
    bool? isEligiblePlansLoading,
    bool? isCreating,
    List<CompensationPlan>? eligiblePlans,
    CompensationPlan? selectedPlan,
    bool clearSelectedPlan = false,
    List<CompensationPlan>? addedPlans,
    String? errorMessage,
    bool? success,
    bool clearError = false,
  }) {
    return AddCompensationPlansState(
      effectiveDate: effectiveDate ?? this.effectiveDate,
      endDate: endDate ?? this.endDate,
      componentAmounts: componentAmounts ?? this.componentAmounts,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isEligiblePlansLoading: isEligiblePlansLoading ?? this.isEligiblePlansLoading,
      isCreating: isCreating ?? this.isCreating,
      eligiblePlans: eligiblePlans ?? this.eligiblePlans,
      selectedPlan: clearSelectedPlan ? null : (selectedPlan ?? this.selectedPlan),
      addedPlans: addedPlans ?? this.addedPlans,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      success: success ?? this.success,
    );
  }
}

class AddCompensationPlansNotifier extends CompensationPlansSelectionNotifier {
  @override
  AddCompensationPlansState build() {
    ref.listen(employeeCompensationDetailsProvider.select((s) => s.selectedEmployee), (previous, next) {
      if (next != null) {
        fetchEligiblePlansForEmployee(next.guid);
      } else {
        clearEligiblePlans();
      }
    });

    return const AddCompensationPlansState(effectiveDate: null, endDate: null, selectedCurrency: 'USD');
  }

  @override
  AddCompensationPlansState initialState() {
    return const AddCompensationPlansState(effectiveDate: null, endDate: null, selectedCurrency: 'USD');
  }

  @override
  (double?, double?) budgetRange() {
    final empDetails = ref.read(employeeCompensationDetailsProvider);
    return (empDetails.budgetedMinKd, empDetails.budgetedMaxKd);
  }

  @override
  DateTime? resolvedEffectiveStartDate() {
    if (state.effectiveDate != null) return state.effectiveDate;
    return ref.read(employeeCompensationDetailsProvider).enterpriseHireDate;
  }

  Future<void> fetchEligiblePlansForEmployee(String employeeGuid) async {
    final requestId = ++latestRequestId;
    state = state.copyWith(
      isEligiblePlansLoading: true,
      clearError: true,
      eligiblePlans: [],
      addedPlans: [],
      clearSelectedPlan: true,
    );

    try {
      final useCase = ref.read(getEligiblePlansForEmployeeUseCaseProvider);
      final plans = await useCase(employeeGuid: employeeGuid);

      if (requestId != latestRequestId) return;
      applyFetchedPlans(plans);
    } catch (e) {
      if (requestId != latestRequestId) return;
      state = state.copyWith(isEligiblePlansLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> createEmployeeCompensation() async {
    final selectedEmployee = ref.read(employeeCompensationDetailsProvider).selectedEmployee;
    final enterpriseId = ref.read(compensationEmployeeTabEnterpriseIdProvider);

    if (selectedEmployee == null || enterpriseId == null) {
      state = state.copyWith(errorMessage: 'Employee or Enterprise missing');
      return;
    }

    if (!validate()) {
      return;
    }

    state = state.copyWith(isCreating: true, clearError: true, success: false);

    try {
      final dateFormat = DateFormat('yyyy-MM-dd');

      final components = [
        for (final plan in state.addedPlans)
          for (final c in state.effectiveComponentsForPlan(plan))
            EmployeeCompensationComponentRequest(
              planId: plan.planId,
              componentId: c.componentId,
              amount: state.amountFor(plan.planId, c.componentId),
              effectiveStartDate: state.effectiveDate != null ? dateFormat.format(state.effectiveDate!) : '',
              effectiveEndDate: state.endDate != null ? dateFormat.format(state.endDate!) : '',
              currencyCode: state.selectedCurrency,
              activeFlag: 'Y',
            ),
      ];

      final request = CreateEmployeeCompensationRequest(
        enterpriseId: enterpriseId,
        employeeId: selectedEmployee.id,
        createdBy: 'SYSTEM',
        components: components,
      );

      final useCase = ref.read(createEmployeeCompensationUseCaseProvider);
      await useCase(request: request);

      state = state.copyWith(isCreating: false, success: true);

      ref.read(compensationEmployeesActionsProvider.notifier).loadInitial();
      ref.read(employeeCompensationListActionsProvider.notifier).refresh();
    } catch (e) {
      state = state.copyWith(isCreating: false, errorMessage: e.toString());
    }
  }
}

final addCompensationPlansProvider = NotifierProvider<CompensationPlansSelectionNotifier, AddCompensationPlansState>(
  AddCompensationPlansNotifier.new,
);

import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef CompensationPlansSelectionNotifierProvider =
    NotifierProvider<CompensationPlansSelectionNotifier, AddCompensationPlansState>;

abstract class CompensationPlansSelectionNotifier extends Notifier<AddCompensationPlansState> {
  int latestRequestId = 0;

  (double?, double?) budgetRange();

  DateTime? resolvedEffectiveStartDate();

  AddCompensationPlansState initialState();

  void reset() {
    latestRequestId++;
    state = initialState();
  }

  void clearEligiblePlans() {
    state = state.copyWith(
      eligiblePlans: [],
      addedPlans: [],
      clearSelectedPlan: true,
      clearError: true,
      isEligiblePlansLoading: false,
    );
  }

  void applyFetchedPlans(List<CompensationPlan> plans) {
    var nextCurrency = state.selectedCurrency;
    if (plans.isNotEmpty && nextCurrency.isEmpty) {
      nextCurrency = plans.first.currencyCode.isNotEmpty ? plans.first.currencyCode : nextCurrency;
    }
    CompensationPlan? initialSelectedPlan;
    if (plans.isNotEmpty) {
      initialSelectedPlan = plans.first;
    }

    state = state.copyWith(
      eligiblePlans: plans,
      selectedPlan: initialSelectedPlan,
      addedPlans: [],
      isEligiblePlansLoading: false,
      selectedCurrency: nextCurrency,
    );
  }

  void setSelectedPlan(CompensationPlan plan) {
    state = state.copyWith(selectedPlan: plan, clearError: true);
  }

  void addSelectedPlan() {
    if (state.selectedPlan != null && !state.addedPlans.any((p) => p.planId == state.selectedPlan!.planId)) {
      final updated = AddCompensationPlansState.sortAddedPlansWithEarningFirst([
        ...state.addedPlans,
        state.selectedPlan!,
      ]);
      state = state.copyWith(addedPlans: updated, clearError: true);
    }
  }

  void removePlan(CompensationPlan plan) {
    final updatedAmounts = Map<int, Map<int, double>>.from(state.componentAmounts)..remove(plan.planId);
    state = state.copyWith(
      addedPlans: state.addedPlans.where((p) => p.planId != plan.planId).toList(),
      componentAmounts: updatedAmounts,
      clearError: true,
    );
  }

  void setEffectiveDate(DateTime date) {
    if (state.endDate != null && date.isAfter(state.endDate!)) {
      state = state.copyWith(effectiveDate: date, endDate: null, clearError: true);
    } else {
      state = state.copyWith(effectiveDate: date, clearError: true);
    }
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date, clearError: true);
  }

  void setAmount(int planId, int componentId, String value) {
    final amount = double.tryParse(value) ?? 0.0;
    final updated = Map<int, Map<int, double>>.from(state.componentAmounts);
    updated[planId] = Map<int, double>.from(updated[planId] ?? {})..[componentId] = amount;
    state = state.copyWith(componentAmounts: updated, clearError: true);
  }

  void setSelectedCurrency(String? currency) {
    if (currency == null || currency.isEmpty) return;
    state = state.copyWith(selectedCurrency: currency, clearError: true);
  }

  bool validate({
    bool requireExplicitEffectiveDate = true,
    String? missingStartDateMessage,
    bool skipEffectiveDateValidation = false,
  }) {
    if (!skipEffectiveDateValidation) {
      if (requireExplicitEffectiveDate && state.effectiveDate == null) {
        state = state.copyWith(errorMessage: missingStartDateMessage ?? 'Please select an effective start date');
        return false;
      }
      if (!requireExplicitEffectiveDate && resolvedEffectiveStartDate() == null) {
        state = state.copyWith(errorMessage: 'Please set enterprise hire date in job details');
        return false;
      }
    }
    if (state.selectedCurrency.isEmpty) {
      state = state.copyWith(errorMessage: 'Please select a currency');
      return false;
    }
    if (state.addedPlans.isEmpty) {
      state = state.copyWith(errorMessage: 'Please add at least one compensation plan');
      return false;
    }

    final (budgetedMin, budgetedMax) = budgetRange();

    for (final plan in state.addedPlans) {
      for (final comp in state.effectiveComponentsForPlan(plan)) {
        final amount = state.amountFor(plan.planId, comp.componentId);
        final isEarning = (comp.component?.categoryCode ?? '').toUpperCase() == 'EARNING';

        if (comp.isMandatory && amount <= 0) {
          state = state.copyWith(
            errorMessage: 'Please enter amount for mandatory component: ${comp.component?.displayName}',
          );
          return false;
        }

        if (isEarning && amount > 0) {
          if (budgetedMin != null && amount < budgetedMin) {
            state = state.copyWith(
              errorMessage:
                  '${comp.component?.displayName}: amount cannot be less than ${budgetedMin.toStringAsFixed(0)} KD (budgeted minimum)',
            );
            return false;
          }
          if (budgetedMax != null && amount > budgetedMax) {
            state = state.copyWith(
              errorMessage:
                  '${comp.component?.displayName}: amount cannot exceed ${budgetedMax.toStringAsFixed(0)} KD (budgeted maximum)',
            );
            return false;
          }
        }
      }
    }

    return true;
  }

  static double? parseBudget(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final cleaned = value.trim().replaceAll(',', '');
    return double.tryParse(cleaned);
  }
}

import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_eligible_plans_provider.dart';
import 'package:grc/features/compensation/presentation/utils/bulk_eligible_plans_intersection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulkAddComponentPanelState {
  const BulkAddComponentPanelState({
    required this.plans,
    this.selectedPlan,
    this.availableComponents = const [],
    this.isLoadingPlans = false,
  });

  final List<CompensationPlan> plans;
  final CompensationPlan? selectedPlan;
  final List<PlanComponent> availableComponents;
  final bool isLoadingPlans;

  bool get hasPlans => plans.isNotEmpty;
  bool get allComponentsAdded => selectedPlan != null && availableComponents.isEmpty;
  bool get canAddComponents => selectedPlan != null && availableComponents.isNotEmpty;
}

class BulkAddComponentPanelNotifier extends AutoDisposeNotifier<BulkAddComponentPanelState> {
  @override
  BulkAddComponentPanelState build() {
    final plansAsync = ref.watch(bulkEligiblePlansByEmployeeProvider);
    final sharedPlans = ref.watch(bulkSharedEligiblePlansProvider);

    return BulkAddComponentPanelState(plans: sharedPlans, isLoadingPlans: plansAsync.isLoading);
  }

  void selectPlan(CompensationPlan? plan) {
    if (plan == null) {
      state = BulkAddComponentPanelState(plans: state.plans, isLoadingPlans: state.isLoadingPlans);
      return;
    }

    final entries = ref.read(bulkEligiblePlansByEmployeeProvider).valueOrNull ?? [];
    final formState = ref.read(bulkAdjustmentsFormProvider);
    final available = _filterAvailable(plan: plan, entries: entries, groups: formState.groups);

    state = BulkAddComponentPanelState(
      plans: state.plans,
      selectedPlan: plan,
      availableComponents: available,
      isLoadingPlans: state.isLoadingPlans,
    );
  }

  void clearSelection() {
    state = BulkAddComponentPanelState(plans: state.plans, isLoadingPlans: state.isLoadingPlans);
  }

  List<PlanComponent> _filterAvailable({
    required CompensationPlan plan,
    required List<EmployeeEligiblePlans> entries,
    required List<BulkComponentAdjustmentGroup> groups,
  }) {
    final shared = intersectPlanComponentsAcrossEmployees(entries: entries, planId: plan.planId);
    return shared.where((component) => !_isAdded(component, groups)).toList();
  }

  bool _isAdded(PlanComponent component, List<BulkComponentAdjustmentGroup> groups) {
    for (final group in groups) {
      if (group.deleteFlag) continue;
      if (group.componentId == component.componentId) return true;
      final code = (component.component?.code ?? '').toUpperCase();
      if (code.isNotEmpty && group.componentCode.toUpperCase() == code) return true;
    }
    return false;
  }
}

final bulkAddComponentPanelProvider =
    AutoDisposeNotifierProvider<BulkAddComponentPanelNotifier, BulkAddComponentPanelState>(
      BulkAddComponentPanelNotifier.new,
    );

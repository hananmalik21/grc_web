import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/eligible_components_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddComponentPanelState {
  final List<CompensationPlan> plans;
  final CompensationPlan? selectedPlan;
  final List<PlanComponent> availableComponents;

  const AddComponentPanelState({required this.plans, this.selectedPlan, required this.availableComponents});

  bool get hasPlans => plans.isNotEmpty;
  bool get allComponentsAdded => selectedPlan != null && availableComponents.isEmpty;
  bool get canAddComponents => selectedPlan != null && availableComponents.isNotEmpty;
}

class AddComponentPanelNotifier extends AutoDisposeFamilyNotifier<AddComponentPanelState, String> {
  @override
  AddComponentPanelState build(String arg) {
    final plansAsync = ref.watch(eligiblePlansProvider(arg));
    final plans = plansAsync.valueOrNull ?? [];
    return AddComponentPanelState(plans: plans, availableComponents: []);
  }

  void selectPlan(CompensationPlan? plan) {
    final formState = ref.read(createAdjustmentFormProvider);
    state = AddComponentPanelState(
      plans: state.plans,
      selectedPlan: plan,
      availableComponents: plan == null
          ? []
          : _filterAvailable(plan, formState.componentAdjustments, formState.newComponentAdjustments),
    );
  }

  void refreshAvailable() {
    final plan = state.selectedPlan;
    if (plan == null) return;
    final formState = ref.read(createAdjustmentFormProvider);
    state = AddComponentPanelState(
      plans: state.plans,
      selectedPlan: plan,
      availableComponents: _filterAvailable(plan, formState.componentAdjustments, formState.newComponentAdjustments),
    );
  }

  void clearSelection() {
    state = AddComponentPanelState(plans: state.plans, availableComponents: []);
  }

  List<PlanComponent> _filterAvailable(
    CompensationPlan plan,
    List<ComponentAdjustment> existing,
    List<ComponentAdjustment> newComponents,
  ) {
    return <int, PlanComponent>{
      for (final c in plan.components ?? <PlanComponent>[]) c.id: c,
    }.values.where((c) => !_isAdded(c, existing, newComponents)).toList();
  }

  bool _isAdded(PlanComponent component, List<ComponentAdjustment> existing, List<ComponentAdjustment> newComponents) {
    bool matchesAny(Iterable<ComponentAdjustment> list) {
      if (list.any((a) => a.componentId == component.componentId)) return true;
      final code = (component.component?.code ?? '').toUpperCase();
      return code.isNotEmpty && list.any((a) => a.sourceComponent.componentCode.toUpperCase() == code);
    }

    return matchesAny(existing) || matchesAny(newComponents);
  }
}

final addComponentPanelProvider =
    AutoDisposeNotifierProviderFamily<AddComponentPanelNotifier, AddComponentPanelState, String>(
      AddComponentPanelNotifier.new,
    );

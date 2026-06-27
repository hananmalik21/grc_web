import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentsFilterState {
  final String searchQuery;
  final String? category;
  final String? calculationMethod;
  final ComponentStatus? status;

  const ComponentsFilterState({this.searchQuery = '', this.category, this.calculationMethod, this.status});

  ComponentsFilterState copyWith({
    String? searchQuery,
    String? category,
    bool clearCategory = false,
    String? calculationMethod,
    bool clearCalculationMethod = false,
    ComponentStatus? status,
    bool clearStatus = false,
  }) {
    return ComponentsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : (category ?? this.category),
      calculationMethod: clearCalculationMethod ? null : (calculationMethod ?? this.calculationMethod),
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || category != null || calculationMethod != null || status != null;
}

class ComponentsFilterNotifier extends Notifier<ComponentsFilterState> {
  final _debouncer = Debouncer();

  @override
  ComponentsFilterState build() {
    ref.onDispose(_debouncer.dispose);
    return const ComponentsFilterState();
  }

  void setSearch(String query) {
    _debouncer.run(() => state = state.copyWith(searchQuery: query));
  }

  void setCategory(String? value) {
    state = value == null ? state.copyWith(clearCategory: true) : state.copyWith(category: value);
  }

  void setCalculationMethod(String? value) {
    state = value == null ? state.copyWith(clearCalculationMethod: true) : state.copyWith(calculationMethod: value);
  }

  void setStatus(ComponentStatus? value) {
    state = value == null ? state.copyWith(clearStatus: true) : state.copyWith(status: value);
  }

  void reset() => state = const ComponentsFilterState();
}

final componentsFilterProvider = NotifierProvider<ComponentsFilterNotifier, ComponentsFilterState>(
  ComponentsFilterNotifier.new,
);

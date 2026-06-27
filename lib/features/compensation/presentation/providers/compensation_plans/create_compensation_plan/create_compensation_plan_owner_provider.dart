import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCompensationPlanOwnerState {
  final Employee? selectedEmployee;

  const CreateCompensationPlanOwnerState({this.selectedEmployee});

  CreateCompensationPlanOwnerState copyWith({Employee? selectedEmployee}) {
    return CreateCompensationPlanOwnerState(selectedEmployee: selectedEmployee ?? this.selectedEmployee);
  }
}

class CreateCompensationPlanOwnerNotifier extends Notifier<CreateCompensationPlanOwnerState> {
  final Employee? _initialEmployee;

  CreateCompensationPlanOwnerNotifier({Employee? initialEmployee}) : _initialEmployee = initialEmployee;

  @override
  CreateCompensationPlanOwnerState build() => CreateCompensationPlanOwnerState(selectedEmployee: _initialEmployee);

  void setSelectedEmployee(Employee employee) {
    state = state.copyWith(selectedEmployee: employee);
  }

  void clear() {
    state = const CreateCompensationPlanOwnerState();
  }

  void syncWithExpectedOwnerId(int? expectedOwnerId) {
    final selected = state.selectedEmployee;
    if (selected == null) return;

    final normalizedExpectedOwnerId = (expectedOwnerId ?? 0) > 0 ? expectedOwnerId : null;
    if (selected.id != normalizedExpectedOwnerId) {
      clear();
    }
  }
}

final createCompensationPlanOwnerProvider =
    NotifierProvider<CreateCompensationPlanOwnerNotifier, CreateCompensationPlanOwnerState>(
      () => CreateCompensationPlanOwnerNotifier(),
    );

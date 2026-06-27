import 'package:flutter_riverpod/flutter_riverpod.dart';

const int addEmployeeTotalSteps = 9;

class AddEmployeeStepperState {
  final int currentStepIndex;

  const AddEmployeeStepperState({this.currentStepIndex = 0});

  bool get canGoNext => currentStepIndex < addEmployeeTotalSteps - 1;
  bool get canGoPrevious => currentStepIndex > 0;
  bool get isLastStep => currentStepIndex == addEmployeeTotalSteps - 1;
}

class AddEmployeeStepperNotifier extends StateNotifier<AddEmployeeStepperState> {
  AddEmployeeStepperNotifier() : super(const AddEmployeeStepperState());

  void nextStep() {
    if (!state.canGoNext) return;
    state = AddEmployeeStepperState(currentStepIndex: state.currentStepIndex + 1);
  }

  void previousStep() {
    if (!state.canGoPrevious) return;
    state = AddEmployeeStepperState(currentStepIndex: state.currentStepIndex - 1);
  }

  void setStep(int index) {
    if (index < 0 || index >= addEmployeeTotalSteps) return;
    state = AddEmployeeStepperState(currentStepIndex: index);
  }

  void reset() {
    state = const AddEmployeeStepperState();
  }
}

final addEmployeeStepperProvider = StateNotifierProvider<AddEmployeeStepperNotifier, AddEmployeeStepperState>(
  (ref) => AddEmployeeStepperNotifier(),
);

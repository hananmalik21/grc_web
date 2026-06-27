import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_management/user_policy.dart';

class UserDataPolicyFormState {
  final bool isLoading;
  final bool clearError;
  final String? error;
  final UserPolicy? selectedPolicy;
  final List<UserPolicy> availablePolicies;
  final List<UserPolicy> filteredPolicies;
  final String? selectedPolicyType;

  UserDataPolicyFormState({
    this.isLoading = false,
    this.clearError = false,
    this.error,
    this.selectedPolicy,
    this.availablePolicies = const [],
    this.filteredPolicies = const [],
    this.selectedPolicyType,
  });

  UserDataPolicyFormState copyWith({
    bool? isLoading,
    bool? clearError,
    String? error,
    UserPolicy? selectedPolicy,
    List<UserPolicy>? availablePolicies,
    List<UserPolicy>? filteredPolicies,
    String? selectedPolicyType,
  }) {
    return UserDataPolicyFormState(
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
      selectedPolicy: selectedPolicy ?? this.selectedPolicy,
      availablePolicies: availablePolicies ?? this.availablePolicies,
      filteredPolicies: filteredPolicies ?? this.filteredPolicies,
      selectedPolicyType: selectedPolicyType ?? this.selectedPolicyType,
    );
  }
}

class UserDataPolicyFormProvider
    extends StateNotifier<UserDataPolicyFormState> {
  UserDataPolicyFormProvider() : super(UserDataPolicyFormState()) {
    loadAvailablePolicies();
  }

  void loadAvailablePolicies() {
    final policies = [
      UserPolicy(
        id: 1,
        title: "Kuwait Operations Data",
        description: "All Kuwait entities",
        type: "Business Unit",
      ),
      UserPolicy(
        id: 2,
        title: "HR Department Data",
        description: "HR Department only",
        type: "Department",
      ),
      UserPolicy(
        id: 3,
        title: "Confidential Employee Data",
        description: "Restricted access",
        type: "Data Security",
      ),
      UserPolicy(
        id: 4,
        title: "Payroll Sensitive Data",
        description: "Payroll administrators only",
        type: "Data Security",
      ),
    ];
    state = state.copyWith(
      availablePolicies: policies,
      filteredPolicies: policies,
    );
  }

  void assignPolicy(UserPolicy policy) {
    state = state.copyWith(selectedPolicy: policy);
  }

  void searchPolicies(String query) {
    final filteredPolicies = state.availablePolicies.where((policy) {
      return policy.title.toLowerCase().contains(query.toLowerCase()) ||
          policy.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredPolicies: filteredPolicies);
  }

  void resetFilters() {
    state = state.copyWith(
      selectedPolicyType: null,
      filteredPolicies: state.availablePolicies,
    );
  }
}

final userDataPolicyFormProvider =
    StateNotifierProvider<UserDataPolicyFormProvider, UserDataPolicyFormState>(
      (ref) => UserDataPolicyFormProvider(),
    );

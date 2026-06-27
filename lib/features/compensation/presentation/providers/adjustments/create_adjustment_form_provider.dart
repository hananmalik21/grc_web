import 'dart:typed_data';

import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/providers/employees/compensation_employees_assigned_components_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_adjustment_details.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grc/core/enums/compensation_enums.dart';

class ComponentAdjustment {
  final EmployeeAssignedComponent sourceComponent;
  final int componentId;
  final String componentName;
  final String componentType;
  final CompensationFrequency frequency;
  final String currency;
  final double currentAmount;
  final String adjustmentType;
  final String value;
  final double newAmount;
  final bool deleteFlag;

  const ComponentAdjustment({
    required this.sourceComponent,
    required this.componentId,
    required this.componentName,
    required this.componentType,
    required this.frequency,
    required this.currency,
    required this.currentAmount,
    this.adjustmentType = 'PERCENTAGE',
    this.value = '',
    this.newAmount = 0,
    this.deleteFlag = false,
  });

  // Computed properties
  double get annualValue => currentAmount * frequency.annualMultiplier;

  String get formattedCurrentAmount => '$currency ${currentAmount.toStringAsFixed(0)}';

  String get formattedAnnualValue => '$currency ${annualValue.toStringAsFixed(0)}';

  String get formattedNewAmount => '$currency ${newAmount.toStringAsFixed(0)}';

  String get newAmountDisplayKey => newAmount.toStringAsFixed(0);

  String get frequencyLabel => frequency.label;

  bool get isEarning {
    final category = sourceComponent.categoryCode.trim();
    if (category.isNotEmpty) return category.toUpperCase() == 'EARNING';
    return componentType.trim().toUpperCase() == 'EARNING';
  }

  static List<ComponentAdjustment> sortedWithEarningFirst(List<ComponentAdjustment> adjustments) {
    final earning = adjustments.where((adj) => adj.isEarning).toList();
    final other = adjustments.where((adj) => !adj.isEarning).toList();
    return [...earning, ...other];
  }

  ComponentAdjustment copyWith({String? adjustmentType, String? value, double? newAmount, bool? deleteFlag}) {
    return ComponentAdjustment(
      sourceComponent: sourceComponent,
      componentId: componentId,
      componentName: componentName,
      componentType: componentType,
      frequency: frequency,
      currency: currency,
      currentAmount: currentAmount,
      adjustmentType: adjustmentType ?? this.adjustmentType,
      value: value ?? this.value,
      newAmount: newAmount ?? this.newAmount,
      deleteFlag: deleteFlag ?? this.deleteFlag,
    );
  }
}

class CreateAdjustmentFormState {
  final Employee? selectedEmployee;
  final EmployeeAdjustmentDetails? selectedEmployeeDetails;
  final bool isLoadingEmployeeDetails;
  final int? selectedPlanId;
  final String adjustmentType;
  final String adjustmentMethod;
  final String reasonCode;
  final DateTime? effectiveDate;
  final String adjustmentValue;
  final String comments;
  final String budgetCode;
  final String justification;
  final String? performanceRating;
  final String internalNotes;
  final String documentName;
  final String? documentPath;
  final Uint8List? documentBytes;
  final bool isLoadingComponents;
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final List<ComponentAdjustment> componentAdjustments;
  final List<ComponentAdjustment> newComponentAdjustments;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;
  final DateTime? hireDate;

  const CreateAdjustmentFormState({
    this.selectedEmployee,
    this.selectedEmployeeDetails,
    this.isLoadingEmployeeDetails = false,
    this.selectedPlanId,
    required this.adjustmentType,
    required this.adjustmentMethod,
    required this.reasonCode,
    this.effectiveDate,
    this.adjustmentValue = '',
    required this.comments,
    required this.budgetCode,
    this.justification = '',
    this.performanceRating,
    this.internalNotes = '',
    this.documentName = '',
    this.documentPath,
    this.documentBytes,
    this.isLoadingComponents = false,
    this.isSubmitting = false,
    this.isSubmitSuccess = false,
    required this.componentAdjustments,
    this.newComponentAdjustments = const [],
    this.budgetedMinKd,
    this.budgetedMaxKd,
    this.hireDate,
  });

  factory CreateAdjustmentFormState.initial() {
    return CreateAdjustmentFormState(
      adjustmentType: '',
      adjustmentMethod: AdjustmentsTabConfig.createAdjustmentMethods.first,
      reasonCode: '',
      comments: '',
      budgetCode: '',
      componentAdjustments: const [],
    );
  }

  CreateAdjustmentFormState copyWith({
    Employee? selectedEmployee,
    bool clearSelectedEmployee = false,
    EmployeeAdjustmentDetails? selectedEmployeeDetails,
    bool clearSelectedEmployeeDetails = false,
    bool? isLoadingEmployeeDetails,
    int? selectedPlanId,
    bool clearSelectedPlanId = false,
    String? adjustmentType,
    String? adjustmentMethod,
    String? reasonCode,
    DateTime? effectiveDate,
    bool clearEffectiveDate = false,
    String? adjustmentValue,
    String? comments,
    String? budgetCode,
    String? justification,
    String? performanceRating,
    bool clearPerformanceRating = false,
    String? internalNotes,
    String? documentName,
    String? documentPath,
    Uint8List? documentBytes,
    bool clearDocumentPath = false,
    bool? isLoadingComponents,
    bool? isSubmitting,
    bool? isSubmitSuccess,
    List<ComponentAdjustment>? componentAdjustments,
    List<ComponentAdjustment>? newComponentAdjustments,
    double? budgetedMinKd,
    double? budgetedMaxKd,
    bool clearBudgetRange = false,
    DateTime? hireDate,
    bool clearHireDate = false,
  }) {
    return CreateAdjustmentFormState(
      selectedEmployee: clearSelectedEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
      selectedEmployeeDetails: clearSelectedEmployeeDetails
          ? null
          : (selectedEmployeeDetails ?? this.selectedEmployeeDetails),
      isLoadingEmployeeDetails: isLoadingEmployeeDetails ?? this.isLoadingEmployeeDetails,
      selectedPlanId: clearSelectedPlanId ? null : (selectedPlanId ?? this.selectedPlanId),
      adjustmentType: adjustmentType ?? this.adjustmentType,
      adjustmentMethod: adjustmentMethod ?? this.adjustmentMethod,
      reasonCode: reasonCode ?? this.reasonCode,
      effectiveDate: clearEffectiveDate ? null : (effectiveDate ?? this.effectiveDate),
      adjustmentValue: adjustmentValue ?? this.adjustmentValue,
      comments: comments ?? this.comments,
      budgetCode: budgetCode ?? this.budgetCode,
      justification: justification ?? this.justification,
      performanceRating: clearPerformanceRating ? null : (performanceRating ?? this.performanceRating),
      internalNotes: internalNotes ?? this.internalNotes,
      documentName: documentName ?? this.documentName,
      documentPath: clearDocumentPath ? null : (documentPath ?? this.documentPath),
      documentBytes: clearDocumentPath ? null : (documentBytes ?? this.documentBytes),
      isLoadingComponents: isLoadingComponents ?? this.isLoadingComponents,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
      componentAdjustments: componentAdjustments ?? this.componentAdjustments,
      newComponentAdjustments: newComponentAdjustments ?? this.newComponentAdjustments,
      budgetedMinKd: clearBudgetRange ? null : (budgetedMinKd ?? this.budgetedMinKd),
      budgetedMaxKd: clearBudgetRange ? null : (budgetedMaxKd ?? this.budgetedMaxKd),
      hireDate: clearHireDate ? null : (hireDate ?? this.hireDate),
    );
  }
}

class CreateAdjustmentFormNotifier extends AutoDisposeNotifier<CreateAdjustmentFormState> {
  @override
  CreateAdjustmentFormState build() => CreateAdjustmentFormState.initial();

  void reset() => state = CreateAdjustmentFormState.initial();

  Future<void> prefillEmployeeByGuid({required String employeeGuid, required int enterpriseId}) async {
    if (employeeGuid.isEmpty || enterpriseId <= 0) return;

    final repository = ref.read(manageEmployeesListRepositoryProvider);
    final fullDetails = await repository.getEmployeeFullDetails(employeeGuid, enterpriseId: enterpriseId);
    if (fullDetails == null) return;

    selectEmployee(Employee.fromFullDetails(fullDetails));
  }

  void selectEmployee(Employee employee) async {
    state = state.copyWith(
      selectedEmployee: employee,
      isLoadingComponents: true,
      isLoadingEmployeeDetails: true,
      clearSelectedPlanId: true,
      clearSelectedEmployeeDetails: true,
      clearBudgetRange: true,
      clearHireDate: true,
    );

    try {
      final assignedComponentsUseCase = ref.read(getEmployeeAssignedComponentsUseCaseProvider);
      final employeeDetailsUseCase = ref.read(getEmployeeAdjustmentDetailsUseCaseProvider);
      final employeeRepository = ref.read(manageEmployeesListRepositoryProvider);

      final results = await Future.wait([
        assignedComponentsUseCase(employeeGuid: employee.guid),
        employeeDetailsUseCase(employeeGuid: employee.guid, enterpriseId: employee.enterpriseId),
        employeeRepository.getEmployeeFullDetails(employee.guid, enterpriseId: employee.enterpriseId),
      ]);

      final components = results[0] as List<EmployeeAssignedComponent>;
      final employeeDetails = results[1] as EmployeeAdjustmentDetails;
      final fullDetails = results[2] as EmployeeFullDetails?;

      final adjustments = components
          .map(
            (c) => ComponentAdjustment(
              sourceComponent: c,
              componentId: c.componentId,
              componentName: c.componentName,
              componentType: c.categoryCode,
              frequency: CompensationFrequency.fromValue(c.frequencyCode),
              currency: c.currencyCode,
              currentAmount: c.amount,
              adjustmentType: 'PERCENTAGE',
              value: '',
              newAmount: c.amount,
            ),
          )
          .toList();

      DateTime? parsedHireDate;
      if (fullDetails?.assignment.enterpriseHireDate != null) {
        parsedHireDate = DateTime.tryParse(fullDetails!.assignment.enterpriseHireDate!);
      }

      state = state.copyWith(
        componentAdjustments: adjustments,
        newComponentAdjustments: [],
        selectedPlanId: components.isNotEmpty ? components.first.planId : null,
        selectedEmployeeDetails: employeeDetails,
        isLoadingComponents: false,
        isLoadingEmployeeDetails: false,
        budgetedMinKd: fullDetails?.assignment.budgetedMinKd,
        budgetedMaxKd: fullDetails?.assignment.budgetedMaxKd,
        hireDate: parsedHireDate,
      );
    } catch (e) {
      state = state.copyWith(
        componentAdjustments: [],
        newComponentAdjustments: [],
        clearSelectedPlanId: true,
        clearSelectedEmployeeDetails: true,
        isLoadingComponents: false,
        isLoadingEmployeeDetails: false,
        clearBudgetRange: true,
        clearHireDate: true,
      );
    }
  }

  void setAdjustmentType(String value) {
    state = state.copyWith(adjustmentType: value);
  }

  void setAdjustmentMethod(String value) {
    state = state.copyWith(adjustmentMethod: value);
  }

  void setReasonCode(String value) {
    state = state.copyWith(reasonCode: value);
  }

  void setEffectiveDate(DateTime value) {
    state = state.copyWith(effectiveDate: value);
  }

  void setAdjustmentValue(String value) {
    state = state.copyWith(adjustmentValue: value);
  }

  void setComments(String value) {
    state = state.copyWith(comments: value);
  }

  void setBudgetCode(String value) {
    state = state.copyWith(budgetCode: value);
  }

  void setJustification(String value) {
    state = state.copyWith(justification: value);
  }

  void setPerformanceRating(String value) {
    state = state.copyWith(performanceRating: value);
  }

  void setInternalNotes(String value) {
    state = state.copyWith(internalNotes: value);
  }

  void setDocument(String path, String name, {Uint8List? bytes}) {
    state = state.copyWith(documentPath: path, documentName: name, documentBytes: bytes);
  }

  void updateComponentAdjustment(int index, {bool isNew = false, String? adjustmentType, String? value}) {
    final source = isNew ? state.newComponentAdjustments : state.componentAdjustments;
    final adjustments = List<ComponentAdjustment>.from(source);

    var adj = adjustments[index].copyWith(adjustmentType: adjustmentType, value: value);
    adjustments[index] = adj.copyWith(newAmount: _calcNewAmount(adj));

    if (isNew) {
      state = state.copyWith(newComponentAdjustments: adjustments);
    } else {
      state = state.copyWith(componentAdjustments: adjustments);
    }
  }

  double _calcNewAmount(ComponentAdjustment adj) {
    final val = double.tryParse(adj.value) ?? 0;
    return switch (AdjustmentMethod.fromCode(adj.adjustmentType)) {
      AdjustmentMethod.percentage => adj.currentAmount * (1 + val / 100),
      AdjustmentMethod.amount => adj.currentAmount + val,
      AdjustmentMethod.manual => val,
      null => adj.currentAmount,
    };
  }

  void removeComponentAdjustment(int index, {bool isNew = false}) {
    if (isNew) {
      final adjustments = List<ComponentAdjustment>.from(state.newComponentAdjustments);
      adjustments.removeAt(index);
      state = state.copyWith(newComponentAdjustments: adjustments);
    } else {
      final adjustments = List<ComponentAdjustment>.from(state.componentAdjustments);
      adjustments[index] = adjustments[index].copyWith(deleteFlag: true);
      state = state.copyWith(componentAdjustments: adjustments);
    }
  }

  void addComponentFromPlan(PlanComponent planComponent, {required int planId}) {
    final fallbackCurrency = state.componentAdjustments.isNotEmpty ? state.componentAdjustments.first.currency : 'USD';
    final currencyCode = planComponent.component?.currencyCode?.isNotEmpty == true
        ? planComponent.component!.currencyCode!
        : fallbackCurrency;

    final sourceComponent = EmployeeAssignedComponent(
      assignmentDetailId: 0,
      assignmentDetailGuid: '',
      enterpriseId: 0,
      employeeId: state.selectedEmployee?.id ?? 0,
      employeeGuid: state.selectedEmployee?.guid ?? '',
      planId: planId,
      componentId: planComponent.componentId,
      componentCode: planComponent.component?.code ?? '',
      componentName: planComponent.component?.name ?? '',
      categoryCode: planComponent.component?.categoryCode ?? '',
      frequencyCode: 'MONTHLY',
      amount: 0.0,
      currencyCode: currencyCode,
      effectiveStartDate: state.effectiveDate ?? DateTime.now(),
      changeSource: 'MANUAL',
      activeFlag: 'Y',
    );

    final newAdjustment = ComponentAdjustment(
      sourceComponent: sourceComponent,
      componentId: planComponent.componentId,
      componentName: planComponent.component?.name ?? '',
      componentType: planComponent.component?.categoryCode ?? '',
      frequency: CompensationFrequency.monthly,
      currency: currencyCode,
      currentAmount: 0.0,
    );

    state = state.copyWith(
      newComponentAdjustments: ComponentAdjustment.sortedWithEarningFirst([
        ...state.newComponentAdjustments,
        newAdjustment,
      ]),
    );
  }

  List<Map<String, dynamic>> _mapExistingComponents(List<ComponentAdjustment> adjustments) {
    return adjustments
        .where((adj) {
          final isDeleted = adj.deleteFlag;
          final isModified = !isDeleted && adj.value.trim().isNotEmpty && adj.newAmount != adj.currentAmount;
          return isDeleted || isModified;
        })
        .map((adj) {
          final source = adj.sourceComponent;
          final isDeleted = adj.deleteFlag;
          final isModified = !isDeleted && adj.newAmount != adj.currentAmount;
          return {
            'plan_id': source.planId,
            'component_id': source.componentId,
            'amount': adj.newAmount,
            'adjustment_method': adj.adjustmentType,
            'currency_code': source.currencyCode,
            'effective_start_date': source.effectiveStartDate.toIso8601String().split('T').first,
            'effective_end_date': source.effectiveEndDate?.toIso8601String().split('T').first,
            'active_flag': source.activeFlag,
            'delete_flag': isDeleted ? 'TRUE' : 'FALSE',
            'replace_flag': isModified ? 'TRUE' : 'FALSE',
          };
        })
        .toList();
  }

  List<Map<String, dynamic>> _mapNewComponents(List<ComponentAdjustment> adjustments) {
    return adjustments.map((adj) {
      final source = adj.sourceComponent;
      return {
        'plan_id': source.planId,
        'component_id': source.componentId,
        'amount': adj.newAmount,
        'adjustment_method': adj.adjustmentType,
        'currency_code': source.currencyCode,
        'effective_start_date': source.effectiveStartDate.toIso8601String().split('T').first,
        'effective_end_date': source.effectiveEndDate?.toIso8601String().split('T').first,
        'active_flag': source.activeFlag,
        'delete_flag': 'FALSE',
        'replace_flag': 'TRUE',
      };
    }).toList();
  }

  String? firstValidationError() {
    if (state.selectedEmployee == null) {
      return 'Please select an employee';
    } else if (state.adjustmentType.isEmpty) {
      return 'Adjustment Type is required';
    } else if (state.reasonCode.isEmpty) {
      return 'Reason Code is required';
    } else if (state.effectiveDate == null) {
      return 'Effective Date is required';
    } else if (state.budgetCode.isEmpty) {
      return 'Budget Code is required';
    } else if (state.justification.isEmpty) {
      return 'Justification is required';
    } else if (state.selectedPlanId == null) {
      return 'No compensation plan found for the selected employee';
    }
    return null;
  }

  Future<void> submitAdjustment() async {
    final employee = state.selectedEmployee;
    final effectiveDate = state.effectiveDate;
    final planId = state.selectedPlanId;

    if (employee == null || effectiveDate == null || planId == null) {
      throw Exception('Form is invalid');
    }

    state = state.copyWith(isSubmitting: true);

    try {
      final enterpriseId = employee.enterpriseId;

      final components = [
        ..._mapExistingComponents(state.componentAdjustments),
        ..._mapNewComponents(state.newComponentAdjustments),
      ];

      final useCase = ref.read(createSalaryAdjustmentUseCaseProvider);
      await useCase(
        enterpriseId: enterpriseId,
        employeeId: employee.id,
        planId: planId,
        adjustmentType: state.adjustmentType,
        effectiveDate: effectiveDate,
        status: 'PENDING',
        reasonCode: state.reasonCode,
        budgetCode: state.budgetCode,
        justificationText: state.justification,
        performanceRating: state.performanceRating ?? '',
        internalNotes: state.internalNotes,
        updatedBy: 'SYSTEM',
        components: components,
        documentPath: state.documentPath,
        documentName: state.documentName,
        documentBytes: state.documentBytes,
      );
      state = state.copyWith(isSubmitting: false, isSubmitSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }
}

final createAdjustmentFormProvider =
    AutoDisposeNotifierProvider<CreateAdjustmentFormNotifier, CreateAdjustmentFormState>(
      CreateAdjustmentFormNotifier.new,
    );

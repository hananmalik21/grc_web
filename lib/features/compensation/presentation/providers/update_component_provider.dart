import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/presentation/providers/create_new_component_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateComponentState {
  final CreateNewComponentStep step;
  final int maxStepIndex;

  final String name;
  final String code;
  final String? category;
  final String? type;
  final String currency;
  final String status;
  final String description;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;

  final String? calculationMethod;
  final String? payBasis;
  final String? baseAmountSource;
  final String? formulaName;
  final String minValue;
  final String maxValue;

  final String payrollCode;
  final String glAccount;
  final String costCenter;
  final String displayOrder;

  final bool isProRated;
  final bool isTaxable;
  final bool includeInCtc;
  final bool isPensionable;
  final bool isStatutory;
  final bool isRecurring;
  final bool isOptional;
  final bool isAmortizable;

  final Set<String> locations;

  const UpdateComponentState({
    required this.step,
    required this.maxStepIndex,
    required this.name,
    required this.code,
    required this.category,
    required this.type,
    required this.currency,
    required this.status,
    required this.description,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.calculationMethod,
    required this.payBasis,
    required this.baseAmountSource,
    required this.formulaName,
    required this.minValue,
    required this.maxValue,
    required this.payrollCode,
    required this.glAccount,
    required this.costCenter,
    required this.displayOrder,
    required this.isProRated,
    required this.isTaxable,
    required this.includeInCtc,
    required this.isPensionable,
    required this.isStatutory,
    required this.isRecurring,
    required this.isOptional,
    required this.isAmortizable,
    required this.locations,
  });

  factory UpdateComponentState.fromComponent(CompComponent c) {
    final statusUi = c.status.toUpperCase() == 'ACTIVE' ? 'Active' : 'Inactive';
    return UpdateComponentState(
      step: CreateNewComponentStep.basicInformation,
      maxStepIndex: CreateNewComponentStep.values.length - 1,
      name: c.componentName,
      code: c.componentCode,
      category: c.compCategoryCode.isNotEmpty ? c.compCategoryCode : null,
      type: c.componentTypeCode.isNotEmpty ? c.componentTypeCode : null,
      currency: c.currencyCode ?? '',
      status: statusUi,
      description: c.description == '---' ? '' : c.description,
      effectiveFrom: c.effectiveStartDate,
      effectiveTo: c.effectiveEndDate,
      calculationMethod: c.calculationMethodCode.isNotEmpty ? c.calculationMethodCode : null,
      payBasis: c.payBasis,
      baseAmountSource: c.baseAmountSource,
      formulaName: c.formulaName,
      minValue: c.minValue?.toString() ?? '',
      maxValue: c.maxValue?.toString() ?? '',
      payrollCode: '',
      glAccount: '',
      costCenter: '',
      displayOrder: '',
      isProRated: c.proratedFlag == 'Y',
      isTaxable: c.taxableFlag == 'Y',
      includeInCtc: c.includeInCtcFlag == 'Y',
      isPensionable: c.pensionableFlag == 'Y',
      isStatutory: c.statutoryFlag == 'Y',
      isRecurring: c.recurringFlag == 'Y',
      isOptional: c.optionalFlag == 'Y',
      isAmortizable: c.amortizableFlag == 'Y',
      locations: c.locationCodes.toSet(),
    );
  }

  UpdateComponentState copyWith({
    CreateNewComponentStep? step,
    int? maxStepIndex,
    String? name,
    String? code,
    String? category,
    String? type,
    String? currency,
    String? status,
    String? description,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
    String? calculationMethod,
    Object? payBasis = _sentinel,
    Object? baseAmountSource = _sentinel,
    Object? formulaName = _sentinel,
    String? minValue,
    String? maxValue,
    String? payrollCode,
    String? glAccount,
    String? costCenter,
    String? displayOrder,
    bool? isProRated,
    bool? isTaxable,
    bool? includeInCtc,
    bool? isPensionable,
    bool? isStatutory,
    bool? isRecurring,
    bool? isOptional,
    bool? isAmortizable,
    Set<String>? locations,
  }) {
    return UpdateComponentState(
      step: step ?? this.step,
      maxStepIndex: maxStepIndex ?? this.maxStepIndex,
      name: name ?? this.name,
      code: code ?? this.code,
      category: category ?? this.category,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      description: description ?? this.description,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      payBasis: identical(payBasis, _sentinel) ? this.payBasis : payBasis as String?,
      baseAmountSource: identical(baseAmountSource, _sentinel) ? this.baseAmountSource : baseAmountSource as String?,
      formulaName: identical(formulaName, _sentinel) ? this.formulaName : formulaName as String?,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      payrollCode: payrollCode ?? this.payrollCode,
      glAccount: glAccount ?? this.glAccount,
      costCenter: costCenter ?? this.costCenter,
      displayOrder: displayOrder ?? this.displayOrder,
      isProRated: isProRated ?? this.isProRated,
      isTaxable: isTaxable ?? this.isTaxable,
      includeInCtc: includeInCtc ?? this.includeInCtc,
      isPensionable: isPensionable ?? this.isPensionable,
      isStatutory: isStatutory ?? this.isStatutory,
      isRecurring: isRecurring ?? this.isRecurring,
      isOptional: isOptional ?? this.isOptional,
      isAmortizable: isAmortizable ?? this.isAmortizable,
      locations: locations ?? this.locations,
    );
  }
}

const _sentinel = Object();

final updateComponentProvider = StateNotifierProvider.autoDispose
    .family<UpdateComponentNotifier, UpdateComponentState, CompComponent>((ref, component) {
      return UpdateComponentNotifier(component);
    });

class UpdateComponentNotifier extends StateNotifier<UpdateComponentState> {
  UpdateComponentNotifier(CompComponent component) : super(UpdateComponentState.fromComponent(component));

  int get stepIndex => CreateNewComponentStep.values.indexOf(state.step);
  int get stepCount => CreateNewComponentStep.values.length;

  CreateNewComponentStep _stepAt(int index) => CreateNewComponentStep.values[index.clamp(0, stepCount - 1)];

  String? tryGoNext() {
    final error = validateStep(state.step);
    if (error != null) return error;
    final nextIndex = (stepIndex + 1).clamp(0, stepCount - 1);
    state = state.copyWith(
      step: _stepAt(nextIndex),
      maxStepIndex: nextIndex > state.maxStepIndex ? nextIndex : state.maxStepIndex,
    );
    return null;
  }

  void goBack() {
    final prevIndex = (stepIndex - 1).clamp(0, stepCount - 1);
    state = state.copyWith(step: _stepAt(prevIndex));
  }

  void setName(String value) => state = state.copyWith(name: value);
  void setCode(String value) => state = state.copyWith(code: value);
  void setCategory(String? value) => state = state.copyWith(category: value);
  void setType(String? value) => state = state.copyWith(type: value);
  void setCurrency(String value) => state = state.copyWith(currency: value);
  void setStatus(String value) => state = state.copyWith(status: value);
  void setDescription(String value) => state = state.copyWith(description: value);

  void setEffectiveFrom(DateTime? value) {
    if (value == null) {
      state = state.copyWith(effectiveFrom: null, effectiveTo: null);
      return;
    }
    final from = _dateOnly(value);
    DateTime? nextTo = state.effectiveTo;
    if (nextTo != null) {
      final to = _dateOnly(nextTo);
      final today = _dateOnly(DateTime.now());
      if (to.isBefore(from) || to.isBefore(today)) nextTo = null;
    }
    state = state.copyWith(effectiveFrom: value, effectiveTo: nextTo);
  }

  void setEffectiveTo(DateTime? value) => state = state.copyWith(effectiveTo: value);

  void setCalculationMethod(String? value) =>
      state = state.copyWith(calculationMethod: value, baseAmountSource: null, formulaName: null);

  void setPayBasis(String? value) => state = state.copyWith(payBasis: value);
  void setBaseAmountSource(String? value) => state = state.copyWith(baseAmountSource: value);
  void setFormulaName(String value) => state = state.copyWith(formulaName: value);
  void setMinValue(String value) => state = state.copyWith(minValue: value);
  void setMaxValue(String value) => state = state.copyWith(maxValue: value);

  void setPayrollCode(String value) => state = state.copyWith(payrollCode: value);
  void setGlAccount(String value) => state = state.copyWith(glAccount: value);
  void setCostCenter(String value) => state = state.copyWith(costCenter: value);
  void setDisplayOrder(String value) => state = state.copyWith(displayOrder: value);

  void setIsProRated(bool value) => state = state.copyWith(isProRated: value);
  void setIsTaxable(bool value) => state = state.copyWith(isTaxable: value);
  void setIncludeInCtc(bool value) => state = state.copyWith(includeInCtc: value);
  void setIsPensionable(bool value) => state = state.copyWith(isPensionable: value);
  void setIsStatutory(bool value) => state = state.copyWith(isStatutory: value);
  void setIsRecurring(bool value) => state = state.copyWith(isRecurring: value);
  void setIsOptional(bool value) => state = state.copyWith(isOptional: value);
  void setIsAmortizable(bool value) => state = state.copyWith(isAmortizable: value);

  void toggleLocation(String item) {
    final updated = {...state.locations};
    if (updated.contains(item)) {
      updated.remove(item);
    } else {
      updated.add(item);
    }
    state = state.copyWith(locations: updated);
  }

  String? validateStep(CreateNewComponentStep step) {
    switch (step) {
      case CreateNewComponentStep.basicInformation:
        if (state.name.trim().isEmpty) return 'Component name is required.';
        if (state.code.trim().isEmpty) return 'Component code is required.';
        if (state.category == null || state.category!.trim().isEmpty) return 'Category is required.';
        if (state.type == null || state.type!.trim().isEmpty) return 'Type is required.';
        if (state.currency.trim().isEmpty) return 'Currency is required.';
        if (state.status.trim().isEmpty) return 'Status is required.';
        if (state.effectiveFrom == null) return 'Effective From is required.';
        if (state.effectiveFrom != null &&
            state.effectiveTo != null &&
            _dateOnly(state.effectiveTo!).isBefore(_dateOnly(state.effectiveFrom!))) {
          return 'Effective To cannot be earlier than Effective From.';
        }
        return null;

      case CreateNewComponentStep.calculation:
        final calcMethod = state.calculationMethod?.trim();
        if (calcMethod == null || calcMethod.isEmpty) return 'Calculation method is required.';
        if (state.minValue.trim().isEmpty) return 'Minimum value is required.';
        if (state.maxValue.trim().isEmpty) return 'Maximum value is required.';
        if (calcMethod == 'PERCENTAGE' && (state.baseAmountSource == null || state.baseAmountSource!.trim().isEmpty)) {
          return 'Base amount source is required.';
        }
        if (calcMethod == 'FORMULA' && (state.formulaName == null || state.formulaName!.trim().isEmpty)) {
          return 'Formula name is required.';
        }
        final min = num.tryParse(state.minValue.trim());
        final max = num.tryParse(state.maxValue.trim());
        if (min == null) return 'Minimum value must be a number.';
        if (max == null) return 'Maximum value must be a number.';
        if (min > max) return 'Minimum value cannot be greater than maximum value.';
        return null;

      case CreateNewComponentStep.payrollAccounting:
        if (state.payrollCode.trim().isEmpty) return 'Payroll code is required.';
        if (state.glAccount.trim().isEmpty) return 'GL account is required.';
        if (state.costCenter.trim().isEmpty) return 'Cost center is required.';
        if (state.displayOrder.trim().isEmpty) return 'Display order is required.';
        if (int.tryParse(state.displayOrder.trim()) == null) {
          return 'Display order must be a whole number.';
        }
        return null;

      case CreateNewComponentStep.advancedSettings:
      case CreateNewComponentStep.eligibility:
        return null;
    }
  }

  String? validateForSubmit() {
    return validateStep(CreateNewComponentStep.basicInformation) ??
        validateStep(CreateNewComponentStep.calculation) ??
        validateStep(CreateNewComponentStep.payrollAccounting);
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}

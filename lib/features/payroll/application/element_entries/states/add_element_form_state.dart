import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';

enum AddElementTab { generalInformation, costing }

class AddElementFormDefaults {
  const AddElementFormDefaults({required this.creatorType});

  final String creatorType;
}

class AddElementFormState {
  const AddElementFormState({
    this.isInitialized = false,
    this.assignmentNumber = '',
    this.effectiveAsOfDate,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.entryType,
    this.source,
    this.elementProcessingType,
    this.elementComponent,
    this.elementClassification,
    this.creatorType,
    this.payValue = '',
    this.contextSegment,
    this.subpriority = '',
    this.sequenceNumber = '1',
    this.reason = '',
    this.amount = '',
    this.costAllocationKeyFlexfield,
    this.costingType,
    this.accountCode = '',
    this.costCentre = '',
    this.processed = false,
    this.retroactiveEntry = false,
    this.automaticEntry = false,
    this.selectedTab = AddElementTab.generalInformation,
    this.isSavingDraft = false,
    this.isSubmitting = false,
    this.referenceDate,
  });

  final bool isInitialized;
  final String assignmentNumber;
  final DateTime? effectiveAsOfDate;
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String? entryType;
  final String? source;
  final String? elementProcessingType;
  final EmployeeAssignedComponent? elementComponent;
  final String? elementClassification;
  final String? creatorType;
  final String payValue;
  final String? contextSegment;
  final String subpriority;
  final String sequenceNumber;
  final String reason;
  final String amount;
  final String? costAllocationKeyFlexfield;
  final String? costingType;
  final String accountCode;
  final String costCentre;
  final bool processed;
  final bool retroactiveEntry;
  final bool automaticEntry;
  final AddElementTab selectedTab;
  final bool isSavingDraft;
  final bool isSubmitting;
  final DateTime? referenceDate;

  bool get hasCostingOverrides =>
      (costAllocationKeyFlexfield != null && costAllocationKeyFlexfield!.isNotEmpty) ||
      (costingType != null && costingType!.isNotEmpty) ||
      accountCode.trim().isNotEmpty ||
      costCentre.trim().isNotEmpty;

  static final DateTime defaultEffectiveDate = DateTime(2026, 6, 1);

  factory AddElementFormState.initial({String assignmentNumber = ''}) {
    return AddElementFormState(
      assignmentNumber: assignmentNumber,
      effectiveAsOfDate: defaultEffectiveDate,
      referenceDate: defaultEffectiveDate,
    );
  }

  AddElementFormState copyWith({
    bool? isInitialized,
    String? assignmentNumber,
    DateTime? effectiveAsOfDate,
    DateTime? effectiveStartDate,
    DateTime? effectiveEndDate,
    bool clearEffectiveStartDate = false,
    bool clearEffectiveEndDate = false,
    String? entryType,
    String? source,
    String? elementProcessingType,
    EmployeeAssignedComponent? elementComponent,
    bool clearElementComponent = false,
    String? elementClassification,
    String? creatorType,
    String? payValue,
    String? contextSegment,
    bool clearContextSegment = false,
    String? subpriority,
    String? sequenceNumber,
    String? reason,
    String? amount,
    String? costAllocationKeyFlexfield,
    bool clearCostAllocationKeyFlexfield = false,
    String? costingType,
    bool clearCostingType = false,
    String? accountCode,
    String? costCentre,
    bool? processed,
    bool? retroactiveEntry,
    bool? automaticEntry,
    AddElementTab? selectedTab,
    bool? isSavingDraft,
    bool? isSubmitting,
    DateTime? referenceDate,
  }) {
    return AddElementFormState(
      isInitialized: isInitialized ?? this.isInitialized,
      assignmentNumber: assignmentNumber ?? this.assignmentNumber,
      effectiveAsOfDate: effectiveAsOfDate ?? this.effectiveAsOfDate,
      effectiveStartDate: clearEffectiveStartDate ? null : (effectiveStartDate ?? this.effectiveStartDate),
      effectiveEndDate: clearEffectiveEndDate ? null : (effectiveEndDate ?? this.effectiveEndDate),
      entryType: entryType ?? this.entryType,
      source: source ?? this.source,
      elementProcessingType: elementProcessingType ?? this.elementProcessingType,
      elementComponent: clearElementComponent ? null : (elementComponent ?? this.elementComponent),
      elementClassification: elementClassification ?? this.elementClassification,
      creatorType: creatorType ?? this.creatorType,
      payValue: payValue ?? this.payValue,
      contextSegment: clearContextSegment ? null : (contextSegment ?? this.contextSegment),
      subpriority: subpriority ?? this.subpriority,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      reason: reason ?? this.reason,
      amount: amount ?? this.amount,
      costAllocationKeyFlexfield: clearCostAllocationKeyFlexfield
          ? null
          : (costAllocationKeyFlexfield ?? this.costAllocationKeyFlexfield),
      costingType: clearCostingType ? null : (costingType ?? this.costingType),
      accountCode: accountCode ?? this.accountCode,
      costCentre: costCentre ?? this.costCentre,
      processed: processed ?? this.processed,
      retroactiveEntry: retroactiveEntry ?? this.retroactiveEntry,
      automaticEntry: automaticEntry ?? this.automaticEntry,
      selectedTab: selectedTab ?? this.selectedTab,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      referenceDate: referenceDate ?? this.referenceDate,
    );
  }
}

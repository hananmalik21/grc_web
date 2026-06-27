import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/hiring/application/offers/mappers/create_job_offer_request_mapper.dart';
import 'package:grc/features/hiring/application/offers/providers/job_offers_api_providers.dart';
import 'package:grc/features/hiring/application/offers/providers/offers_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/offers/states/create_offer_state.dart';
import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_notifier.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferNotifier extends AutoDisposeNotifier<CreateOfferState> {
  @override
  CreateOfferState build() => const CreateOfferState();

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  String? tryGoNext({String? compensationStepError}) {
    final error = validateStep(state.currentStep, compensationStepError: compensationStepError);
    if (error != null) return error;

    nextStep();
    return null;
  }

  String? validateStep(int step, {String? compensationStepError}) {
    switch (step) {
      case 0:
        if (state.selectedCandidate == null && _isBlank(state.candidateName)) return 'Candidate is required';
        if (state.selectedApplication == null) return 'Application is required';
        if (state.selectedPosition == null) return 'Job Title is required';
        if (_isBlank(state.gradeLevel)) return 'Grade/Level is required';
        if (state.selectedDepartmentOrgUnit == null) {
          return 'Organization unit is required';
        }
        if (_isBlank(state.workLocation)) return 'Location is required';
        if (state.workMode == null) return 'Work Mode is required';
        if (state.selectedContractType == null) return 'Contract Type is required';
        if (state.proposedStartDate == null) return 'Proposed Start Date is required';
        return null;
      case 1:
        return compensationStepError;
      case 2:
        if (_isBlank(state.retirementPlan)) return 'Retirement Plan is required';
        if (_isBlank(state.ptoDays)) return 'PTO Days is required';
        if (_isBlank(state.sickDays)) return 'Sick Days is required';
        if (_isBlank(state.personalDays)) return 'Personal Days is required';
        if (_isBlank(state.parentalLeave)) return 'Parental Leave is required';
        if (state.additionalBenefits.isEmpty) {
          return 'At least one additional benefit is required';
        }
        return null;
      case 3:
        if (_isBlank(state.probationPeriod)) return 'Probation Period is required';
        if (state.offerExpiryDate == null) return 'Offer Expiry Date is required';
        return null;
      default:
        return null;
    }
  }

  bool _isBlank(String? value) => value == null || value.trim().isEmpty;

  void setSelectedApplication(Application? application) {
    if (application == null) {
      state = state.copyWith(clearSelectedApplication: true);
      return;
    }

    state = state.copyWith(selectedApplication: application);
  }

  void setSelectedPosition(Position position) {
    state = state.copyWith(
      selectedPosition: position,
      jobTitle: position.titleEnglish,
      gradeLevel: position.grade.isNotEmpty ? position.grade : null,
    );
  }

  void setOrgLevelSelections(Map<String, OrgUnit> selections) {
    state = state.copyWith(orgLevelSelections: selections, clearOrgLevelSelections: selections.isEmpty);
  }

  void setSelectedDepartmentOrgUnit(OrgUnit? unit) {
    if (unit == null) {
      state = state.copyWith(
        clearSelectedDepartmentOrgUnit: true,
        clearDepartment: true,
        clearOrgLevelSelections: true,
      );
      return;
    }

    final nameEn = unit.orgUnitNameEn.trim();
    final nameAr = unit.orgUnitNameAr.trim();
    final label = nameEn.isNotEmpty ? nameEn : (nameAr.isNotEmpty ? nameAr : unit.orgUnitCode);
    state = state.copyWith(selectedDepartmentOrgUnit: unit, department: label);
  }

  void clearOrgPrefillPath() {
    state = state.copyWith(clearOrgPrefillPath: true);
  }

  void setReportingTo(EmployeeListItem? value) {
    if (value == null) {
      state = state.copyWith(clearSelectedReportingTo: true, clearReportsTo: true);
      return;
    }

    final name = value.fullName.trim();
    state = state.copyWith(selectedReportingTo: value, reportsTo: name.isNotEmpty ? name : value.fullNameDisplay);
  }

  void updateBasicDetails({
    CandidateData? selectedCandidate,
    String? candidateName,
    String? jobTitle,
    String? gradeLevel,
    String? workLocation,
    String? workMode,
    DateTime? offerDate,
    DateTime? proposedStartDate,
    String? comments,
  }) {
    state = state.copyWith(
      selectedCandidate: selectedCandidate ?? state.selectedCandidate,
      candidateName: candidateName ?? state.candidateName,
      jobTitle: jobTitle ?? state.jobTitle,
      gradeLevel: gradeLevel ?? state.gradeLevel,
      workLocation: workLocation ?? state.workLocation,
      workMode: workMode ?? state.workMode,
      offerDate: offerDate ?? state.offerDate,
      proposedStartDate: proposedStartDate ?? state.proposedStartDate,
      comments: comments ?? state.comments,
    );
  }

  void setSelectedContractType(EmplLookupValue contractType) {
    state = state.copyWith(selectedContractType: contractType);
  }

  void updateCompensation({
    String? baseSalary,
    String? currency,
    String? paymentFrequency,
    String? annualBonus,
    String? bonusStructure,
    String? signOnBonus,
    String? relocationAssistance,
    String? stockOptions,
    String? vestingPeriod,
    bool? bonusEligible,
    String? bonusPercentage,
    String? allowanceDetails,
  }) {
    state = state.copyWith(
      baseSalary: baseSalary ?? state.baseSalary,
      currency: currency ?? state.currency,
      paymentFrequency: paymentFrequency ?? state.paymentFrequency,
      annualBonus: annualBonus ?? state.annualBonus,
      bonusStructure: bonusStructure ?? state.bonusStructure,
      signOnBonus: signOnBonus ?? state.signOnBonus,
      relocationAssistance: relocationAssistance ?? state.relocationAssistance,
      stockOptions: stockOptions ?? state.stockOptions,
      vestingPeriod: vestingPeriod ?? state.vestingPeriod,
      bonusEligible: bonusEligible ?? state.bonusEligible,
      bonusPercentage: bonusPercentage ?? state.bonusPercentage,
      allowanceDetails: allowanceDetails ?? state.allowanceDetails,
    );
  }

  void updateBenefits({
    bool? healthInsurance,
    bool? dentalInsurance,
    bool? visionInsurance,
    bool? lifeInsurance,
    String? retirementPlan,
    String? ptoDays,
    String? sickDays,
    String? personalDays,
    String? parentalLeave,
    List<String>? additionalBenefits,
  }) {
    state = state.copyWith(
      healthInsurance: healthInsurance ?? state.healthInsurance,
      dentalInsurance: dentalInsurance ?? state.dentalInsurance,
      visionInsurance: visionInsurance ?? state.visionInsurance,
      lifeInsurance: lifeInsurance ?? state.lifeInsurance,
      retirementPlan: retirementPlan ?? state.retirementPlan,
      ptoDays: ptoDays ?? state.ptoDays,
      sickDays: sickDays ?? state.sickDays,
      personalDays: personalDays ?? state.personalDays,
      parentalLeave: parentalLeave ?? state.parentalLeave,
      additionalBenefits: additionalBenefits ?? state.additionalBenefits,
    );
  }

  void addAdditionalBenefit(String benefit) {
    if (!state.additionalBenefits.contains(benefit)) {
      state = state.copyWith(additionalBenefits: [...state.additionalBenefits, benefit]);
    }
  }

  void removeAdditionalBenefit(String benefit) {
    state = state.copyWith(additionalBenefits: state.additionalBenefits.where((b) => b != benefit).toList());
  }

  void updateTermsAndConditions({
    String? probationPeriod,
    String? noticePeriod,
    DateTime? offerExpiryDate,
    bool? backgroundCheckRequired,
    bool? drugTestRequired,
    bool? ndaRequired,
    bool? nonCompeteRequired,
    String? additionalTerms,
  }) {
    state = state.copyWith(
      probationPeriod: probationPeriod ?? state.probationPeriod,
      noticePeriod: noticePeriod ?? state.noticePeriod,
      offerExpiryDate: offerExpiryDate ?? state.offerExpiryDate,
      backgroundCheckRequired: backgroundCheckRequired ?? state.backgroundCheckRequired,
      drugTestRequired: drugTestRequired ?? state.drugTestRequired,
      ndaRequired: ndaRequired ?? state.ndaRequired,
      nonCompeteRequired: nonCompeteRequired ?? state.nonCompeteRequired,
      additionalTerms: additionalTerms ?? state.additionalTerms,
    );
  }

  void addAttachment(Document document) {
    state = state.copyWith(attachments: [...state.attachments, document]);
  }

  void removeAttachment(Document document) {
    state = state.copyWith(attachments: state.attachments.where((d) => d.id != document.id).toList());
  }

  Future<CreateOfferSubmitResult> submit({
    required AddCompensationPlansState compensationState,
    String? compensationStepError,
  }) async {
    for (var step = 0; step <= 3; step++) {
      final error = validateStep(step, compensationStepError: step == 1 ? compensationStepError : null);
      if (error != null) {
        state = state.copyWith(submitError: error, clearSubmitError: false);
        return CreateOfferSubmitResult(success: false, message: error);
      }
    }

    final enterpriseId = ref.read(offersTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      const message = 'Select an enterprise first';
      state = state.copyWith(submitError: message);
      return const CreateOfferSubmitResult(success: false, message: message);
    }

    if (state.selectedReportingTo?.employeeIdNum == null) {
      const message = 'Reporting manager is required';
      state = state.copyWith(submitError: message);
      return const CreateOfferSubmitResult(success: false, message: message);
    }

    if (state.selectedPosition?.gradeId == null) {
      const message = 'Selected position must have a grade';
      state = state.copyWith(submitError: message);
      return const CreateOfferSubmitResult(success: false, message: message);
    }

    final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final input = CreateJobOfferRequestMapper.fromState(
        offerState: state,
        compensationState: compensationState,
        enterpriseId: enterpriseId,
        createdBy: createdBy,
      );

      final response = await ref.read(createJobOfferUseCaseProvider).call(input);
      final message = _messageFromResponse(response);
      state = state.copyWith(isSubmitting: false);
      return CreateOfferSubmitResult(success: true, message: message);
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return CreateOfferSubmitResult(success: false, message: e.message);
    } catch (_) {
      const message = 'Failed to create job offer. Please try again.';
      state = state.copyWith(isSubmitting: false, submitError: message);
      return const CreateOfferSubmitResult(success: false, message: message);
    }
  }

  String? _messageFromResponse(Map<String, dynamic> response) {
    final message = response['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
    return null;
  }

  void reset() {
    state = const CreateOfferState();
  }
}

final createOfferProvider = AutoDisposeNotifierProvider<CreateOfferNotifier, CreateOfferState>(CreateOfferNotifier.new);

final createOfferContractTypeLookupValuesProvider = FutureProvider<List<EmplLookupValue>>((ref) async {
  final tenantId = ref.watch(offersTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <EmplLookupValue>[];

  return ref.watch(emplLookupValuesForTypeProvider((enterpriseId: tenantId, typeCode: 'CONTRACT_TYPE')).future);
});

final createOfferPositionNotifierProvider = StateNotifierProvider<PositionNotifier, PaginationState<Position>>((ref) {
  final tenantId = ref.watch(offersTabEnterpriseIdProvider);
  final notifier = PositionNotifier(
    ref.watch(getPositionsUseCaseProvider),
    ref.watch(createPositionUseCaseProvider),
    ref.watch(updatePositionUseCaseProvider),
    ref.watch(deletePositionUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final createOfferOrgStructureNotifierProvider = StateNotifierProvider<OrgStructureNotifier, OrgStructureState>((ref) {
  final tenantId = ref.watch(offersTabEnterpriseIdProvider);
  return OrgStructureNotifier(
    getActiveOrgStructureLevelsUseCase: ref.read(getActiveOrgStructureLevelsUseCaseProvider),
    tenantId: tenantId,
  );
});

final createOfferEnterpriseSelectionProvider =
    StateNotifierProvider.family<
      EnterpriseSelectionNotifier,
      EnterpriseSelectionState,
      ({List<OrgStructureLevel> levels, String structureId})
    >((ref, params) {
      final tenantId = ref.watch(offersTabEnterpriseIdProvider);
      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: params.levels,
        structureId: params.structureId,
        tenantId: tenantId,
      );
    });

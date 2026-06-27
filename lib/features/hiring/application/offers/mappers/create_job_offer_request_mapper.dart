import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/hiring/application/offers/states/create_offer_state.dart';
import 'package:grc/features/hiring/domain/models/job_offers/create_job_offer_input.dart';

class CreateJobOfferRequestMapper {
  CreateJobOfferRequestMapper._();

  static const String defaultComments = 'Offer generated from Digify HR';

  static CreateJobOfferInput fromState({
    required CreateOfferState offerState,
    required AddCompensationPlansState compensationState,
    required int enterpriseId,
    required String createdBy,
  }) {
    final application = offerState.selectedApplication!;
    final candidate = offerState.selectedCandidate!;
    final position = offerState.selectedPosition!;
    final department = offerState.selectedDepartmentOrgUnit!;
    final contractType = offerState.selectedContractType!;
    final reportingManager = offerState.selectedReportingTo!;

    return CreateJobOfferInput(
      enterpriseId: enterpriseId,
      applicationGuid: application.applicationGuid,
      candidateGuid: candidate.id,
      postingId: application.postingId,
      jobTitle: offerState.jobTitle!.trim(),
      positionId: position.id,
      departmentId: department.orgUnitId,
      location: offerState.workLocation!.trim(),
      workModeCode: workModeCodeFromLabel(offerState.workMode),
      employmentTypeCode: contractType.lookupCode.trim(),
      gradeId: position.gradeId ?? 0,
      reportingManagerId: reportingManager.employeeIdNum ?? 0,
      startDate: DateTimeUtils.formatYmd(offerState.proposedStartDate!),
      comments: _resolveComments(offerState.comments),
      components: _mapComponents(compensationState),
      benefits: _mapBenefits(offerState),
      terms: _mapTerms(offerState),
      createdBy: createdBy,
    );
  }

  static List<CreateJobOfferComponentInput> _mapComponents(AddCompensationPlansState compensationState) {
    return [
      for (final plan in compensationState.addedPlans)
        for (final component in compensationState.effectiveComponentsForPlan(plan))
          CreateJobOfferComponentInput(
            planId: plan.planId,
            componentId: component.componentId,
            amount: compensationState.amountFor(plan.planId, component.componentId),
            currencyCode: compensationState.selectedCurrency,
            frequencyCode: (component.frequencyCode ?? 'MONTHLY').trim().toUpperCase(),
          ),
    ];
  }

  static CreateJobOfferBenefitsInput _mapBenefits(CreateOfferState state) {
    return CreateJobOfferBenefitsInput(
      healthInsurance: _yn(state.healthInsurance),
      dentalInsurance: _yn(state.dentalInsurance),
      visionInsurance: _yn(state.visionInsurance),
      lifeInsurance: _yn(state.lifeInsurance),
      retirementPlan: state.retirementPlan!.trim(),
      ptoDays: _parseRequiredInt(state.ptoDays),
      sickDays: _parseRequiredInt(state.sickDays),
      personalDays: _parseRequiredInt(state.personalDays),
      parentalLeave: state.parentalLeave!.trim(),
      additionalBenefits: state.additionalBenefits.join(','),
    );
  }

  static CreateJobOfferTermsInput _mapTerms(CreateOfferState state) {
    return CreateJobOfferTermsInput(
      probationPeriod: state.probationPeriod!.trim(),
      offerExpiryDate: DateTimeUtils.formatYmd(state.offerExpiryDate!),
      backgroundCheckRequired: _yn(state.backgroundCheckRequired),
      drugTestRequired: _yn(state.drugTestRequired),
      ndaRequired: _yn(state.ndaRequired),
      nonCompeteRequired: _yn(state.nonCompeteRequired),
      additionalTerms: state.additionalTerms?.trim() ?? '',
    );
  }

  static String _resolveComments(String? comments) {
    final trimmed = comments?.trim() ?? '';
    return trimmed.isNotEmpty ? trimmed : defaultComments;
  }

  static String workModeCodeFromLabel(String? label) {
    if (label == null || label.trim().isEmpty) return '';

    switch (label.trim().toLowerCase()) {
      case 'on-site':
      case 'onsite':
        return 'ONSITE';
      case 'remote':
        return 'REMOTE';
      case 'hybrid':
        return 'HYBRID';
      default:
        return label.trim().toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');
    }
  }

  static String _yn(bool value) => value ? 'Y' : 'N';

  static int _parseRequiredInt(String? value) {
    return int.tryParse(value?.trim() ?? '') ?? 0;
  }
}

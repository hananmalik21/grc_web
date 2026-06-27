import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/utils/form_validators.dart';
import 'package:grc/core/utils/phone_number_utils.dart';
import 'package:grc/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/update_employee_basic_info_request.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_address_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_banking_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_basic_info_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_documents_provider.dart';
import 'package:grc/features/employee_management/application/add_employee_compensation/providers/add_employee_compensation_providers.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_demographics_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_editing_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_stepper_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_work_schedule_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_full_details_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_org_structure_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeDialogFlow {
  AddEmployeeDialogFlow(this._ref);

  final Ref _ref;

  void clearForm() {
    _ref.read(addEmployeeStepperProvider.notifier).reset();
    _ref.read(addEmployeeBasicInfoProvider.notifier).reset();
    _ref.read(addEmployeeDemographicsProvider.notifier).reset();
    _ref.read(addEmployeeAddressProvider.notifier).reset();
    _ref.read(addEmployeeWorkScheduleProvider.notifier).reset();
    _ref.read(addEmployeeAssignmentProvider.notifier).reset();
    _ref.read(addEmployeeJobEmploymentProvider.notifier).reset();
    _ref.invalidate(addEmployeeCompensationProvider);
    _ref.read(addEmployeeBankingProvider.notifier).reset();
    _ref.read(addEmployeeDocumentsProvider.notifier).reset();
  }

  void close(BuildContext context) {
    clearForm();
    _ref.read(addEmployeeEditingEmployeeIdProvider.notifier).state = null;
    if (context.mounted) Navigator.of(context).pop(context);
  }

  void prefillFromFullDetails(EmployeeFullDetails d, int enterpriseId) {
    final emp = d.employee;
    final asg = d.assignment;
    final demo = d.demographics;
    final ws = d.workSchedule;
    final docComp = d.documentCompliance;
    final emerg = d.emergencyContacts.isNotEmpty ? d.emergencyContacts.first : null;
    final addr = d.addresses.isNotEmpty ? d.addresses.first : null;
    final bank = d.bankAccounts.isNotEmpty ? d.bankAccounts.first : null;

    final request = CreateEmployeeBasicInfoRequest(
      firstNameEn: emp.firstNameEn,
      middleNameEn: emp.middleNameEn,
      lastNameEn: emp.lastNameEn,
      fourthNameEn: emp.fourthNameEn,
      firstNameAr: emp.firstNameAr,
      middleNameAr: emp.middleNameAr,
      lastNameAr: emp.lastNameAr,
      fourthNameAr: emp.fourthNameAr,
      email: emp.email,
      phoneNumber: PhoneNumberUtils.split(emp.phoneNumber).national,
      phoneDialCode: PhoneNumberUtils.split(emp.phoneNumber).dialCode,
      mobileNumber: PhoneNumberUtils.split(emp.mobileNumber).national,
      mobileDialCode: PhoneNumberUtils.split(emp.mobileNumber).dialCode,
      dateOfBirth: _parseDate(emp.dateOfBirth),
      addressLine1: addr?.addressLine1,
      addressLine2: addr?.addressLine2,
      city: addr?.city,
      area: addr?.area,
      countryCode: addr?.countryCode,
      enterpriseId: enterpriseId,
      emergAddress: emerg?.address ?? addr?.addressLine1,
      emergPhone: emerg?.phoneNumber,
      emergEmail: emerg?.email,
      emergRelationship: emerg?.relationshipCode,
      contactName: emerg?.contactName,
      workScheduleId: ws?.workScheduleId,
      wsStart: _parseDate(ws?.wsStart),
      wsEnd: _parseDate(ws?.wsEnd),
      orgUnitIdHex: asg.orgUnitId,
      asgStart: _parseDate(asg.enterpriseHireDate),
      asgEnd: _parseDate(asg.effectiveEndDate),
      workLocation: addr?.addressLine1,
      workLocationId: asg.workLocationId ?? emp.workLocationId,
      lookupCodesByTypeCode: demo != null
          ? {
              'GENDER': demo.genderCode,
              'NATIONALITY': demo.nationalityCode,
              'MARITAL_STATUS': demo.maritalStatusCode,
              'RELIGION': demo.religionCode,
            }
          : null,
      civilIdNumber: demo?.civilIdNumber,
      passportNumber: demo?.passportNumber,
      positionIdHex: asg.positionId,
      enterpriseHireDate: _parseDate(asg.enterpriseHireDate),
      jobFamilyId: asg.jobFamilyId ?? emp.jobFamilyId,
      jobLevelId: asg.jobLevelId ?? emp.jobLevelId,
      gradeId: asg.gradeId ?? emp.gradeId,
      probationDays: asg.probationDays ?? emp.probationDays,
      contractTypeCode: asg.contractTypeCode,
      employmentStatusCode: asg.employmentStatus,
      employeeStatus: emp.employeeStatus ?? asg.employmentStatus,
      reportingToEmpId: asg.reportingToEmpId ?? emp.reportingToEmpId,
      bankCode: bank?.bankCode,
      bankName: bank?.bankName,
      accountNumber: bank?.accountNumber,
      iban: bank?.iban,
      civilIdExpiry: _parseDate(docComp?.civilIdExpiry),
      passportExpiry: _parseDate(docComp?.passportExpiry),
      visaNumber: demo?.visaNumber,
      visaExpiry: _parseDate(demo?.visaExpiry),
      workPermitNumber: demo?.workPermitNumber,
      workPermitExpiry: _parseDate(demo?.workPermitExpiry),
    );

    _ref.read(addEmployeeBasicInfoProvider.notifier).setForm(request);
    _ref
        .read(addEmployeeDemographicsProvider.notifier)
        .setFromFullDetails(
          lookupCodesByTypeCode: request.lookupCodesByTypeCode,
          civilIdNumber: request.civilIdNumber,
          passportNumber: request.passportNumber,
        );
    _ref
        .read(addEmployeeAddressProvider.notifier)
        .setFromFullDetails(
          addressLine1: addr?.addressLine1,
          addressLine2: addr?.addressLine2,
          city: addr?.city,
          area: addr?.area,
          countryCode: addr?.countryCode,
          emergAddress: request.emergAddress,
          emergPhone: request.emergPhone,
          emergEmail: request.emergEmail,
          emergRelationship: request.emergRelationship,
          contactName: request.contactName,
        );
    _ref
        .read(addEmployeeAssignmentProvider.notifier)
        .setFromFullDetails(
          orgUnitIdHex: asg.orgUnitId,
          orgStructureList: asg.orgStructureList,
          asgStart: request.asgStart,
          asgEnd: request.asgEnd,
          workLocation: request.workLocation,
          workLocationId: request.workLocationId,
        );
    _ref
        .read(addEmployeeWorkScheduleProvider.notifier)
        .setFromFullDetails(wsStart: request.wsStart, wsEnd: request.wsEnd, workScheduleId: ws?.workScheduleId);

    final positionFromApi = _positionFromAssignment(asg);
    final jobFamilyFromApi = _jobFamilyFromAssignment(asg);
    final jobLevelFromApi = _jobLevelFromAssignment(asg);
    final gradeFromApi = _gradeFromAssignment(asg);

    _ref
        .read(addEmployeeJobEmploymentProvider.notifier)
        .setFromFullDetails(
          enterpriseHireDate: request.enterpriseHireDate,
          probationDays: request.probationDays,
          contractTypeCode: request.contractTypeCode,
          employmentStatusCode: request.employmentStatusCode,
          positionIdHex: asg.positionId,
          jobFamilyId: asg.jobFamilyId ?? emp.jobFamilyId,
          jobLevelId: asg.jobLevelId ?? emp.jobLevelId,
          gradeId: asg.gradeId ?? emp.gradeId,
          reportingToEmpId: asg.reportingToEmpId ?? emp.reportingToEmpId,
          selectedPosition: positionFromApi,
          selectedJobFamily: jobFamilyFromApi,
          selectedJobLevel: jobLevelFromApi,
          selectedGrade: gradeFromApi,
        );
    _ref
        .read(addEmployeeBankingProvider.notifier)
        .setFromFullDetails(
          bankCode: request.bankCode,
          bankName: request.bankName,
          accountNumber: request.accountNumber,
          iban: request.iban,
        );
    _ref
        .read(addEmployeeDocumentsProvider.notifier)
        .setFromFullDetails(
          civilIdExpiry: request.civilIdExpiry,
          passportExpiry: request.passportExpiry,
          visaNumber: request.visaNumber,
          visaExpiry: request.visaExpiry,
          workPermitNumber: request.workPermitNumber,
          workPermitExpiry: request.workPermitExpiry,
          documentTypeCode: d.documents.isNotEmpty ? d.documents.first.documentTypeCode : null,
          existingDocumentFileName: d.documents.isNotEmpty ? d.documents.first.fileName : null,
          documents: d.documents,
        );
  }

  static DateTime? _parseDate(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    return DateTime.tryParse(s);
  }

  static Position? _positionFromAssignment(AssignmentDetailSection asg) {
    final p = asg.position;
    if (p == null || (p.positionId.isEmpty && p.positionNameEn.isEmpty)) return null;
    return Position(
      id: p.positionId,
      code: p.positionCode,
      titleEnglish: p.positionNameEn,
      titleArabic: p.positionNameAr,
      department: '',
      jobFamily: '',
      level: '',
      grade: '',
      step: '',
      reportsTo: null,
      division: '',
      costCenter: '',
      location: '',
      budgetedMin: '',
      budgetedMax: '',
      actualAverage: '',
      headcount: 0,
      filled: 0,
      vacant: 0,
      isActive: true,
    );
  }

  static JobFamily? _jobFamilyFromAssignment(AssignmentDetailSection asg) {
    final jf = asg.jobFamily;
    if (jf == null) return null;
    return JobFamily(
      id: jf.jobFamilyId,
      code: jf.jobFamilyCode,
      nameEnglish: jf.jobFamilyNameEn,
      nameArabic: jf.jobFamilyNameAr,
      description: '',
      totalPositions: 0,
      filledPositions: 0,
      fillRate: 0,
      isActive: true,
    );
  }

  static JobLevel? _jobLevelFromAssignment(AssignmentDetailSection asg) {
    final jl = asg.jobLevel;
    if (jl == null) return null;
    return JobLevel(
      id: jl.jobLevelId,
      nameEn: jl.jobLevelNameEn,
      code: jl.jobLevelCode,
      description: '',
      minGradeId: jl.minGradeId,
      maxGradeId: jl.maxGradeId,
      status: 'ACTIVE',
    );
  }

  static final DateTime _dummyDate = DateTime(1970, 1, 1);

  static Grade? _gradeFromAssignment(AssignmentDetailSection asg) {
    final g = asg.grade;
    if (g == null) return null;
    return Grade(
      id: g.gradeId,
      gradeNumber: g.gradeNumber,
      gradeCategory: g.gradeCategory,
      currencyCode: g.currencyCode,
      step1Salary: g.step1Salary,
      step2Salary: g.step2Salary,
      step3Salary: g.step3Salary,
      step4Salary: g.step4Salary,
      step5Salary: g.step5Salary,
      description: '',
      status: g.gradeStatus,
      createdBy: '',
      createdDate: _dummyDate,
      lastUpdatedBy: '',
      lastUpdatedDate: _dummyDate,
      lastUpdateLogin: '',
    );
  }

  void goPrevious() {
    _ref.read(addEmployeeStepperProvider.notifier).previousStep();
  }

  void goNext(BuildContext context) {
    final stepperState = _ref.read(addEmployeeStepperProvider);
    final localizations = AppLocalizations.of(context)!;

    if (stepperState.currentStepIndex == 0) {
      final basicInfoState = _ref.read(addEmployeeBasicInfoProvider);
      final form = basicInfoState.form;

      if (!form.isEmailValid) {
        ToastService.error(context, localizations.invalidEmail);
        return;
      }

      if (!form.isPhoneValid) {
        ToastService.error(context, localizations.invalidPhone);
        return;
      }

      if (!form.isStep1Valid) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    if (stepperState.currentStepIndex == 1) {
      final demographics = _ref.read(addEmployeeDemographicsProvider);
      final requiredTypeCodes = demographicsStepTypeCodes;
      if (!demographics.isStepValid(requiredTypeCodes)) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    if (stepperState.currentStepIndex == 2) {
      final addressState = _ref.read(addEmployeeAddressProvider);
      if (FormValidators.phone(addressState.emergPhone) != null) {
        ToastService.error(context, localizations.invalidPhone);
        return;
      }
      if (FormValidators.email(addressState.emergEmail) != null) {
        ToastService.error(context, localizations.invalidEmail);
        return;
      }
      if (!addressState.isStepValid) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    if (stepperState.currentStepIndex == 3) {
      final assignmentState = _ref.read(addEmployeeAssignmentProvider);
      final enterpriseId = _ref.read(manageEmployeesEnterpriseIdProvider);
      final requiredLevelCodes = enterpriseId != null
          ? _ref.read(addEmployeeOrgStructureNotifierProvider(enterpriseId)).activeLevels.map((l) => l.levelCode)
          : <String>[];
      if (!assignmentState.isStepValid(requiredLevelCodes)) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
      final jobState = _ref.read(addEmployeeJobEmploymentProvider);
      if (!jobState.isStepValid) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    if (stepperState.currentStepIndex == 4) {
      final workScheduleState = _ref.read(addEmployeeWorkScheduleProvider);
      if (!workScheduleState.isStepValid) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    if (stepperState.currentStepIndex == 5) {
      final editingId = _ref.read(addEmployeeEditingEmployeeIdProvider);
      if (editingId == null || editingId.isEmpty) {
        final plansNotifier = _ref.read(addEmployeeCompensationProvider.notifier);
        if (!plansNotifier.validate(requireExplicitEffectiveDate: true)) {
          final message = _ref.read(addEmployeeCompensationProvider).errorMessage;
          ToastService.error(context, message ?? localizations.addEmployeeFillRequiredFields);
          return;
        }
      }
    }

    if (stepperState.currentStepIndex == 6) {
      final bankingState = _ref.read(addEmployeeBankingProvider);
      if (!bankingState.isStepValid) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    if (stepperState.currentStepIndex == 7) {
      final documentsState = _ref.read(addEmployeeDocumentsProvider);
      if (!documentsState.isStepValid) {
        ToastService.error(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    _ref.read(addEmployeeStepperProvider.notifier).nextStep();
    logAddEmployeeState(_ref);
  }

  Future<void> saveAndClose(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final basicState = _ref.read(addEmployeeBasicInfoProvider);
    final addressState = _ref.read(addEmployeeAddressProvider);
    final workScheduleState = _ref.read(addEmployeeWorkScheduleProvider);
    final assignmentState = _ref.read(addEmployeeAssignmentProvider);
    final demographicsState = _ref.read(addEmployeeDemographicsProvider);
    final jobState = _ref.read(addEmployeeJobEmploymentProvider);
    final editingId = _ref.read(addEmployeeEditingEmployeeIdProvider);
    final isEdit = editingId != null && editingId.isNotEmpty;
    final compensationPlansState = isEdit ? null : _ref.read(addEmployeeCompensationProvider);
    final enterpriseId = _ref.read(manageEmployeesEnterpriseIdProvider);

    if (!jobState.isStepValid) {
      ToastService.error(context, localizations.addEmployeeFillRequiredFields);
      return;
    }
    if (editingId == null || editingId.isEmpty) {
      if (!_ref.read(addEmployeeCompensationProvider.notifier).validate(requireExplicitEffectiveDate: true)) {
        final message = _ref.read(addEmployeeCompensationProvider).errorMessage;
        ToastService.error(context, message ?? localizations.addEmployeeFillRequiredFields);
        return;
      }
    }
    if (!workScheduleState.isStepValid) {
      ToastService.error(context, localizations.addEmployeeFillRequiredFields);
      return;
    }
    final requiredLevelCodes = enterpriseId != null
        ? _ref.read(addEmployeeOrgStructureNotifierProvider(enterpriseId)).activeLevels.map((l) => l.levelCode)
        : <String>[];
    if (!assignmentState.isStepValid(requiredLevelCodes)) {
      ToastService.error(context, localizations.addEmployeeFillRequiredFields);
      return;
    }
    final bankingState = _ref.read(addEmployeeBankingProvider);
    if (!bankingState.isStepValid) {
      ToastService.error(context, localizations.addEmployeeFillRequiredFields);
      return;
    }
    final documentsState = _ref.read(addEmployeeDocumentsProvider);
    if (!documentsState.isStepValid) {
      ToastService.error(context, localizations.addEmployeeFillRequiredFields);
      return;
    }
    final request = basicState.form.copyWith(
      addressLine1: _emptyToNull(addressState.addressLine1),
      addressLine2: _emptyToNull(addressState.addressLine2),
      city: _emptyToNull(addressState.city),
      area: _emptyToNull(addressState.area),
      countryCode: _emptyToNull(addressState.countryCode),
      emergAddress: _emptyToNull(addressState.emergAddress),
      emergPhone: _emptyToNull(addressState.emergPhone),
      emergEmail: _emptyToNull(addressState.emergEmail),
      emergRelationship: _emptyToNull(addressState.emergRelationship),
      contactName: _emptyToNull(addressState.contactName),
      workScheduleId: workScheduleState.workScheduleId,
      wsStart: workScheduleState.wsStart,
      wsEnd: workScheduleState.wsEnd,
      orgUnitIdHex: _emptyToNull(assignmentState.orgUnitIdHex),
      workLocation: _emptyToNull(assignmentState.workLocation),
      workLocationId: assignmentState.workLocationId,
      asgStart: assignmentState.asgStart,
      asgEnd: assignmentState.asgEnd,
      lookupCodesByTypeCode: demographicsState.lookupCodesByTypeCode,
      civilIdNumber: _emptyToNull(demographicsState.civilIdNumber),
      passportNumber: _emptyToNull(demographicsState.passportNumber),
      positionIdHex: jobState.selectedPosition?.id != null && jobState.selectedPosition!.id.isNotEmpty
          ? jobState.selectedPosition!.id
          : null,
      enterpriseHireDate: jobState.enterpriseHireDate,
      jobFamilyId: jobState.selectedJobFamily?.id,
      jobLevelId: jobState.selectedJobLevel?.id,
      gradeId: jobState.selectedGrade?.id,
      probationDays: jobState.probationDays,
      contractTypeCode: _emptyToNull(jobState.contractTypeCode),
      employmentStatusCode: _emptyToNull(jobState.employmentStatusCode),
      reportingToEmpId: jobState.selectedReportingTo?.employeeIdNum,
      enterpriseId: enterpriseId,
      compensationComponents: isEdit ? null : compensationPlansState!.toCreateEmployeeCompensationComponents(),
      bankName: _emptyToNull(bankingState.bankName),
      bankCode: _emptyToNull(bankingState.bankCode),
      accountNumber: _emptyToNull(bankingState.accountNumber),
      iban: _emptyToNull(bankingState.iban),
      civilIdExpiry: documentsState.civilIdExpiry,
      passportExpiry: documentsState.passportExpiry,
      visaNumber: _emptyToNull(documentsState.visaNumber),
      visaExpiry: documentsState.visaExpiry,
      workPermitNumber: _emptyToNull(documentsState.workPermitNumber),
      workPermitExpiry: documentsState.workPermitExpiry,
    );
    final pendingDocOp = documentsState.pendingDocOp;
    final (
      Document? docToSend,
      String? docTypeCode,
      String? docAction,
      int? replaceDocId,
    ) = editingId != null && editingId.isNotEmpty && pendingDocOp != null
        ? (
            pendingDocOp.file,
            pendingDocOp.documentTypeCode,
            pendingDocOp.isAdd ? 'ADD' : 'REPLACE',
            pendingDocOp.replaceDocumentId,
          )
        : (documentsState.document, documentsState.documentTypeCode, null, null);
    final (ok, _) = editingId != null && editingId.isNotEmpty
        ? await _ref
              .read(addEmployeeBasicInfoProvider.notifier)
              .submitUpdate(
                editingId,
                UpdateEmployeeBasicInfoRequest.fromCreateRequest(request),
                document: docToSend,
                documentTypeCode: docTypeCode,
                docAction: docAction,
                replaceDocumentId: replaceDocId,
              )
        : await _ref
              .read(addEmployeeBasicInfoProvider.notifier)
              .submitWithRequest(request, document: docToSend, documentTypeCode: docTypeCode);
    if (!context.mounted) return;
    if (ok) {
      if (isEdit) {
        if (pendingDocOp != null) {
          _ref.read(addEmployeeDocumentsProvider.notifier).clearPendingDocOp();
        }
        _ref.invalidate(employeeFullDetailsProvider(editingId));
      }
      await _refreshEmployeeListAfterMutation(isCreate: !isEdit);
      if (!context.mounted) return;
      ToastService.success(context, AppLocalizations.of(context)!.addEmployeeCreatedSuccess);
      close(context);
    } else {
      final error = _ref.read(addEmployeeBasicInfoProvider).submitError;
      ToastService.error(context, error ?? AppLocalizations.of(context)!.addEmployeeFillRequiredFields);
    }
  }

  Future<void> _refreshEmployeeListAfterMutation({required bool isCreate}) async {
    final listNotifier = _ref.read(manageEmployeesListProvider.notifier);
    if (isCreate) {
      final enterpriseId = _ref.read(manageEmployeesEnterpriseIdProvider);
      if (enterpriseId != null) {
        await listNotifier.loadPage(enterpriseId, 1);
        return;
      }
    }
    await listNotifier.refresh();
  }
}

String? _emptyToNull(String? value) {
  final t = value?.trim();
  return t == null || t.isEmpty ? null : value;
}

final addEmployeeDialogFlowProvider = Provider<AddEmployeeDialogFlow>((ref) {
  return AddEmployeeDialogFlow(ref);
});

void logAddEmployeeState(dynamic ref) {
  final Ref r = ref as Ref;
  final stepper = r.read(addEmployeeStepperProvider);
  final basicInfo = r.read(addEmployeeBasicInfoProvider);
  final demographics = r.read(addEmployeeDemographicsProvider);
  final address = r.read(addEmployeeAddressProvider);
  final workSchedule = r.read(addEmployeeWorkScheduleProvider);
  final assignment = r.read(addEmployeeAssignmentProvider);
  final f = basicInfo.form;
  debugPrint('--- Add Employee State (step ${stepper.currentStepIndex + 1}) ---');
  debugPrint('Stepper: currentStepIndex=${stepper.currentStepIndex}');
  debugPrint(
    'Basic info: firstNameEn=${f.firstNameEn}, lastNameEn=${f.lastNameEn}, '
    'firstNameAr=${f.firstNameAr}, lastNameAr=${f.lastNameAr}, email=${f.email}, '
    'phoneNumber=${f.phoneNumber}, mobileNumber=${f.mobileNumber}, dateOfBirth=${f.dateOfBirth}',
  );
  debugPrint(
    'Demographics: lookupCodes=${demographics.lookupCodesByTypeCode}, '
    'civilIdNumber=${demographics.civilIdNumber}, passportNumber=${demographics.passportNumber}',
  );
  debugPrint(
    'Address: line1=${address.addressLine1}, line2=${address.addressLine2}, '
    'city=${address.city}, area=${address.area}, countryCode=${address.countryCode}, '
    'emergAddress=${address.emergAddress}, emergPhone=${address.emergPhone}, '
    'emergEmail=${address.emergEmail}, emergRelationship=${address.emergRelationship}, '
    'contactName=${address.contactName}',
  );
  debugPrint(
    'Work schedule: workScheduleId=${workSchedule.workScheduleId}, '
    'schedule=${workSchedule.selectedWorkSchedule?.scheduleNameEn}',
  );
  debugPrint('Assignment: orgUnitIdHex=${assignment.orgUnitIdHex}');
  debugPrint('---');
}

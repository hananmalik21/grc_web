import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeJobEmploymentState {
  final Position? selectedPosition;
  final JobFamily? selectedJobFamily;
  final JobLevel? selectedJobLevel;
  final Grade? selectedGrade;
  final DateTime? enterpriseHireDate;
  final int? probationDays;
  final String? contractTypeCode;
  final String? employmentStatusCode;
  final EmployeeListItem? selectedReportingTo;
  final int? prefillJobFamilyId;
  final String? prefillPositionId;
  final int? prefillJobLevelId;
  final int? prefillGradeId;
  final int? prefillReportingToEmpId;

  const AddEmployeeJobEmploymentState({
    this.selectedPosition,
    this.selectedJobFamily,
    this.selectedJobLevel,
    this.selectedGrade,
    this.enterpriseHireDate,
    this.probationDays,
    this.contractTypeCode,
    this.employmentStatusCode,
    this.selectedReportingTo,
    this.prefillJobFamilyId,
    this.prefillPositionId,
    this.prefillJobLevelId,
    this.prefillGradeId,
    this.prefillReportingToEmpId,
  });

  bool get isStepValid {
    if (selectedPosition == null) return false;
    final ct = contractTypeCode?.trim();
    if (ct == null || ct.isEmpty) return false;
    final es = employmentStatusCode?.trim();
    if (es == null || es.isEmpty) return false;
    if (enterpriseHireDate == null) return false;
    if (probationDays == null || probationDays! < 0) return false;
    return true;
  }

  AddEmployeeJobEmploymentState copyWith({
    Position? selectedPosition,
    JobFamily? selectedJobFamily,
    JobLevel? selectedJobLevel,
    Grade? selectedGrade,
    DateTime? enterpriseHireDate,
    int? probationDays,
    String? contractTypeCode,
    String? employmentStatusCode,
    bool clearPosition = false,
    bool clearJobFamily = false,
    bool clearJobLevel = false,
    bool clearGrade = false,
    bool clearEnterpriseHireDate = false,
    bool clearProbationDays = false,
    bool clearContractTypeCode = false,
    bool clearEmploymentStatusCode = false,
    EmployeeListItem? selectedReportingTo,
    bool clearSelectedReportingTo = false,
    int? prefillJobFamilyId,
    String? prefillPositionId,
    int? prefillJobLevelId,
    int? prefillGradeId,
    int? prefillReportingToEmpId,
    bool clearPrefillJobFamilyId = false,
    bool clearPrefillPositionId = false,
    bool clearPrefillJobLevelId = false,
    bool clearPrefillGradeId = false,
    bool clearPrefillReportingToEmpId = false,
  }) {
    return AddEmployeeJobEmploymentState(
      selectedPosition: clearPosition ? null : (selectedPosition ?? this.selectedPosition),
      selectedJobFamily: clearJobFamily ? null : (selectedJobFamily ?? this.selectedJobFamily),
      selectedJobLevel: clearJobLevel ? null : (selectedJobLevel ?? this.selectedJobLevel),
      selectedGrade: clearGrade ? null : (selectedGrade ?? this.selectedGrade),
      enterpriseHireDate: clearEnterpriseHireDate ? null : (enterpriseHireDate ?? this.enterpriseHireDate),
      probationDays: clearProbationDays ? null : (probationDays ?? this.probationDays),
      contractTypeCode: clearContractTypeCode ? null : (contractTypeCode ?? this.contractTypeCode),
      employmentStatusCode: clearEmploymentStatusCode ? null : (employmentStatusCode ?? this.employmentStatusCode),
      selectedReportingTo: clearSelectedReportingTo ? null : (selectedReportingTo ?? this.selectedReportingTo),
      prefillJobFamilyId: clearPrefillJobFamilyId ? null : (prefillJobFamilyId ?? this.prefillJobFamilyId),
      prefillPositionId: clearPrefillPositionId ? null : (prefillPositionId ?? this.prefillPositionId),
      prefillJobLevelId: clearPrefillJobLevelId ? null : (prefillJobLevelId ?? this.prefillJobLevelId),
      prefillGradeId: clearPrefillGradeId ? null : (prefillGradeId ?? this.prefillGradeId),
      prefillReportingToEmpId: clearPrefillReportingToEmpId
          ? null
          : (prefillReportingToEmpId ?? this.prefillReportingToEmpId),
    );
  }
}

class AddEmployeeJobEmploymentNotifier extends StateNotifier<AddEmployeeJobEmploymentState> {
  AddEmployeeJobEmploymentNotifier() : super(const AddEmployeeJobEmploymentState());

  void setPosition(Position? value) {
    state = state.copyWith(
      selectedPosition: value,
      selectedJobFamily: value?.jobFamilyRef,
      selectedJobLevel: value?.jobLevelRef,
      selectedGrade: value?.gradeRef,
      clearPosition: value == null,
      clearJobFamily: value == null,
      clearJobLevel: value == null,
      clearGrade: value == null,
      clearPrefillPositionId: value != null,
      clearPrefillJobFamilyId: value?.jobFamilyRef != null,
      clearPrefillJobLevelId: value?.jobLevelRef != null,
      clearPrefillGradeId: value?.gradeRef != null,
    );
  }

  void setJobFamily(JobFamily? value) {
    state = state.copyWith(
      selectedJobFamily: value,
      clearJobFamily: value == null,
      clearPrefillJobFamilyId: value != null,
    );
  }

  void setJobLevel(JobLevel? value) {
    state = state.copyWith(
      selectedJobLevel: value,
      clearJobLevel: value == null,
      clearPrefillJobLevelId: value != null,
    );
  }

  void setGrade(Grade? value) {
    state = state.copyWith(selectedGrade: value, clearGrade: value == null, clearPrefillGradeId: value != null);
  }

  void setEnterpriseHireDate(DateTime? value) {
    state = state.copyWith(enterpriseHireDate: value, clearEnterpriseHireDate: value == null);
  }

  void setProbationDays(int? value) {
    state = state.copyWith(probationDays: value, clearProbationDays: value == null);
  }

  void setContractTypeCode(String? value) {
    state = state.copyWith(contractTypeCode: value, clearContractTypeCode: value == null || value.isEmpty);
  }

  void setEmploymentStatusCode(String? value) {
    state = state.copyWith(employmentStatusCode: value, clearEmploymentStatusCode: value == null || value.isEmpty);
  }

  void setReportingTo(EmployeeListItem? value) {
    state = state.copyWith(
      selectedReportingTo: value,
      clearSelectedReportingTo: value == null,
      clearPrefillReportingToEmpId: value != null,
    );
  }

  void setFromFullDetails({
    DateTime? enterpriseHireDate,
    int? probationDays,
    String? contractTypeCode,
    String? employmentStatusCode,
    String? positionIdHex,
    int? jobFamilyId,
    int? jobLevelId,
    int? gradeId,
    int? reportingToEmpId,
    Position? selectedPosition,
    JobFamily? selectedJobFamily,
    JobLevel? selectedJobLevel,
    Grade? selectedGrade,
  }) {
    final usePositionFromApi = selectedPosition != null;
    final useJobFamilyFromApi = selectedJobFamily != null;
    final useJobLevelFromApi = selectedJobLevel != null;
    final useGradeFromApi = selectedGrade != null;
    state = state.copyWith(
      enterpriseHireDate: enterpriseHireDate ?? state.enterpriseHireDate,
      probationDays: probationDays ?? state.probationDays,
      contractTypeCode: contractTypeCode ?? state.contractTypeCode,
      employmentStatusCode: employmentStatusCode ?? state.employmentStatusCode,
      prefillPositionId: usePositionFromApi ? null : (positionIdHex ?? state.prefillPositionId),
      prefillJobFamilyId: useJobFamilyFromApi ? null : (jobFamilyId ?? state.prefillJobFamilyId),
      prefillJobLevelId: useJobLevelFromApi ? null : (jobLevelId ?? state.prefillJobLevelId),
      prefillGradeId: useGradeFromApi ? null : (gradeId ?? state.prefillGradeId),
      prefillReportingToEmpId: reportingToEmpId ?? state.prefillReportingToEmpId,
      selectedPosition: usePositionFromApi ? selectedPosition : state.selectedPosition,
      clearPosition: false,
      selectedJobFamily: useJobFamilyFromApi ? selectedJobFamily : state.selectedJobFamily,
      clearJobFamily: false,
      selectedJobLevel: useJobLevelFromApi ? selectedJobLevel : state.selectedJobLevel,
      clearJobLevel: false,
      selectedGrade: useGradeFromApi ? selectedGrade : state.selectedGrade,
      clearGrade: false,
      clearPrefillPositionId: usePositionFromApi,
      clearPrefillJobFamilyId: useJobFamilyFromApi,
      clearPrefillJobLevelId: useJobLevelFromApi,
      clearPrefillGradeId: useGradeFromApi,
    );
  }

  void reset() {
    state = const AddEmployeeJobEmploymentState();
  }
}

final addEmployeeJobEmploymentProvider =
    StateNotifierProvider<AddEmployeeJobEmploymentNotifier, AddEmployeeJobEmploymentState>((ref) {
      return AddEmployeeJobEmploymentNotifier();
    });

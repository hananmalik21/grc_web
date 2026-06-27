import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grc/features/compensation/data/datasources/employees/employee_compensation_plan_details_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/employees/employee_compensation_plan_details_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employee_compensation_plan_details_repository.dart';
import 'package:grc/features/compensation/domain/usecases/employees/get_employee_compensation_plan_details_usecase.dart';

class EmployeeCompensationDetailState {
  final bool isLoading;
  final String? error;

  final EmployeeCompensationPlanDetails? details;

  // Employee details
  final String employeeName;
  final String employeeNumber;
  final String position;
  final String employmentType;
  final String department;
  final String grade;
  final String hireDate;

  // Compensation Plan
  final String planName;
  final String planCode;
  final String salaryStructure;
  final String structureCode;
  final String effectiveDate;
  final String currency;

  // Components
  final double baseSalary;
  final double housingAllowance;
  final double transportAllowance;
  final double mobileAllowance;
  final double medicalBenefit;
  final double performanceBonus;

  const EmployeeCompensationDetailState({
    this.isLoading = false,
    this.error,
    this.details,
    this.employeeName = 'Sarah Johnson',
    this.employeeNumber = 'E-2456',
    this.position = 'Senior Software Engineer',
    this.employmentType = 'Full-time',
    this.department = 'Engineering',
    this.grade = 'L4',
    this.hireDate = '15/03/2022',
    this.planName = '2026 Executive Compensation Plan',
    this.planCode = 'EXEC-COMP-2026',
    this.salaryStructure = 'Executive Salary Structure',
    this.structureCode = 'EXEC-2024',
    this.effectiveDate = '01/01/2024',
    this.currency = 'USD',
    this.baseSalary = 8500,
    this.housingAllowance = 2125,
    this.transportAllowance = 800,
    this.mobileAllowance = 150,
    this.medicalBenefit = 300,
    this.performanceBonus = 1275,
  });

  EmployeeCompensationDetailState copyWith({
    bool? isLoading,
    String? error,
    double? baseSalary,
    double? housingAllowance,
    double? transportAllowance,
    double? mobileAllowance,
    double? medicalBenefit,
    double? performanceBonus,
    EmployeeCompensationPlanDetails? details,
    String? employeeName,
    String? employeeNumber,
    String? position,
    String? employmentType,
    String? department,
    String? grade,
    String? hireDate,
    String? planName,
    String? planCode,
    String? salaryStructure,
    String? structureCode,
    String? effectiveDate,
    String? currency,
  }) {
    return EmployeeCompensationDetailState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      details: details ?? this.details,
      employeeName: employeeName ?? this.employeeName,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      position: position ?? this.position,
      employmentType: employmentType ?? this.employmentType,
      department: department ?? this.department,
      grade: grade ?? this.grade,
      hireDate: hireDate ?? this.hireDate,
      planName: planName ?? this.planName,
      planCode: planCode ?? this.planCode,
      salaryStructure: salaryStructure ?? this.salaryStructure,
      structureCode: structureCode ?? this.structureCode,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      currency: currency ?? this.currency,
      baseSalary: baseSalary ?? this.baseSalary,
      housingAllowance: housingAllowance ?? this.housingAllowance,
      transportAllowance: transportAllowance ?? this.transportAllowance,
      mobileAllowance: mobileAllowance ?? this.mobileAllowance,
      medicalBenefit: medicalBenefit ?? this.medicalBenefit,
      performanceBonus: performanceBonus ?? this.performanceBonus,
    );
  }

  double get totalAllowances => housingAllowance + transportAllowance + mobileAllowance;
  double get totalBenefits => medicalBenefit;
  double get grossMonthlyCompensation => baseSalary + totalAllowances + totalBenefits + performanceBonus;
}


final _apiClientProvider = Provider((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _remoteDataSourceProvider = Provider<EmployeeCompensationPlanDetailsRemoteDataSource>((ref) {
  final apiClient = ref.watch(_apiClientProvider);
  return EmployeeCompensationPlanDetailsRemoteDataSourceImpl(apiClient: apiClient);
});

final _repositoryProvider = Provider<EmployeeCompensationPlanDetailsRepository>((ref) {
  return EmployeeCompensationPlanDetailsRepositoryImpl(remoteDataSource: ref.watch(_remoteDataSourceProvider));
});

final _useCaseProvider = Provider<GetEmployeeCompensationPlanDetailsUseCase>((ref) {
  return GetEmployeeCompensationPlanDetailsUseCase(repository: ref.watch(_repositoryProvider));
});

final employeeCompensationDetailProvider =
    AutoDisposeNotifierProvider<EmployeeCompensationDetailNotifier, EmployeeCompensationDetailState>(
      EmployeeCompensationDetailNotifier.new,
    );

class EmployeeCompensationDetailNotifier extends AutoDisposeNotifier<EmployeeCompensationDetailState> {
  @override
  EmployeeCompensationDetailState build() {
    return const EmployeeCompensationDetailState();
  }

  void updateBaseSalary(double value) {
    state = state.copyWith(baseSalary: value);
  }

  Future<void> loadDetails({required String employeeGuid, String? planGuid}) async {
    final enterpriseId = ref.read(activeEnterpriseIdProvider) ?? 1;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = ref.read(_useCaseProvider);
      final details = await useCase(
        enterpriseId: enterpriseId,
        employeeGuid: employeeGuid,
        planGuid: planGuid ?? '',
      );

      state = state.copyWith(
        isLoading: false,
        details: details,
        error: null,
        employeeName: details.displayEmployeeName,
        employeeNumber: details.displayEmployeeNumber,
        position: details.displayPosition,
        employmentType: details.displayEmploymentType,
        department: details.displayDepartment,
        grade: details.displayGrade,
        hireDate: details.displayHireDate,
        planName: details.planName,
        planCode: details.planCode,
        salaryStructure: details.structureName,
        structureCode: details.structureCode,
        effectiveDate: details.displayStructureEffectiveFrom,
        currency: details.displayCurrency,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Note: currency/date conversion is handled in the domain model.
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/employee_management/domain/models/assignment_status_enum.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/job_employment_picker_field.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/add_employee_position_selection_dialog.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/reporting_to_employee_search_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobEmploymentDetailsModule extends ConsumerStatefulWidget {
  const JobEmploymentDetailsModule({super.key});

  @override
  ConsumerState<JobEmploymentDetailsModule> createState() => _JobEmploymentDetailsModuleState();
}

class _JobEmploymentDetailsModuleState extends ConsumerState<JobEmploymentDetailsModule> {
  bool _prefillLoadsTriggered = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;
    final jobState = ref.watch(addEmployeeJobEmploymentProvider);
    final jobNotifier = ref.read(addEmployeeJobEmploymentProvider.notifier);
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final assignmentState = ref.watch(addEmployeeAssignmentProvider);
    final orgUnitId = assignmentState.orgUnitIdHex?.trim();
    final hasOrgUnit = orgUnitId != null && orgUnitId.isNotEmpty;
    if (enterpriseId == null) {
      return Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Text(
          localizations.jobAndEmploymentDetails,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
      );
    }

    _resolvePrefillIds(ref, jobState, jobNotifier, enterpriseId, orgUnitId);
    if (hasOrgUnit) {
      ref.listen(addEmployeePositionByOrgUnitNotifierProvider((enterpriseId: enterpriseId, orgUnitId: orgUnitId)), (
        prev,
        next,
      ) {
        _tryResolvePosition(ref, next);
      });
    }
    ref.listen(addEmployeeAssignmentProvider, (prev, next) {
      if (prev == null) return;
      final previousOrgUnitId = prev.orgUnitIdHex?.trim();
      final nextOrgUnitId = next.orgUnitIdHex?.trim();
      if (previousOrgUnitId == nextOrgUnitId) return;
      if (jobState.selectedPosition != null) {
        jobNotifier.setPosition(null);
      }
    });
    ref.listen(employeeJobLevelNotifierProvider(enterpriseId), (prev, next) => _tryResolveJobLevel(ref, next));
    ref.listen(employeeJobFamilyNotifierProvider(enterpriseId), (prev, next) => _tryResolveJobFamily(ref, next));
    ref.listen(employeeGradeNotifierProvider(enterpriseId), (prev, next) => _tryResolveGrade(ref, next));
    final contractTypeValuesAsync = ref.watch(
      emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: 'CONTRACT_TYPE')),
    );
    final contractTypeValues = contractTypeValuesAsync.valueOrNull ?? [];
    final contractTypeLoading = contractTypeValuesAsync.isLoading;
    final selectedContractType = _contractTypeByCode(jobState.contractTypeCode, contractTypeValues);
    final clockIcon = _prefixIcon(context, Assets.icons.clockIcon.path, isDark);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18.h,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: em.assignment.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.jobAndEmploymentDetails,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              final leftColumn = [
                JobEmploymentPickerField(
                  label: localizations.position,
                  isRequired: true,
                  value: jobState.selectedPosition?.titleEnglish,
                  hint: hasOrgUnit ? 'Select Position' : localizations.organizationalStructure,
                  isEnabled: hasOrgUnit,
                  onTap: hasOrgUnit
                      ? () async {
                          final selected = await AddEmployeePositionSelectionDialog.show(
                            context,
                            enterpriseId: enterpriseId,
                            selectedPosition: jobState.selectedPosition,
                            orgUnitId: orgUnitId,
                          );
                          if (selected != null && context.mounted) {
                            jobNotifier.setPosition(selected);
                          }
                        }
                      : null,
                ),
                DigifySelectFieldWithLabel<EmplLookupValue>(
                  label: localizations.contractType,
                  isRequired: true,
                  hint: contractTypeLoading ? localizations.pleaseWait : localizations.hintContractType,
                  items: contractTypeValues,
                  itemLabelBuilder: (v) => v.meaningEn,
                  value: selectedContractType,
                  onChanged: contractTypeLoading ? null : (v) => jobNotifier.setContractTypeCode(v?.lookupCode),
                ),
                ReportingToEmployeeSearchField(
                  label: localizations.reportingTo,
                  hintText: localizations.hintReportingTo,
                  selectedEmployee: jobState.selectedReportingTo,
                  onEmployeeSelected: jobNotifier.setReportingTo,
                ),
              ];
              final rightColumn = [
                DigifyDateField(
                  label: localizations.enterpriseHireDate,
                  isRequired: true,
                  hintText: localizations.hintEnterpriseHireDate,
                  initialDate: jobState.enterpriseHireDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100, 12, 31),
                  onDateSelected: (d) => jobNotifier.setEnterpriseHireDate(d),
                ),
                DigifyTextField(
                  labelText: localizations.probationPeriodDays,
                  keyboardType: TextInputType.number,
                  prefixIcon: clockIcon,
                  hintText: localizations.hintProbationPeriodDays,
                  isRequired: true,
                  initialValue: jobState.probationDays?.toString(),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    jobNotifier.setProbationDays(n);
                  },
                ),
                DigifySelectFieldWithLabel<String>(
                  label: localizations.employmentStatus,
                  isRequired: true,
                  hint: localizations.hintEmploymentStatus,
                  items: [AssignmentStatus.active.raw, AssignmentStatus.inactive.raw, AssignmentStatus.probation.raw],
                  itemLabelBuilder: (code) {
                    switch (AssignmentStatus.fromRaw(code)) {
                      case AssignmentStatus.active:
                        return localizations.active;
                      case AssignmentStatus.inactive:
                        return localizations.inactive;
                      case AssignmentStatus.probation:
                        return localizations.reviewProbation;
                      default:
                        return code;
                    }
                  },
                  value: jobState.employmentStatusCode,
                  onChanged: (v) => jobNotifier.setEmploymentStatusCode(v),
                ),
              ];
              if (useTwoColumns) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12.h, children: leftColumn),
                    ),
                    Gap(14.w),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12.h, children: rightColumn),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [...leftColumn, ...rightColumn],
              );
            },
          ),
        ],
      ),
    );
  }

  void _resolvePrefillIds(
    WidgetRef ref,
    AddEmployeeJobEmploymentState jobState,
    AddEmployeeJobEmploymentNotifier jobNotifier,
    int enterpriseId,
    String? orgUnitId,
  ) {
    if (_prefillLoadsTriggered) return;
    final hasPrefill =
        jobState.prefillJobFamilyId != null ||
        (jobState.prefillPositionId != null && jobState.prefillPositionId!.isNotEmpty) ||
        jobState.prefillJobLevelId != null ||
        jobState.prefillGradeId != null ||
        jobState.prefillReportingToEmpId != null;
    if (!hasPrefill) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _prefillLoadsTriggered) return;
      setState(() => _prefillLoadsTriggered = true);

      if (jobState.prefillJobFamilyId != null && jobState.selectedJobFamily == null) {
        ref.read(employeeJobFamilyNotifierProvider(enterpriseId).notifier).loadFirstPage();
      }
      if (jobState.prefillPositionId != null &&
          jobState.prefillPositionId!.isNotEmpty &&
          jobState.selectedPosition == null &&
          orgUnitId != null &&
          orgUnitId.isNotEmpty) {
        ref
            .read(
              addEmployeePositionByOrgUnitNotifierProvider((enterpriseId: enterpriseId, orgUnitId: orgUnitId)).notifier,
            )
            .loadFirstPage();
      }
      if (jobState.prefillJobLevelId != null && jobState.selectedJobLevel == null) {
        ref.read(employeeJobLevelNotifierProvider(enterpriseId).notifier).loadFirstPage();
      }
      if (jobState.prefillGradeId != null && jobState.selectedGrade == null) {
        ref.read(employeeGradeNotifierProvider(enterpriseId).notifier).loadFirstPage();
      }
      if (jobState.prefillReportingToEmpId != null && jobState.selectedReportingTo == null) {
        _resolveReportingTo(ref, enterpriseId, jobState.prefillReportingToEmpId!);
      }
    });
  }

  void _tryResolveJobFamily(WidgetRef ref, dynamic state) {
    final jobState = ref.read(addEmployeeJobEmploymentProvider);
    if (jobState.prefillJobFamilyId == null || jobState.selectedJobFamily != null) return;
    final items = state.items;
    if (items == null || items.isEmpty) return;
    final list = items is List<JobFamily> ? items : List<JobFamily>.from(items as List);
    final found = list.cast<JobFamily>().where((j) => j.id == jobState.prefillJobFamilyId).firstOrNull;
    if (found != null) {
      ref.read(addEmployeeJobEmploymentProvider.notifier).setJobFamily(found);
    }
  }

  void _tryResolvePosition(WidgetRef ref, dynamic state) {
    final jobState = ref.read(addEmployeeJobEmploymentProvider);
    if (jobState.prefillPositionId == null ||
        jobState.prefillPositionId!.isEmpty ||
        jobState.selectedPosition != null) {
      return;
    }
    final items = state.items;
    if (items == null || items.isEmpty) return;
    final list = items is List<Position> ? items : List<Position>.from(items as List);
    final found = list.cast<Position>().where((p) => p.id == jobState.prefillPositionId).firstOrNull;
    if (found != null) {
      ref.read(addEmployeeJobEmploymentProvider.notifier).setPosition(found);
    }
  }

  void _tryResolveJobLevel(WidgetRef ref, dynamic state) {
    final jobState = ref.read(addEmployeeJobEmploymentProvider);
    if (jobState.prefillJobLevelId == null || jobState.selectedJobLevel != null) return;
    final items = state.items;
    if (items == null || items.isEmpty) return;
    final list = items is List<JobLevel> ? items : List<JobLevel>.from(items as List);
    final found = list.cast<JobLevel>().where((j) => j.id == jobState.prefillJobLevelId).firstOrNull;
    if (found != null) {
      ref.read(addEmployeeJobEmploymentProvider.notifier).setJobLevel(found);
    }
  }

  void _tryResolveGrade(WidgetRef ref, dynamic state) {
    final jobState = ref.read(addEmployeeJobEmploymentProvider);
    if (jobState.prefillGradeId == null || jobState.selectedGrade != null) return;
    final items = state.items;
    if (items == null || items.isEmpty) return;
    final list = items is List<Grade> ? items : List<Grade>.from(items as List);
    final found = list.cast<Grade>().where((g) => g.id == jobState.prefillGradeId).firstOrNull;
    if (found != null) {
      ref.read(addEmployeeJobEmploymentProvider.notifier).setGrade(found);
    }
  }

  Future<void> _resolveReportingTo(WidgetRef ref, int enterpriseId, int reportingToEmpId) async {
    final repository = ref.read(manageEmployeesListRepositoryProvider);
    try {
      final result = await repository.getEmployees(enterpriseId: enterpriseId, page: 1, pageSize: 200);
      final match = result.items.where((e) => e.employeeIdNum == reportingToEmpId).firstOrNull;
      if (match != null && mounted) {
        ref.read(addEmployeeJobEmploymentProvider.notifier).setReportingTo(match);
      }
    } catch (_) {}
  }

  static EmplLookupValue? _contractTypeByCode(String? code, List<EmplLookupValue> values) {
    if (code == null || code.trim().isEmpty) return null;
    try {
      return values.firstWhere((v) => v.lookupCode == code.trim());
    } catch (_) {
      return null;
    }
  }

  static Widget _prefixIcon(BuildContext context, String path, bool isDark) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
  }
}

extension _FirstWhereOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    for (final e in this) {
      return e;
    }
    return null;
  }
}

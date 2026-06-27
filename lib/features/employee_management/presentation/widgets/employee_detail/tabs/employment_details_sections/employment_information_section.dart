import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/utils/employee_detail_formatters.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_employment_status_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EmploymentInformationSection extends StatelessWidget {
  const EmploymentInformationSection({super.key, required this.isDark, this.fullDetails});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;

  static String _servicePeriod(EmployeeFullDetails? d) {
    final period = d?.assignment.servicePeriod;
    if (period == null) return '—';
    final (years, months, days) = period;
    return '${years}Y ${months}M ${days}D';
  }

  List<EmployeeDetailBorderedField> _leftColumnFields() {
    final e = fullDetails?.employee;
    final a = fullDetails?.assignment;
    if (e == null && a == null) {
      return List.generate(5, (_) => const EmployeeDetailBorderedField(label: '—', value: '—'));
    }
    final employeeNumber = e?.employeeNumber ?? a?.employeeNumber;
    final gradeDisplay =
        a?.grade?.gradeNumber ?? (a?.gradeId != null ? '${a!.gradeId}' : (e?.gradeId != null ? '${e!.gradeId}' : null));
    return [
      EmployeeDetailBorderedField(label: 'Employee Number', value: displayValue(employeeNumber)),
      EmployeeDetailBorderedField(
        label: 'Position',
        value: displayValue(a?.positionNameEn ?? a?.positionCode ?? a?.positionId),
      ),
      EmployeeDetailBorderedField(label: 'Grade Level', value: gradeDisplay ?? '—'),
      EmployeeDetailBorderedField(label: 'Enterprise Hire Date', value: formatIsoDateToDisplay(a?.enterpriseHireDate)),
      EmployeeDetailBorderedField(label: 'Service Period', value: _servicePeriod(fullDetails)),
    ];
  }

  List<EmployeeDetailBorderedField> _rightColumnFields() {
    final a = fullDetails?.assignment;
    final e = fullDetails?.employee;
    final ws = fullDetails?.workSchedule;
    final rawStatus = e?.employeeStatus ?? a?.assignmentStatus ?? a?.employmentStatus;
    final contractEnd = a?.effectiveEndDate != null && a!.effectiveEndDate!.isNotEmpty
        ? formatIsoDateToDisplay(a.effectiveEndDate)
        : 'Ongoing';
    final probationDays = a?.probationDays ?? e?.probationDays;
    final workLocationId = a?.workLocationId ?? e?.workLocationId;
    final workLocationName = a?.workLocationName;
    final workLocationDisplay = (workLocationName != null && workLocationName.trim().isNotEmpty)
        ? workLocationName
        : (workLocationId != null ? '$workLocationId' : null);
    return [
      EmployeeDetailBorderedField(label: 'Contract Type', value: displayValue(a?.contractTypeCode)),
      EmployeeDetailBorderedField(
        label: 'Contract Start',
        value: formatIsoDateToDisplay(a?.effectiveStartDate ?? a?.enterpriseHireDate),
      ),
      EmployeeDetailBorderedField(label: 'Contract End', value: contractEnd),
      EmployeeDetailBorderedField(
        label: 'Probation Period',
        value: probationDays != null ? '$probationDays days' : '—',
      ),
      EmployeeDetailBorderedField(label: 'Work Location', value: workLocationDisplay ?? '—'),
      EmployeeDetailBorderedField(
        label: 'Employment Status',
        value: rawStatus ?? '—',
        valueWidget: EmployeeEmploymentStatusCapsule(status: rawStatus, isDark: isDark),
      ),
      EmployeeDetailBorderedField(
        label: 'Work Schedule',
        value: ws?.workScheduleId != null ? '${ws!.workScheduleId}' : '—',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return EmployeeDetailBorderedSectionCard(
      title: 'Employment Information',
      titleIconAssetPath: Assets.icons.deiDashboardIcon.path,
      leftColumnFields: _leftColumnFields(),
      rightColumnFields: _rightColumnFields(),
      isDark: isDark,
    );
  }
}

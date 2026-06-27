import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';

/// Presentation-level display data for the employee detail screen.
/// Computes display strings from [employee] and [fullDetails]; no logic in widgets.
class EmployeeDetailDisplayData {
  EmployeeDetailDisplayData({required this.employee, this.fullDetails});

  final EmployeeListItem employee;
  final EmployeeFullDetails? fullDetails;

  String get displayName {
    final name = fullDetails?.employee.fullNameEn;
    if (name != null && name.trim().isNotEmpty) return name.trim().toUpperCase();
    if (employee.fullName.trim().isNotEmpty) return employee.fullName.trim().toUpperCase();
    return '—';
  }

  String get departmentLabel {
    final list = fullDetails?.assignment.orgStructureList ?? [];
    final deptList = list.where((e) => e.levelCode == 'DEPARTMENT').toList();
    final dept = deptList.isEmpty ? null : deptList.first;
    if (dept != null && (dept.orgUnitNameEn ?? '').trim().isNotEmpty) {
      return (dept.orgUnitNameEn ?? '').trim().toUpperCase();
    }
    if (list.isNotEmpty) {
      final last = list.last;
      final name = (last.orgUnitNameEn ?? '').trim();
      if (name.isNotEmpty) return name.toUpperCase();
    }
    if (employee.department.trim().isNotEmpty) return employee.department.trim();
    return '—';
  }

  String get employeeNumber => fullDetails?.employee.employeeNumber?.trim().isNotEmpty == true
      ? fullDetails!.employee.employeeNumber!
      : (employee.employeeNumber.trim().isNotEmpty ? employee.employeeNumber : '—');

  String get positionLabel {
    final pos = fullDetails?.assignment.position?.positionNameEn ?? fullDetails?.assignment.positionNameEn;
    if (pos != null && pos.trim().isNotEmpty) return pos.trim();
    return employee.position.trim().isNotEmpty ? employee.position : '—';
  }

  String get servicePeriod {
    final period = fullDetails?.assignment.servicePeriod;
    if (period == null) return '—';
    final (years, months, days) = period;
    return '${years}Y ${months}M ${days}D';
  }

  String get gradeLevel {
    final grade = fullDetails?.assignment.grade;
    if (grade != null) {
      if ((grade.gradeNumber).trim().isNotEmpty) return grade.gradeNumber;
      if ((grade.gradeCategory).trim().isNotEmpty) return grade.gradeCategory;
    }
    final gradeId = fullDetails?.employee.gradeId;
    if (gradeId != null) return 'Grade $gradeId';
    return '—';
  }

  String get totalSalary {
    if (fullDetails == null) return '—';
    final base = fullDetails!.compensation?.basicSalaryKwd ?? 0.0;
    final a = fullDetails!.allowances;
    final total =
        base +
        (a?.housingKwd ?? 0) +
        (a?.transportKwd ?? 0) +
        (a?.foodKwd ?? 0) +
        (a?.mobileKwd ?? 0) +
        (a?.otherKwd ?? 0);
    return total == 0 ? '—' : '${total.toStringAsFixed(3)} KWD';
  }

  String get nationality {
    final code = fullDetails?.demographics?.nationalityCode;
    if (code != null && code.trim().isNotEmpty) return code.trim();
    return '—';
  }
}

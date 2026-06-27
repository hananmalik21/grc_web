import 'requisition_budget.dart';
import 'requisition_detail.dart';
import 'requisition_grade.dart';
import 'requisition_hiring_team.dart';
import 'requisition_org_unit.dart';
import 'requisition_position.dart';

class Requisition {
  const Requisition({
    required this.requisitionGuid,
    required this.requisitionNumber,
    required this.requisitionTitle,
    required this.employmentTypeCode,
    this.hiringManagerName,
    this.approvalStatusCode,
    this.openStatusCode,
    this.gradeLevelCode,
    this.grade,
    this.position,
    this.positionTitle,
    this.orgStructure = const [],
    this.hiringTeam,
    this.detail = RequisitionDetail.empty,
    this.budget,
    this.approvalCompletedSteps = 0,
    this.approvalTotalSteps = 0,
  });

  final String requisitionGuid;
  final String requisitionNumber;
  final String requisitionTitle;
  final String employmentTypeCode;
  final String? hiringManagerName;
  final String? approvalStatusCode;
  final String? openStatusCode;
  final String? gradeLevelCode;
  final RequisitionGrade? grade;
  final RequisitionPosition? position;
  final String? positionTitle;
  final List<RequisitionOrgUnit> orgStructure;
  final RequisitionHiringTeam? hiringTeam;
  final RequisitionDetail detail;
  final RequisitionBudget? budget;

  final int approvalCompletedSteps;
  final int approvalTotalSteps;

  RequisitionOrgUnit? orgUnitForLevel(String levelCode) {
    final normalized = levelCode.trim().toUpperCase();
    for (final unit in orgStructure) {
      if (unit.levelCode.trim().toUpperCase() == normalized) {
        return unit;
      }
    }
    return null;
  }

  String get departmentName => orgUnitForLevel('DEPARTMENT')?.displayName ?? '';

  String? get displayGradeLabel {
    final number = grade?.gradeNumber?.trim();
    if (number != null && number.isNotEmpty) return number;

    final levelCode = gradeLevelCode?.trim();
    if (levelCode != null && levelCode.isNotEmpty) return levelCode;

    return null;
  }

  String? get displayPositionName {
    final name = position?.positionName?.trim();
    if (name != null && name.isNotEmpty) return name;

    final title = positionTitle?.trim();
    if (title != null && title.isNotEmpty) return title;

    return null;
  }

  String? get resolvedHiringManagerName {
    final fromTeam = hiringTeam?.hiringManagerName?.trim();
    if (fromTeam != null && fromTeam.isNotEmpty) return fromTeam;
    final fromRoot = hiringManagerName?.trim();
    if (fromRoot != null && fromRoot.isNotEmpty) return fromRoot;
    return null;
  }

  double get approvalProgress => approvalTotalSteps <= 0 ? 0 : approvalCompletedSteps / approvalTotalSteps;
}

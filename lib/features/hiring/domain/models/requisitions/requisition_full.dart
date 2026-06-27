import 'requisition_budget.dart';
import 'requisition_detail.dart';
import 'requisition_education_experience.dart';
import 'requisition_grade.dart';
import 'requisition_hiring_team.dart';
import 'requisition_org_unit.dart';
import 'requisition_position.dart';
import 'requisition_position_detail.dart';
import 'requisition_skill.dart';
import 'requisition_status_info.dart';

class RequisitionFull {
  const RequisitionFull({
    required this.requisitionGuid,
    required this.requisitionNumber,
    required this.requisitionTitle,
    required this.enterpriseId,
    this.approvalStatusCode,
    this.openStatusCode,
    this.employmentTypeCode = '',
    this.position,
    this.grade,
    this.jobLevelCode,
    this.orgStructure = const [],
    this.detail = RequisitionDetail.empty,
    this.statusInfo,
    this.hiringTeam,
    this.budget,
    this.positionDetail,
    this.educationExperience,
    this.skills = const [],
    this.approvalCompletedSteps = 0,
    this.approvalTotalSteps = 0,
  });

  final String requisitionGuid;
  final String requisitionNumber;
  final String requisitionTitle;
  final int enterpriseId;
  final String? approvalStatusCode;
  final String? openStatusCode;
  final String employmentTypeCode;
  final RequisitionPosition? position;
  final RequisitionGrade? grade;
  final String? jobLevelCode;
  final List<RequisitionOrgUnit> orgStructure;
  final RequisitionDetail detail;
  final RequisitionStatusInfo? statusInfo;
  final RequisitionHiringTeam? hiringTeam;
  final RequisitionBudget? budget;
  final RequisitionPositionDetail? positionDetail;
  final RequisitionEducationExperience? educationExperience;
  final List<RequisitionSkill> skills;
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
    final levelCode = jobLevelCode?.trim();
    if (levelCode != null && levelCode.isNotEmpty) return levelCode;
    return null;
  }

  String? get displayPositionName {
    final name = position?.positionName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return null;
  }

  String? get resolvedHiringManagerName {
    final fromTeam = hiringTeam?.hiringManagerName?.trim();
    if (fromTeam != null && fromTeam.isNotEmpty) return fromTeam;
    return null;
  }

  String get displayStatusLabel {
    final fromStatus = statusInfo?.displayStatus?.trim();
    if (fromStatus != null && fromStatus.isNotEmpty) return fromStatus;
    return approvalStatusCode ?? openStatusCode ?? '';
  }
}

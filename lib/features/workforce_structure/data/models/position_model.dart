import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';

/// Position data model (DTO)
/// Maps API response to domain model
class PositionModel {
  final String positionId;
  final String positionCode;
  final String status;
  final String positionTitleEn;
  final String positionTitleAr;
  final String orgStructureId;
  final String orgUnitId;
  final String? costCenter;
  final String? location;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final int? minStepNo;
  final int? maxStepNo;
  final List<int> stepNos;
  final int numberOfPositions;
  final int filledPositions;
  final String? employmentType;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;
  final double? actualAvgKd;
  final String? reportsToPositionId;
  final String createdBy;
  final String createdDate;
  final String lastUpdatedBy;
  final String lastUpdatedDate;
  final String lastUpdateLogin;

  // Nested objects
  final OrgStructureModel? orgStructure;
  final OrgUnitModel? orgUnit;
  final JobFamilyModel? jobFamily;
  final JobLevelModel? jobLevel;
  final GradeModel? grade;
  final ReportsToModel? reportsTo;
  final List<OrgPathModel>? orgPath;

  const PositionModel({
    required this.positionId,
    required this.positionCode,
    required this.status,
    required this.positionTitleEn,
    required this.positionTitleAr,
    required this.orgStructureId,
    required this.orgUnitId,
    this.costCenter,
    this.location,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.minStepNo,
    this.maxStepNo,
    this.stepNos = const [],
    required this.numberOfPositions,
    required this.filledPositions,
    this.employmentType,
    this.budgetedMinKd,
    this.budgetedMaxKd,
    this.actualAvgKd,
    this.reportsToPositionId,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    required this.lastUpdateLogin,
    this.orgStructure,
    this.orgUnit,
    this.jobFamily,
    this.jobLevel,
    this.grade,
    this.reportsTo,
    this.orgPath,
  });

  // Safe parsers
  static String _asString(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    if (v is String) return v;
    return v.toString();
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static double _asDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }

  static String? _optionalString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v.isEmpty ? null : v;
    final s = v.toString();
    return s.isEmpty ? null : s;
  }

  static int? _optionalInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static List<int> _optionalIntList(dynamic v) {
    if (v is! List) return const [];
    final parsed = v.map((e) => _optionalInt(e)).whereType<int>().where((n) => n > 0).toSet().toList()..sort();
    return parsed;
  }

  static ({int? min, int? max, List<int> steps}) _resolveStepData(Map<String, dynamic> json) {
    final explicitMin = _optionalInt(json['min_step_no']);
    final explicitMax = _optionalInt(json['max_step_no']);
    final stepNos = _optionalIntList(json['step_nos']);
    final singleStep = _optionalInt(json['step_no']);

    if (explicitMin != null || explicitMax != null) {
      final resolvedMin = explicitMin ?? explicitMax;
      final resolvedMax = explicitMax ?? explicitMin;
      final derivedSteps = stepNos.isNotEmpty
          ? stepNos
          : (resolvedMin != null && resolvedMax != null)
          ? List.generate(resolvedMax - resolvedMin + 1, (i) => resolvedMin + i)
          : (singleStep != null ? [singleStep] : const <int>[]);
      return (min: resolvedMin, max: resolvedMax, steps: derivedSteps);
    }

    if (stepNos.isNotEmpty) {
      return (min: stepNos.first, max: stepNos.last, steps: stepNos);
    }

    if (singleStep != null && singleStep > 0) {
      return (min: singleStep, max: singleStep, steps: [singleStep]);
    }

    return (min: null, max: null, steps: const []);
  }

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    final stepData = _resolveStepData(json);
    return PositionModel(
      positionId: _asString(json['position_id']),
      positionCode: _asString(json['position_code']),
      status: _asString(json['status'], fallback: 'ACTIVE'),
      positionTitleEn: _asString(json['position_title_en']),
      positionTitleAr: _asString(json['position_title_ar']),
      orgStructureId: _asString(json['org_structure_id']),
      orgUnitId: _asString(json['org_unit_id']),
      costCenter: _optionalString(json['cost_center']),
      location: _optionalString(json['location']),
      jobFamilyId: _optionalInt(json['job_family_id']),
      jobLevelId: _optionalInt(json['job_level_id']),
      gradeId: _optionalInt(json['grade_id']),
      minStepNo: stepData.min,
      maxStepNo: stepData.max,
      stepNos: stepData.steps,
      numberOfPositions: _asInt(json['number_of_positions']),
      filledPositions: _asInt(json['filled_positions']),
      employmentType: _optionalString(json['employment_type']),
      budgetedMinKd: json['budgeted_min_kd'] != null ? _asDouble(json['budgeted_min_kd']) : null,
      budgetedMaxKd: json['budgeted_max_kd'] != null ? _asDouble(json['budgeted_max_kd']) : null,
      actualAvgKd: json['actual_avg_kd'] != null ? _asDouble(json['actual_avg_kd']) : null,
      reportsToPositionId: _optionalString(json['reports_to_position_id']),
      createdBy: _asString(json['created_by'], fallback: 'SYSTEM'),
      createdDate: _asString(json['created_date']),
      lastUpdatedBy: _asString(json['last_updated_by'], fallback: 'SYSTEM'),
      lastUpdatedDate: _asString(json['last_updated_date']),
      lastUpdateLogin: _asString(json['last_update_login'], fallback: 'SYSTEM'),
      orgStructure: json['org_structure'] != null
          ? OrgStructureModel.fromJson(json['org_structure'] as Map<String, dynamic>)
          : null,
      orgUnit: json['org_unit'] != null ? OrgUnitModel.fromJson(json['org_unit'] as Map<String, dynamic>) : null,
      jobFamily: json['job_family'] != null
          ? JobFamilyModel.fromJson(json['job_family'] as Map<String, dynamic>)
          : null,
      jobLevel: json['job_level'] != null ? JobLevelModel.fromJson(json['job_level'] as Map<String, dynamic>) : null,
      grade: json['grade'] != null ? GradeModel.fromJson(json['grade'] as Map<String, dynamic>) : null,
      reportsTo: json['reports_to'] != null
          ? ReportsToModel.fromJson(json['reports_to'] as Map<String, dynamic>)
          : null,
      orgPath: json['org_path'] != null
          ? (json['org_path'] as List)
                .map(
                  (e) => OrgPathModel.fromJson(
                    e as Map<String, dynamic>,
                    orgStructureId: _asString(json['org_structure_id']),
                  ),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position_id': positionId,
      'position_code': positionCode,
      'status': status,
      'position_title_en': positionTitleEn,
      'position_title_ar': positionTitleAr,
      'org_structure_id': orgStructureId,
      'org_unit_id': orgUnitId,
      'cost_center': costCenter,
      'location': location,
      'job_family_id': jobFamilyId,
      'job_level_id': jobLevelId,
      'grade_id': gradeId,
      'min_step_no': minStepNo,
      'max_step_no': maxStepNo,
      'step_no': stepNos.isNotEmpty ? stepNos.first : minStepNo,
      'step_nos': stepNos,
      'number_of_positions': numberOfPositions,
      'filled_positions': filledPositions,
      'employment_type': employmentType,
      'budgeted_min_kd': budgetedMinKd,
      'budgeted_max_kd': budgetedMaxKd,
      'actual_avg_kd': actualAvgKd,
      'reports_to_position_id': reportsToPositionId,
      'created_by': createdBy,
      'created_date': createdDate,
      'last_updated_by': lastUpdatedBy,
      'last_updated_date': lastUpdatedDate,
      'last_update_login': lastUpdateLogin,
    };
  }

  /// Convert to domain entity
  Position toEntity() {
    // Calculate vacant positions
    final vacant = numberOfPositions - filledPositions;

    // Get department from org path or org unit
    String department = '';
    if (orgPath != null && orgPath!.isNotEmpty) {
      final deptNode = orgPath!.firstWhere((node) => node.levelCode == 'DEPARTMENT', orElse: () => orgPath!.last);
      department = deptNode.nameEn;
    } else if (orgUnit != null) {
      department = orgUnit!.nameEn;
    }

    // Get division from org path
    String division = '';
    if (orgPath != null && orgPath!.isNotEmpty) {
      final divNode = orgPath!.firstWhere((node) => node.levelCode == 'DIVISION', orElse: () => orgPath!.first);
      division = divNode.nameEn;
    }

    return Position(
      id: positionId,
      code: positionCode,
      titleEnglish: positionTitleEn,
      titleArabic: positionTitleAr,
      department: department,
      jobFamily: jobFamily?.jobFamilyNameEn ?? '',
      level: jobLevel?.levelNameEn ?? '',
      grade: grade?.gradeNumber ?? '',
      step: _buildStepDisplay(
        minStepNo ?? (stepNos.isNotEmpty ? stepNos.first : null),
        maxStepNo ?? (stepNos.isNotEmpty ? stepNos.last : null),
      ),
      reportsTo: _buildReportsToDisplay(reportsTo),
      reportsToPositionId: reportsToPositionId,
      reportsToTitle: reportsTo?.positionTitleEn,
      reportsToCode: reportsTo?.positionCode,
      division: division,
      employmentType: employmentType,
      costCenter: costCenter ?? '',
      location: location ?? '',
      budgetedMin: budgetedMinKd != null ? budgetedMinKd!.toStringAsFixed(0) : '',
      budgetedMax: budgetedMaxKd != null ? budgetedMaxKd!.toStringAsFixed(0) : '',
      actualAverage: actualAvgKd != null ? actualAvgKd!.toStringAsFixed(0) : '',
      headcount: numberOfPositions,
      filled: filledPositions,
      vacant: vacant,
      isActive: status == 'ACTIVE',
      status: status,
      createdAt: _parseDate(createdDate),
      updatedAt: _parseDate(lastUpdatedDate),
      jobFamilyId: jobFamilyId ?? jobFamily?.jobFamilyId,
      jobLevelId: jobLevelId ?? jobLevel?.jobLevelId,
      gradeId: gradeId ?? grade?.gradeId,
      jobFamilyRef: jobFamily?.toEntity(),
      jobLevelRef: jobLevel?.toEntity(),
      gradeRef: grade?.toEntity(),
      orgUnitId: orgUnitId,
      orgPathIds: orgPath != null ? {for (var node in orgPath!) node.levelCode: node.orgUnitId} : null,
      orgPathRefs: orgPath != null ? {for (var node in orgPath!) node.levelCode: node.toEntity()} : null,
    );
  }

  static DateTime _parseDate(String v) {
    if (v.trim().isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }
    return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  static String _buildStepDisplay(int? minStep, int? maxStep) {
    if (minStep == null) return '';
    if (maxStep == null || maxStep == minStep) return 'Step $minStep';
    return 'Step $minStep - $maxStep';
  }

  static String? _buildReportsToDisplay(ReportsToModel? model) {
    if (model == null) return null;
    final title = model.positionTitleEn.trim();
    final code = model.positionCode.trim();
    if (title.isEmpty) return code.isEmpty ? null : code;
    return code.isEmpty ? title : '$title ($code)';
  }
}

/// Nested model classes
class OrgStructureModel {
  final String structureId;
  final String structureCode;
  final String structureName;

  const OrgStructureModel({required this.structureId, required this.structureCode, required this.structureName});

  factory OrgStructureModel.fromJson(Map<String, dynamic> json) {
    return OrgStructureModel(
      structureId: (json['structure_id'] as String?) ?? (json['structure_id'] as num?)?.toString() ?? '',
      structureCode: json['structure_code'] as String? ?? '',
      structureName: json['structure_name'] as String? ?? '',
    );
  }
}

class OrgUnitModel {
  final String orgUnitId;
  final String nameEn;
  final String nameAr;
  final String levelCode;

  const OrgUnitModel({required this.orgUnitId, required this.nameEn, required this.nameAr, required this.levelCode});

  factory OrgUnitModel.fromJson(Map<String, dynamic> json) {
    return OrgUnitModel(
      orgUnitId: (json['org_unit_id'] as String?) ?? (json['org_unit_id'] as num?)?.toString() ?? '',
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      levelCode: json['level_code'] as String? ?? '',
    );
  }
}

class JobFamilyModel {
  final int jobFamilyId;
  final String jobFamilyCode;
  final String jobFamilyNameEn;
  final String jobFamilyNameAr;

  const JobFamilyModel({
    required this.jobFamilyId,
    required this.jobFamilyCode,
    required this.jobFamilyNameEn,
    required this.jobFamilyNameAr,
  });

  factory JobFamilyModel.fromJson(Map<String, dynamic> json) {
    return JobFamilyModel(
      jobFamilyId: json['job_family_id'] as int? ?? 0,
      jobFamilyCode: json['job_family_code'] as String? ?? '',
      jobFamilyNameEn: json['job_family_name_en'] as String? ?? '',
      jobFamilyNameAr: json['job_family_name_ar'] as String? ?? '',
    );
  }

  JobFamily toEntity() {
    return JobFamily(
      id: jobFamilyId,
      code: jobFamilyCode,
      nameEnglish: jobFamilyNameEn,
      nameArabic: jobFamilyNameAr,
      description: '',
      totalPositions: 0,
      filledPositions: 0,
      fillRate: 0,
      isActive: true,
    );
  }
}

class JobLevelModel {
  final int jobLevelId;
  final String levelCode;
  final String levelNameEn;
  final int? minGradeId;
  final int? maxGradeId;

  const JobLevelModel({
    required this.jobLevelId,
    required this.levelCode,
    required this.levelNameEn,
    this.minGradeId,
    this.maxGradeId,
  });

  factory JobLevelModel.fromJson(Map<String, dynamic> json) {
    return JobLevelModel(
      jobLevelId: json['job_level_id'] as int? ?? 0,
      levelCode: json['level_code'] as String? ?? '',
      levelNameEn: json['level_name_en'] as String? ?? '',
      minGradeId: json['min_grade_id'] as int?,
      maxGradeId: json['max_grade_id'] as int?,
    );
  }

  JobLevel toEntity() {
    return JobLevel(
      id: jobLevelId,
      nameEn: levelNameEn,
      code: levelCode,
      description: '',
      minGradeId: minGradeId ?? 0,
      maxGradeId: maxGradeId ?? 0,
      status: 'ACTIVE',
    );
  }
}

class GradeModel {
  final int gradeId;
  final String gradeNumber;

  const GradeModel({required this.gradeId, required this.gradeNumber});

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(gradeId: json['grade_id'] as int? ?? 0, gradeNumber: json['grade_number'] as String? ?? '');
  }

  Grade toEntity() {
    return Grade(
      id: gradeId,
      gradeNumber: gradeNumber,
      gradeCategory: '',
      currencyCode: 'KD',
      step1Salary: 0,
      step2Salary: 0,
      step3Salary: 0,
      step4Salary: 0,
      step5Salary: 0,
      description: '',
      status: 'ACTIVE',
      createdBy: '',
      createdDate: DateTime.now(),
      lastUpdatedBy: '',
      lastUpdatedDate: DateTime.now(),
      lastUpdateLogin: '',
    );
  }
}

class ReportsToModel {
  final String positionId;
  final String positionCode;
  final String positionTitleEn;

  const ReportsToModel({required this.positionId, required this.positionCode, required this.positionTitleEn});

  factory ReportsToModel.fromJson(Map<String, dynamic> json) {
    return ReportsToModel(
      positionId: (json['position_id'] as String?) ?? (json['position_id'] as num?)?.toString() ?? '',
      positionCode: json['position_code'] as String? ?? '',
      positionTitleEn: json['position_title_en'] as String? ?? '',
    );
  }
}

class OrgPathModel {
  final String levelCode;
  final String orgUnitId;
  final String nameEn;
  final String nameAr;
  final String orgStructureId;

  const OrgPathModel({
    required this.levelCode,
    required this.orgUnitId,
    required this.nameEn,
    required this.nameAr,
    required this.orgStructureId,
  });

  factory OrgPathModel.fromJson(Map<String, dynamic> json, {String orgStructureId = ''}) {
    return OrgPathModel(
      levelCode: json['level_code'] as String? ?? '',
      orgUnitId: json['org_unit_id'] as String? ?? "",
      nameEn: json['name_en'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      orgStructureId: orgStructureId,
    );
  }

  OrgUnit toEntity() {
    return OrgUnit(
      orgUnitId: orgUnitId,
      orgStructureId: orgStructureId,
      enterpriseId: 0,
      levelCode: levelCode,
      orgUnitCode: '',
      orgUnitNameEn: nameEn,
      orgUnitNameAr: nameAr,
      isActive: true,
    );
  }
}

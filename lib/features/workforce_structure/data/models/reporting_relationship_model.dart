import 'package:grc/features/workforce_structure/domain/models/reporting_relationship.dart';

class ReportingRelationshipModel {
  final String positionId;
  final String positionCode;
  final String positionTitleEn;
  final String positionTitleAr;
  final String status;
  final SimplePositionModel? reportsTo;
  final List<ReportingRelationshipModel> directReports;

  const ReportingRelationshipModel({
    required this.positionId,
    required this.positionCode,
    required this.positionTitleEn,
    required this.positionTitleAr,
    required this.status,
    this.reportsTo,
    this.directReports = const [],
  });

  factory ReportingRelationshipModel.fromJson(Map<String, dynamic> json) {
    return ReportingRelationshipModel(
      positionId: json['position_id'] as String? ?? '',
      positionCode: json['position_code'] as String? ?? '',
      positionTitleEn: json['position_title_en'] as String? ?? '',
      positionTitleAr: json['position_title_ar'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      reportsTo: json['reports_to'] != null
          ? SimplePositionModel.fromJson(json['reports_to'] as Map<String, dynamic>)
          : null,
      directReports:
          (json['direct_reports'] as List<dynamic>?)
              ?.map((e) => ReportingRelationshipModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  ReportingRelationship toEntity() {
    return ReportingRelationship(
      positionId: positionId,
      positionCode: positionCode,
      titleEnglish: positionTitleEn,
      titleArabic: positionTitleAr,
      status: status,
      reportsTo: reportsTo?.toEntity(),
      directReports: directReports.map((e) => e.toEntity()).toList(),
    );
  }
}

class SimplePositionModel {
  final String positionId;
  final String positionCode;
  final String positionTitleEn;

  const SimplePositionModel({required this.positionId, required this.positionCode, required this.positionTitleEn});

  factory SimplePositionModel.fromJson(Map<String, dynamic> json) {
    return SimplePositionModel(
      positionId: json['position_id'] as String? ?? '',
      positionCode: json['position_code'] as String? ?? '',
      positionTitleEn: json['position_title_en'] as String? ?? '',
    );
  }

  SimplePosition toEntity() {
    return SimplePosition(id: positionId, code: positionCode, titleEnglish: positionTitleEn);
  }
}

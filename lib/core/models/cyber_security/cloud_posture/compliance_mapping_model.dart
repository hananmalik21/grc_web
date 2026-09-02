import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';

class ComplianceFindingMappingModel {
  final String id;
  final String type;
  final FindingSeverity severity;
  final String nistCsf;
  final String cisControls;
  final String iso27001;
  final String soc2;

  const ComplianceFindingMappingModel({
    required this.id,
    required this.type,
    required this.severity,
    required this.nistCsf,
    required this.cisControls,
    required this.iso27001,
    required this.soc2,
  });
}

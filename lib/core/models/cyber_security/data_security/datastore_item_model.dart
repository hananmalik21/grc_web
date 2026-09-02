import 'package:flutter/material.dart';
import 'package:grc/core/models/cyber_security/app_api/api_endpoint_model.dart';

enum DataClassification {
  restricted('Restricted', Color(0xFFEF4444)),
  confidential('Confidential', Color(0xFFF59E0B)),
  internal('Internal', Color(0xFF64748B)),
  public('Public', Color(0xFF10B981));

  final String label;
  final Color color;
  const DataClassification(this.label, this.color);
}

class DatastoreItemModel {
  final String source;
  final String type;
  final DataClassification classification;
  final String size;
  final bool isEncrypted;
  final bool isMasked;
  final EndpointRisk risk;

  const DatastoreItemModel({
    required this.source,
    required this.type,
    required this.classification,
    required this.size,
    required this.isEncrypted,
    required this.isMasked,
    required this.risk,
  });
}

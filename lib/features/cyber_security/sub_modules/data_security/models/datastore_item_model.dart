import 'package:flutter/material.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/models/api_endpoint_model.dart';

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

  static List<DatastoreItemModel> getMockDatastores() => const [
    DatastoreItemModel(
      source: 'prod-customer-db',
      type: 'PostgreSQL',
      classification: DataClassification.restricted,
      size: '4.2M rows',
      isEncrypted: true,
      isMasked: true,
      risk: EndpointRisk.high,
    ),
    DatastoreItemModel(
      source: 'prod-payroll-db',
      type: 'Oracle',
      classification: DataClassification.confidential,
      size: '12K rows',
      isEncrypted: true,
      isMasked: true,
      risk: EndpointRisk.medium,
    ),
    DatastoreItemModel(
      source: 's3://prod-analytics',
      type: 'S3 Bucket',
      classification: DataClassification.internal,
      size: '847 GB',
      isEncrypted: true,
      isMasked: false,
      risk: EndpointRisk.medium,
    ),
    DatastoreItemModel(
      source: 's3://prod-customer-data',
      type: 'S3 Bucket',
      classification: DataClassification.restricted,
      size: '847 GB',
      isEncrypted: false,
      isMasked: false,
      risk: EndpointRisk.critical,
    ),
    DatastoreItemModel(
      source: 'dev-postgres-01',
      type: 'PostgreSQL',
      classification: DataClassification.internal,
      size: '180K rows',
      isEncrypted: false,
      isMasked: false,
      risk: EndpointRisk.medium,
    ),
    DatastoreItemModel(
      source: 'az-blob-hr-docs',
      type: 'Blob Storage',
      classification: DataClassification.confidential,
      size: '24 GB',
      isEncrypted: true,
      isMasked: false,
      risk: EndpointRisk.low,
    ),
  ];
}

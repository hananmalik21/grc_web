import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/app_api/api_endpoint_model.dart';
import 'package:grc/core/models/cyber_security/data_security/datastore_item_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/dialogs/data_classification_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/widgets/data_security_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/widgets/datastores_table.dart';

class DataSecurityScreen extends StatefulWidget {
  const DataSecurityScreen({super.key});

  @override
  State<DataSecurityScreen> createState() => _DataSecurityScreenState();
}

class _DataSecurityScreenState extends State<DataSecurityScreen> {
  final List<DatastoreItemModel> _datastores = const [
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

  @override
  Widget build(BuildContext context) {
    return CyberScreenLayout(
      title: 'Data Security & Privacy',
      subtitle:
          'Sensitive data discovery, classification, and protection status',
      actions: [
        InkWell(
          onTap: () {
            ToastService.show(
              context: context,
              message:
                  'Scanning cloud storage buckets and relational databases for sensitive data...',
              type: ToastType.info,
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'Scan Datastores',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DataSecurityKpiRow(),
          const Gap(24),
          DatastoresTable(
            datastores: _datastores,
            onClassify: (datastore) =>
                DataClassificationDialog.show(context, datastore: datastore),
          ),
        ],
      ),
    );
  }
}

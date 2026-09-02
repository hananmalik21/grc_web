import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/dialogs/data_classification_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/models/datastore_item_model.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/widgets/data_security_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/data_security/widgets/datastores_table.dart';

class DataSecurityScreen extends StatefulWidget {
  const DataSecurityScreen({super.key});

  @override
  State<DataSecurityScreen> createState() => _DataSecurityScreenState();
}

class _DataSecurityScreenState extends State<DataSecurityScreen> {
  final List<DatastoreItemModel> _datastores = DatastoreItemModel.getMockDatastores();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = ResponsiveHelper.getPagePadding(context);

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Security & Privacy',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(3),
        Text(
          'Sensitive data discovery, classification, and protection status',
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: isMobile ? 11.sp : 12.sp,
          ),
        ),
      ],
    );

    final actionButton = InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF131D31),
            content: Text(
              'Scanning cloud storage buckets and relational databases for sensitive data...',
              style: TextStyle(color: Color(0xFF00B4D8)),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_rounded, size: 14.sp, color: const Color(0xFFCBD5E1)),
            const Gap(6),
            Text(
              'Discover Data',
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    return SingleChildScrollView(
      padding: padding.copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          if (isMobile) ...[
            titleSection,
            const Gap(12),
            actionButton,
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: titleSection),
                actionButton,
              ],
            ),
          ],

          const Gap(20),

          // 4 Top KPI Cards
          const DataSecurityKpiRow(),

          const Gap(24),

          // Datastores Table
          DatastoresTable(
            datastores: _datastores,
            onClassify: (ds) {
              DataClassificationDialog.show(context, datastore: ds);
            },
          ),
        ],
      ),
    );
  }
}

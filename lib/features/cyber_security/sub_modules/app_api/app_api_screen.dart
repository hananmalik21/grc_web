import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/dialogs/api_analysis_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/models/api_endpoint_model.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/widgets/api_endpoints_table.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/widgets/app_api_kpi_row.dart';

class AppApiScreen extends StatefulWidget {
  const AppApiScreen({super.key});

  @override
  State<AppApiScreen> createState() => _AppApiScreenState();
}

class _AppApiScreenState extends State<AppApiScreen> {
  final List<ApiEndpointModel> _endpoints = ApiEndpointModel.getMockEndpoints();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = ResponsiveHelper.getPagePadding(context);

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application & API Security',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(3),
        Text(
          'OWASP findings, API inventory, and DevSecOps pipeline',
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
              'API security scan initiated across endpoints & microservices...',
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
            Icon(Icons.sync_rounded, size: 14.sp, color: const Color(0xFFCBD5E1)),
            const Gap(6),
            Text(
              'Scan APIs',
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
          const AppApiKpiRow(),

          const Gap(24),

          // API Endpoints Table
          ApiEndpointsTable(
            endpoints: _endpoints,
            onAnalyze: (ep) {
              ApiAnalysisDialog.show(context, endpoint: ep);
            },
          ),
        ],
      ),
    );
  }
}

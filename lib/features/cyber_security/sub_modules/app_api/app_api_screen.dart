import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/app_api/api_endpoint_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/dialogs/api_analysis_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/widgets/api_endpoints_table.dart';
import 'package:grc/features/cyber_security/sub_modules/app_api/widgets/app_api_kpi_row.dart';

class AppApiScreen extends StatefulWidget {
  const AppApiScreen({super.key});

  @override
  State<AppApiScreen> createState() => _AppApiScreenState();
}

class _AppApiScreenState extends State<AppApiScreen> {
  final List<ApiEndpointModel> _endpoints = const [
    ApiEndpointModel(
      endpoint: '/api/v2/users',
      method: HttpMethod.get,
      auth: 'JWT',
      rateLimitEnabled: true,
      issuesCount: 0,
      risk: EndpointRisk.low,
    ),
    ApiEndpointModel(
      endpoint: '/api/v2/payments',
      method: HttpMethod.post,
      auth: 'JWT',
      rateLimitEnabled: true,
      issuesCount: 1,
      risk: EndpointRisk.medium,
    ),
    ApiEndpointModel(
      endpoint: '/api/v1/export',
      method: HttpMethod.get,
      auth: 'API Key',
      rateLimitEnabled: false,
      issuesCount: 3,
      risk: EndpointRisk.high,
    ),
    ApiEndpointModel(
      endpoint: '/api/v2/admin/users',
      method: HttpMethod.delete,
      auth: 'JWT',
      rateLimitEnabled: false,
      issuesCount: 2,
      risk: EndpointRisk.high,
    ),
    ApiEndpointModel(
      endpoint: '/api/v1/reports',
      method: HttpMethod.get,
      auth: 'None',
      isAuthMissing: true,
      rateLimitEnabled: false,
      issuesCount: 5,
      risk: EndpointRisk.critical,
    ),
    ApiEndpointModel(
      endpoint: '/api/v2/health',
      method: HttpMethod.get,
      auth: 'None',
      isAuthMissing: true,
      rateLimitEnabled: true,
      issuesCount: 0,
      risk: EndpointRisk.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CyberScreenLayout(
      title: 'Application & API Security',
      subtitle: 'OWASP findings, API inventory, and DevSecOps pipeline',
      actions: [
        InkWell(
          onTap: () {
            ToastService.show(
              context: context,
              message:
                  'API security scan initiated across endpoints & microservices...',
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
              'Scan APIs',
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
          const AppApiKpiRow(),
          const Gap(24),
          ApiEndpointsTable(
            endpoints: _endpoints,
            onAnalyze: (endpoint) =>
                ApiAnalysisDialog.show(context, endpoint: endpoint),
          ),
        ],
      ),
    );
  }
}

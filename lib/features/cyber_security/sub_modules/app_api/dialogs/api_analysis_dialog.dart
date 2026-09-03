import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/app_api/api_endpoint_model.dart';
import 'package:grc/core/services/toast_service.dart';

class ApiAnalysisDialog extends StatelessWidget {
  final ApiEndpointModel endpoint;

  const ApiAnalysisDialog({super.key, required this.endpoint});

  static void show(BuildContext context, {required ApiEndpointModel endpoint}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => ApiAnalysisDialog(endpoint: endpoint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 540.w,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          margin: EdgeInsets.all(20.r),
          padding: EdgeInsets.all(22.r),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'API Endpoint Security Analysis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '${endpoint.method.label}  ${endpoint.endpoint}',
                          style: TextStyle(
                            color: const Color(0xFF00B4D8),
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Gap(16),

                // Specs Summary Card
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AUTHENTICATION',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            endpoint.auth,
                            style: TextStyle(
                              color: endpoint.isAuthMissing
                                  ? const Color(0xFFEF4444)
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RATE LIMITING',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            endpoint.rateLimitEnabled ? 'Enforced' : 'Disabled',
                            style: TextStyle(
                              color: endpoint.rateLimitEnabled
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'RISK SEVERITY',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            endpoint.risk.label,
                            style: TextStyle(
                              color: endpoint.risk.color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // OWASP Vulnerability Check
                Text(
                  'OWASP API TOP 10 ASSESSMENT',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const Gap(6),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090E1A),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Text(
                    endpoint.isAuthMissing
                        ? 'CRITICAL: Endpoint allows unauthenticated execution (API2:2023 Broken Authentication). Anyone on the public internet can request sensitive reporting telemetry without an identity token.'
                        : 'Endpoint utilizes token verification. Rate limit thresholding and CORS domain whitelisting are recommended to prevent automated credential enumeration.',
                    style: TextStyle(
                      color: const Color(0xFFCBD5E1),
                      fontSize: 11.5.sp,
                      height: 1.45,
                    ),
                  ),
                ),
                const Gap(16),

                // Remediation Policy
                Text(
                  'RECOMMENDED REMEDIATION',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const Gap(6),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090E1A),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Enforce OAuth 2.0 / JWT Bearer gateway validator filter.',
                        style: TextStyle(
                          color: const Color(0xFFCBD5E1),
                          fontSize: 11.5.sp,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        '2. Configure Cloud WAF Rate Limit rule: 100 requests / minute per IP.',
                        style: TextStyle(
                          color: const Color(0xFFCBD5E1),
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    ),
                    const Gap(10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ToastService.show(
                          context: context,
                          message:
                              'WAF protection rule applied for ${endpoint.endpoint}',
                          type: ToastType.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        foregroundColor: const Color(0xFF090E1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: const Text('Apply WAF Rule'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

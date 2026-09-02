import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/network_security/firewall_rule_model.dart';
import 'package:grc/core/services/toast_service.dart';

class AiRuleAnalysisDialog extends StatelessWidget {
  final FirewallRuleModel rule;

  const AiRuleAnalysisDialog({super.key, required this.rule});

  static void show(BuildContext context, {required FirewallRuleModel rule}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => AiRuleAnalysisDialog(rule: rule),
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
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: const Color(0xFF00B4D8), size: 16.sp),
                            const Gap(6),
                            Text(
                              'AI Attack Path Analysis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Gap(2),
                        Text(
                          '${rule.ruleId} · ${rule.protocol} : ${rule.port} (${rule.service})',
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
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Gap(16),

                // Rule Exposure Summary
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
                          Text('SOURCE TRAFFIC', style: TextStyle(color: const Color(0xFF64748B), fontSize: 9.sp, fontWeight: FontWeight.w700)),
                          const Gap(2),
                          Text(rule.source, style: TextStyle(color: rule.isSourceExposed ? const Color(0xFFEF4444) : Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('DESTINATION SUBNET', style: TextStyle(color: const Color(0xFF64748B), fontSize: 9.sp, fontWeight: FontWeight.w700)),
                          const Gap(2),
                          Text(rule.destination, style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // AI Exposure Insight
                Text(
                  'EXPOSURE & THREAT VECTOR EXPLANATION',
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
                    'This security group rule allows unrestricted public access (${rule.source}) to internal ${rule.service} service listening on port ${rule.port}. Automated adversaries regularly scan public IPv4 ranges to exploit known vulnerabilities or attempt brute-force credential stuffing.',
                    style: TextStyle(
                      color: const Color(0xFFCBD5E1),
                      fontSize: 11.5.sp,
                      height: 1.45,
                    ),
                  ),
                ),
                const Gap(16),

                // Suggested Remediation
                Text(
                  'AI RECOMMENDATION',
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
                        '1. Replace 0.0.0.0/0 with corporate VPN / Zero-Trust gateway CIDR.',
                        style: TextStyle(color: const Color(0xFFCBD5E1), fontSize: 11.5.sp),
                      ),
                      const Gap(4),
                      Text(
                        '2. Place workload behind a Web Application Firewall (WAF) or private bastion.',
                        style: TextStyle(color: const Color(0xFFCBD5E1), fontSize: 11.5.sp),
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
                      child: const Text('Close', style: TextStyle(color: Color(0xFF94A3B8))),
                    ),
                    const Gap(10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ToastService.show(
                          context: context,
                          message: 'Remediation playbook queued for rule ${rule.ruleId}',
                          type: ToastType.info,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        foregroundColor: const Color(0xFF090E1A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                      ),
                      child: const Text('Queue Rule Remediation'),
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

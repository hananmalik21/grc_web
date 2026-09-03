import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';

class FindingDetailModal extends StatelessWidget {
  final FindingItemModel finding;
  final VoidCallback onCreateTicket;

  const FindingDetailModal({
    super.key,
    required this.finding,
    required this.onCreateTicket,
  });

  static void show(
    BuildContext context, {
    required FindingItemModel finding,
    required VoidCallback onCreateTicket,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => FindingDetailModal(
        finding: finding,
        onCreateTicket: () {
          Navigator.of(context).pop();
          onCreateTicket();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 580.w,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          margin: EdgeInsets.all(20.r),
          padding: EdgeInsets.all(22.r),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          finding.finding,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '${finding.id} · ${finding.account} · ${finding.service}',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
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

              // Scrollable Details Body
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Risk Score & Severity Top Split Card
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF131D31),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RISK SCORE',
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const Gap(6),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '${finding.riskScore}',
                                        style: TextStyle(
                                          color: const Color(0xFFEF4444),
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        'out of 100 · age ${finding.age}',
                                        style: TextStyle(
                                          color: const Color(0xFF64748B),
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF131D31),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SEVERITY & STATUS',
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const Gap(8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: finding.severity.color
                                              .withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                          border: Border.all(
                                            color: finding.severity.color
                                                .withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Text(
                                          finding.severity.label,
                                          style: TextStyle(
                                            color: finding.severity.color,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const Gap(10),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6.r,
                                            height: 6.r,
                                            decoration: BoxDecoration(
                                              color: finding.status.color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const Gap(4),
                                          Text(
                                            finding.status.label,
                                            style: TextStyle(
                                              color: finding.status.color,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),

                      // Affected Resource
                      _buildSectionTitle('AFFECTED RESOURCE'),
                      const Gap(6),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF090E1A),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Text(
                          finding.resourceUri ?? finding.resource,
                          style: TextStyle(
                            color: const Color(0xFF00B4D8),
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'Platform: AWS   Service: ${finding.service}   SLA: 7d',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 11.sp,
                        ),
                      ),
                      const Gap(16),

                      // AI Risk Explanation
                      _buildSectionTitle('AI RISK EXPLANATION'),
                      const Gap(6),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF090E1A),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Text(
                          finding.aiRiskExplanation ??
                              'Automated security analysis flagged this cloud resource due to insecure configuration violating zero-trust principles.',
                          style: TextStyle(
                            color: const Color(0xFFCBD5E1),
                            fontSize: 11.5.sp,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const Gap(16),

                      // Remediation Steps
                      _buildSectionTitle('REMEDIATION STEPS'),
                      const Gap(8),
                      ...finding.remediationSteps.asMap().entries.map((e) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 18.r,
                                height: 18.r,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF00B4D8,
                                  ).withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(
                                      0xFF00B4D8,
                                    ).withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.key + 1}',
                                    style: TextStyle(
                                      color: const Color(0xFF00B4D8),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: TextStyle(
                                    color: const Color(0xFFCBD5E1),
                                    fontSize: 11.5.sp,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Gap(16),

                      // Control Mapping
                      _buildSectionTitle('CONTROL MAPPING'),
                      const Gap(8),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: finding.controlMappings.entries.map((entry) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131D31),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${entry.key}: ',
                                  style: TextStyle(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 11.sp,
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    color: const Color(0xFF00B4D8),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const Gap(16),

                      // Similar Findings
                      if (finding.similarFindings.isNotEmpty) ...[
                        _buildSectionTitle(
                          'SIMILAR S3 FINDINGS (${finding.similarFindings.length})',
                        ),
                        const Gap(8),
                        ...finding.similarFindings.map((sf) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 6.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF090E1A),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 1.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: sf.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(3.r),
                                  ),
                                  child: Text(
                                    sf.severity,
                                    style: TextStyle(
                                      color: sf.color,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  sf.id,
                                  style: TextStyle(
                                    color: const Color(0xFF00B4D8),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    sf.title,
                                    style: TextStyle(
                                      color: const Color(0xFFCBD5E1),
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
              const Gap(18),

              // Bottom Actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: onCreateTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        foregroundColor: const Color(0xFF090E1A),
                        shape: RoundedRectanglePlatform.shape,
                        elevation: 0,
                      ),
                      child: Text(
                        '+ Create Remediation Ticket',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSecondaryButton(
                          label: 'Remediating',
                          color: const Color(0xFFA855F7),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: _buildSecondaryButton(
                          label: 'Acknowledge',
                          color: const Color(0xFFCBD5E1),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: _buildSecondaryButton(
                          label: '⚙ Playbook',
                          color: const Color(0xFF00B4D8),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        height: 34.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class RoundedRectanglePlatform {
  static final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
  );
}

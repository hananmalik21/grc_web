import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/dialogs/create_remediation_ticket_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/dialogs/finding_detail_modal.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/models/compliance_mapping_model.dart';
import 'package:grc/features/cyber_security/sub_modules/cloud_posture/models/finding_item_model.dart';

class CloudPostureComplianceView extends StatelessWidget {
  final ValueChanged<FindingItemModel>? onOpenDetail;

  const CloudPostureComplianceView({super.key, this.onOpenDetail});

  @override
  Widget build(BuildContext context) {
    final findings = ComplianceFindingMappingModel.getMockComplianceFindings();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Information Banner
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1E36),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: const Color(0xFF00B4D8).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFFF59E0B),
                size: 16.sp,
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  'Each finding is automatically mapped to its relevant control IDs across NIST CSF, CIS Controls, ISO 27001, and SOC 2. Click a finding row to view AI-generated remediation guidance.',
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11.5.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Gap(16),

        // Compliance Mapping Data Table
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF070C18),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF131E30)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tableMinWidth = constraints.maxWidth > 950 ? constraints.maxWidth : 950.0;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: tableMinWidth),
                  child: DataTable(
                headingRowHeight: 40.h,
                dataRowMinHeight: 44.h,
                dataRowMaxHeight: 48.h,
                horizontalMargin: 16.w,
                columnSpacing: 18.w,
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFF080E1C),
                ),
                columns: const [
                  DataColumn(label: _ComplianceHeaderCell('FINDING ID')),
                  DataColumn(label: _ComplianceHeaderCell('TYPE')),
                  DataColumn(label: _ComplianceHeaderCell('SEVERITY')),
                  DataColumn(label: _ComplianceHeaderCell('NIST CSF')),
                  DataColumn(label: _ComplianceHeaderCell('CIS CONTROLS')),
                  DataColumn(label: _ComplianceHeaderCell('ISO 27001')),
                  DataColumn(label: _ComplianceHeaderCell('SOC 2')),
                  DataColumn(label: _ComplianceHeaderCell('')),
                ],
                rows: findings.map((f) {
                  return DataRow(
                    cells: [
                      // Finding ID (Cyan Link)
                      DataCell(
                        InkWell(
                          onTap: () => _handleOpenDetail(context, f),
                          child: Text(
                            f.id,
                            style: TextStyle(
                              color: const Color(0xFF00B4D8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Type (Description)
                      DataCell(
                        Text(
                          f.type,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Severity Badge
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: f.severity.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: f.severity.color.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            f.severity.label,
                            style: TextStyle(
                              color: f.severity.color,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // NIST CSF (Cyan Code)
                      DataCell(
                        Text(
                          f.nistCsf,
                          style: TextStyle(
                            color: const Color(0xFF00B4D8),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // CIS Controls
                      DataCell(
                        Text(
                          f.cisControls,
                          style: TextStyle(
                            color: const Color(0xFFCBD5E1),
                            fontSize: 11.5.sp,
                          ),
                        ),
                      ),

                      // ISO 27001
                      DataCell(
                        Text(
                          f.iso27001,
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 11.5.sp,
                          ),
                        ),
                      ),

                      // SOC 2 (Greenish-Cyan)
                      DataCell(
                        Text(
                          f.soc2,
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Detail Action Link
                      DataCell(
                        InkWell(
                          onTap: () => _handleOpenDetail(context, f),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '→ Detail',
                                style: TextStyle(
                                  color: const Color(0xFF00B4D8),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    ),
      ],
    );
  }

  void _handleOpenDetail(BuildContext context, ComplianceFindingMappingModel f) {
    final mockFindings = FindingItemModel.getMockFindings();
    final matching = mockFindings.firstWhere(
      (mf) => mf.id == f.id,
      orElse: () => FindingItemModel(
        id: f.id,
        resource: 'cloud-resource-${f.id.toLowerCase()}',
        finding: f.type,
        severity: f.severity,
        account: 'AWS Production',
        service: 'Security',
        riskScore: f.severity == FindingSeverity.critical
            ? 95
            : f.severity == FindingSeverity.high
                ? 85
                : f.severity == FindingSeverity.medium
                    ? 65
                    : 45,
        age: '6d',
        status: FindingStatus.open,
        resourceUri: 'arn:aws:security:${f.id.toLowerCase()}',
        aiRiskExplanation:
            'This cloud resource exhibits a misconfiguration mapped against ${f.nistCsf}, CIS ${f.cisControls}, ISO ${f.iso27001}, and SOC 2 ${f.soc2}. Immediate remediation is recommended to maintain compliance readiness.',
        remediationSteps: [
          'Review configuration policy mapped to ${f.nistCsf}',
          'Apply automated guardrails to prevent future non-compliant state',
        ],
        controlMappings: {
          'NIST CSF': f.nistCsf,
          'CIS Controls': f.cisControls,
          'ISO 27001': f.iso27001,
          'SOC 2': f.soc2,
        },
      ),
    );

    if (onOpenDetail != null) {
      onOpenDetail!(matching);
    } else {
      FindingDetailModal.show(
        context,
        finding: matching,
        onCreateTicket: () {
          CreateRemediationTicketDialog.show(context, finding: matching);
        },
      );
    }
  }
}

class _ComplianceHeaderCell extends StatelessWidget {
  final String text;
  const _ComplianceHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF5E738E),
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

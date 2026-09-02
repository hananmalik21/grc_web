import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IncidentItem {
  final String severity;
  final String title;
  final String incidentId;
  final String timestamp;
  final String status;
  final Color severityColor;
  final Color statusColor;

  const IncidentItem({
    required this.severity,
    required this.title,
    required this.incidentId,
    required this.timestamp,
    required this.status,
    required this.severityColor,
    required this.statusColor,
  });
}

class CyberRecentIncidentsList extends StatelessWidget {
  const CyberRecentIncidentsList({super.key});

  static const List<IncidentItem> _incidents = [
    IncidentItem(
      severity: 'HIGH',
      title: 'Suspicious Login from Tor Exit Node',
      incidentId: 'INC-2847',
      timestamp: '28 Jun 14:23',
      status: 'Investigating',
      severityColor: Color(0xFFF97316),
      statusColor: Color(0xFFF59E0B),
    ),
    IncidentItem(
      severity: 'CRITICAL',
      title: 'Mass File Download — SharePoint Online',
      incidentId: 'INC-2846',
      timestamp: '28 Jun 13:51',
      status: 'Open',
      severityColor: Color(0xFFEF4444),
      statusColor: Color(0xFFEF4444),
    ),
    IncidentItem(
      severity: 'HIGH',
      title: 'Lateral Movement — Internal SSH Scanning',
      incidentId: 'INC-2845',
      timestamp: '27 Jun 22:14',
      status: 'Contained',
      severityColor: Color(0xFFF97316),
      statusColor: Color(0xFFF97316),
    ),
    IncidentItem(
      severity: 'CRITICAL',
      title: 'API Key Leaked in Public GitHub Repo',
      incidentId: 'INC-2844',
      timestamp: '27 Jun 09:33',
      status: 'Resolved',
      severityColor: Color(0xFFEF4444),
      statusColor: Color(0xFF10B981),
    ),
    IncidentItem(
      severity: 'HIGH',
      title: 'Privilege Escalation — IAM Role Modification',
      incidentId: 'INC-2843',
      timestamp: '26 Jun 18:07',
      status: 'Open',
      severityColor: Color(0xFFF97316),
      statusColor: Color(0xFFEF4444),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF070C18),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF131E30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT INCIDENTS',
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _incidents.length,
            separatorBuilder: (_, _) => const Gap(14),
            itemBuilder: (context, index) {
              final item = _incidents[index];
              return _buildIncidentRow(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentRow(IncidentItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Severity Tag
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: item.severityColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: item.severityColor.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Text(
            item.severity,
            style: TextStyle(
              color: item.severityColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Gap(12),
        // Title & metadata
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFFF1F5F9),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(3),
              Text(
                '${item.incidentId}  ·  ${item.timestamp}',
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        // Status indicator with dot
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.r,
              height: 6.r,
              decoration: BoxDecoration(
                color: item.statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const Gap(5),
            Text(
              item.status,
              style: TextStyle(
                color: item.statusColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/models/incident_item_model.dart';

class IncidentAiTriageDialog extends StatelessWidget {
  final IncidentItemModel incident;
  final VoidCallback? onExecuteContainment;

  const IncidentAiTriageDialog({
    super.key,
    required this.incident,
    this.onExecuteContainment,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: Container(
        width: 620.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: ID, Severity, MITRE Tag, Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: incident.severityColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: incident.severityColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        incident.severityLabel,
                        style: TextStyle(
                          color: incident.severityColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF581C87).withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: const Color(0xFFA855F7).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        incident.mitreCode,
                        style: TextStyle(
                          color: const Color(0xFFD8B4FE),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      incident.id,
                      style: TextStyle(
                        color: const Color(0xFF00B4D8),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: const Color(0xFF64748B),
                  ),
                  splashRadius: 20.r,
                ),
              ],
            ),
            const Gap(12),

            // Title
            Text(
              incident.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(6),

            // Description
            Text(
              incident.description,
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
            const Gap(16),

            // Correlated Evidence Box
            if (incident.evidence.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 14.sp,
                          color: const Color(0xFF38BDF8),
                        ),
                        const Gap(6),
                        Text(
                          'AI Correlated Telemetry',
                          style: TextStyle(
                            color: const Color(0xFF38BDF8),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    ...incident.evidence.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ',
                                style: TextStyle(
                                    color: const Color(0xFF00B4D8),
                                    fontSize: 11.5.sp)),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: const Color(0xFFE2E8F0),
                                  fontSize: 11.5.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(14),
            ],

            // Recommended Containment Actions
            if (incident.containmentSteps.isNotEmpty) ...[
              Text(
                'Recommended Containment Playbook:',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(6),
              ...incident.containmentSteps.asMap().entries.map(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.key + 1}. ',
                        style: TextStyle(
                          color: const Color(0xFF38BDF8),
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            color: const Color(0xFFE2E8F0),
                            fontSize: 11.5.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),
            ],

            // Metadata row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Owner: ${incident.owner}  ·  Created: ${incident.createdDate}',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 11.sp,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onExecuteContainment?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF131D31),
                        content: Text(
                          'Containment playbook triggered for ${incident.id}.',
                          style: const TextStyle(color: Color(0xFF00B4D8)),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    'Execute Containment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

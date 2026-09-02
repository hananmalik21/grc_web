import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/grc_compliance/compliance_framework_model.dart';
import 'package:grc/core/services/toast_service.dart';

class EvidenceViewerDialog extends StatelessWidget {
  final ControlItemModel control;

  const EvidenceViewerDialog({
    super.key,
    required this.control,
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
        width: 580.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Control ID, Status, Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      control.controlId,
                      style: TextStyle(
                        color: const Color(0xFF00B4D8),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: control.statusColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: control.statusColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        control.statusLabel.toUpperCase(),
                        style: TextStyle(
                          color: control.statusColor,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
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
              control.controlName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(8),

            // Description
            Text(
              control.description,
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
            const Gap(16),

            // Evidence Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 15.sp,
                        color: const Color(0xFF10B981),
                      ),
                      const Gap(6),
                      Text(
                        'Automated Audit Evidence',
                        style: TextStyle(
                          color: const Color(0xFF10B981),
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    control.automatedEvidence,
                    style: TextStyle(
                      color: const Color(0xFFE2E8F0),
                      fontSize: 11.5.sp,
                      height: 1.45,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Last Verified: ${control.lastVerified} via Multi-Cloud Telemetry',
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 10.5.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Compliance Score: ${control.score}%',
                  style: TextStyle(
                    color: control.statusColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ToastService.show(
                      context: context,
                      message: 'Signed evidence bundle exported for ${control.controlId}.',
                      type: ToastType.success,
                    );
                  },
                  icon: Icon(Icons.file_download_outlined, size: 14.sp),
                  label: Text(
                    'Export Proof',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 9.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
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

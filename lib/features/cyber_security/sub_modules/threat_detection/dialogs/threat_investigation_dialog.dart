import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/models/threat_alert_model.dart';

class ThreatInvestigationDialog extends StatefulWidget {
  final ThreatAlertModel alert;
  final ValueChanged<ThreatStatus>? onStatusChanged;

  const ThreatInvestigationDialog({
    super.key,
    required this.alert,
    this.onStatusChanged,
  });

  @override
  State<ThreatInvestigationDialog> createState() =>
      _ThreatInvestigationDialogState();
}

class _ThreatInvestigationDialogState extends State<ThreatInvestigationDialog> {
  late ThreatStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.alert.status;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: Container(
        width: 600.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Alert ID & Close
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
                        color: widget.alert.severityColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: widget.alert.severityColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        widget.alert.severityLabel,
                        style: TextStyle(
                          color: widget.alert.severityColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      widget.alert.alertId,
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
              widget.alert.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(8),

            // Description
            Text(
              widget.alert.description,
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
            const Gap(16),

            // Details Grid
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Security Layer', widget.alert.sourceLabel),
                  const Divider(color: Color(0xFF1E293B), height: 16),
                  _buildDetailRow('MITRE ATT&CK', widget.alert.mitreTechnique),
                  const Divider(color: Color(0xFF1E293B), height: 16),
                  _buildDetailRow('Affected Resource', widget.alert.affectedResource),
                  const Divider(color: Color(0xFF1E293B), height: 16),
                  _buildDetailRow('Detected Time', widget.alert.timeAgo),
                ],
              ),
            ),
            const Gap(20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status modifier button
                Row(
                  children: [
                    if (_currentStatus != ThreatStatus.investigating)
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _currentStatus = ThreatStatus.investigating);
                          widget.onStatusChanged?.call(ThreatStatus.investigating);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF131D31),
                              content: Text(
                                '${widget.alert.alertId} marked as Investigating.',
                                style: const TextStyle(color: Color(0xFFF59E0B)),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.visibility_outlined, size: 14.sp, color: const Color(0xFFF59E0B)),
                        label: Text(
                          'Mark Investigating',
                          style: TextStyle(color: const Color(0xFFF59E0B), fontSize: 11.5.sp),
                        ),
                      ),
                    if (_currentStatus != ThreatStatus.closed)
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _currentStatus = ThreatStatus.closed);
                          widget.onStatusChanged?.call(ThreatStatus.closed);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF131D31),
                              content: Text(
                                '${widget.alert.alertId} marked as Closed.',
                                style: const TextStyle(color: Color(0xFF10B981)),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.check_circle_outline, size: 14.sp, color: const Color(0xFF10B981)),
                        label: Text(
                          'Resolve & Close',
                          style: TextStyle(color: const Color(0xFF10B981), fontSize: 11.5.sp),
                        ),
                      ),
                  ],
                ),

                // Primary Done Button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    'Close Details',
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/models/threat_alert_model.dart';

class CreateDetectionRuleDialog extends StatefulWidget {
  const CreateDetectionRuleDialog({super.key});

  @override
  State<CreateDetectionRuleDialog> createState() =>
      _CreateDetectionRuleDialogState();
}

class _CreateDetectionRuleDialogState extends State<CreateDetectionRuleDialog> {
  final _ruleNameController = TextEditingController();
  final _queryConditionController = TextEditingController(
    text: 'log.event == "authentication.failed" && count() > 10 within 5m',
  );
  ThreatSeverity _severity = ThreatSeverity.high;
  ThreatSource _source = ThreatSource.identity;

  @override
  void dispose() {
    _ruleNameController.dispose();
    _queryConditionController.dispose();
    super.dispose();
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
        width: 540.w,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 18.sp,
                      color: const Color(0xFFA855F7),
                    ),
                    const Gap(8),
                    Text(
                      'Create Threat Detection Rule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
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
            const Gap(16),

            // Rule Name Field
            Text(
              'Rule Name',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),
            TextField(
              controller: _ruleNameController,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: 'e.g. Brute Force Login Threshold Exceeded',
                hintStyle: TextStyle(color: const Color(0xFF64748B), fontSize: 11.5.sp),
                filled: true,
                fillColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
            ),
            const Gap(14),

            // Security Layer & Severity
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Layer',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(6),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ThreatSource>(
                            value: _source,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF0F172A),
                            items: ThreatSource.values.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(
                                  _getSourceName(s),
                                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _source = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Severity Level',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(6),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ThreatSeverity>(
                            value: _severity,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF0F172A),
                            items: ThreatSeverity.values.map((sev) {
                              return DropdownMenuItem<ThreatSeverity>(
                                value: sev,
                                child: Text(
                                  _getSeverityName(sev),
                                  style: TextStyle(
                                    color: _getSeverityColor(sev),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _severity = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(14),

            // Detection Logic / Query
            Text(
              'Detection Query Condition',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),
            TextField(
              controller: _queryConditionController,
              maxLines: 3,
              style: TextStyle(
                color: const Color(0xFF2DD4BF),
                fontSize: 11.5.sp,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                contentPadding: EdgeInsets.all(10.w),
              ),
            ),
            const Gap(20),

            // Dialog Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFF131D31),
                        content: Text(
                          'Detection rule deployed and synchronized across agents.',
                          style: TextStyle(color: Color(0xFF00B4D8)),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    'Deploy Rule',
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

  String _getSourceName(ThreatSource s) {
    switch (s) {
      case ThreatSource.identity:
        return 'Identity';
      case ThreatSource.cloud:
        return 'Cloud';
      case ThreatSource.iam:
        return 'IAM';
      case ThreatSource.data:
        return 'Data';
      case ThreatSource.network:
        return 'Network';
      case ThreatSource.appSec:
        return 'AppSec';
    }
  }

  String _getSeverityName(ThreatSeverity s) {
    switch (s) {
      case ThreatSeverity.critical:
        return 'CRITICAL';
      case ThreatSeverity.high:
        return 'HIGH';
      case ThreatSeverity.medium:
        return 'MEDIUM';
      case ThreatSeverity.low:
        return 'LOW';
    }
  }

  Color _getSeverityColor(ThreatSeverity s) {
    switch (s) {
      case ThreatSeverity.critical:
        return const Color(0xFFEF4444);
      case ThreatSeverity.high:
        return const Color(0xFFF97316);
      case ThreatSeverity.medium:
        return const Color(0xFFEAB308);
      case ThreatSeverity.low:
        return const Color(0xFF10B981);
    }
  }
}

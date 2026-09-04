import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/models/incident_item_model.dart';

class CreateIncidentDialog extends StatefulWidget {
  final ValueChanged<IncidentItemModel>? onCreated;

  const CreateIncidentDialog({super.key, this.onCreated});

  @override
  State<CreateIncidentDialog> createState() => _CreateIncidentDialogState();
}

class _CreateIncidentDialogState extends State<CreateIncidentDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mitreController = TextEditingController(text: 'T1078');
  IncidentSeverity _severity = IncidentSeverity.high;
  String _owner = 'Unassigned';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mitreController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final newIncident = IncidentItemModel(
      id: 'INC-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: title,
      severity: _severity,
      status: IncidentStatus.open,
      owner: _owner,
      createdDate: 'Just now',
      mitreCode: _mitreController.text.trim().isNotEmpty
          ? _mitreController.text.trim()
          : 'T1078',
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'Manually logged security incident.',
    );

    widget.onCreated?.call(newIncident);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF131D31),
        content: Text(
          'Incident ${newIncident.id} logged into triage queue.',
          style: const TextStyle(color: Color(0xFF00B4D8)),
        ),
      ),
    );
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
                      Icons.error_outline_rounded,
                      size: 18.sp,
                      color: const Color(0xFFEF4444),
                    ),
                    const Gap(8),
                    Text(
                      'Log New Incident',
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

            // Incident Title
            Text(
              'Incident Title',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: 'e.g. Unauthorized Credential Access on DB Host',
                hintStyle: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 11.5.sp,
                ),
                filled: true,
                fillColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
            ),
            const Gap(14),

            // Severity & Owner Row
            Row(
              children: [
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
                          child: DropdownButton<IncidentSeverity>(
                            value: _severity,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF0F172A),
                            items: IncidentSeverity.values.map((sev) {
                              return DropdownMenuItem<IncidentSeverity>(
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
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assignee / Owner',
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
                          child: DropdownButton<String>(
                            value: _owner,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF0F172A),
                            items: const [
                              DropdownMenuItem(
                                value: 'Unassigned',
                                child: Text(
                                  'Unassigned',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'P. Nair',
                                child: Text(
                                  'P. Nair (You)',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'A. Wong',
                                child: Text(
                                  'A. Wong',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'C. Rodriguez',
                                child: Text(
                                  'C. Rodriguez',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _owner = val);
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

            // MITRE & Description
            Text(
              'MITRE ATT&CK ID',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),
            TextField(
              controller: _mitreController,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: 'e.g. T1078',
                hintStyle: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 11.5.sp,
                ),
                filled: true,
                fillColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
            ),
            const Gap(20),

            // Actions
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
                  onPressed: _submit,
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
                    'Create Incident',
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

  String _getSeverityName(IncidentSeverity s) {
    switch (s) {
      case IncidentSeverity.critical:
        return 'CRITICAL';
      case IncidentSeverity.high:
        return 'HIGH';
      case IncidentSeverity.medium:
        return 'MEDIUM';
      case IncidentSeverity.low:
        return 'LOW';
    }
  }

  Color _getSeverityColor(IncidentSeverity s) {
    switch (s) {
      case IncidentSeverity.critical:
        return const Color(0xFFEF4444);
      case IncidentSeverity.high:
        return const Color(0xFFF97316);
      case IncidentSeverity.medium:
        return const Color(0xFFEAB308);
      case IncidentSeverity.low:
        return const Color(0xFF10B981);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';
import 'package:grc/core/services/toast_service.dart';

class CreateRemediationTicketDialog extends StatefulWidget {
  final FindingItemModel finding;

  const CreateRemediationTicketDialog({super.key, required this.finding});

  static void show(BuildContext context, {required FindingItemModel finding}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => CreateRemediationTicketDialog(finding: finding),
    );
  }

  @override
  State<CreateRemediationTicketDialog> createState() =>
      _CreateRemediationTicketDialogState();
}

class _CreateRemediationTicketDialogState
    extends State<CreateRemediationTicketDialog> {
  String _ticketingSystem = 'Jira';
  String _priority = 'P1';
  String _assignee = '- Add to backlog -';
  late final TextEditingController _titleController;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text:
          '[CSPM-${widget.finding.id}] ${widget.finding.finding} — ${widget.finding.resource}',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
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
                          'Create Remediation Ticket',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(4),
                        Row(
                          children: [
                            Text(
                              widget.finding.id,
                              style: TextStyle(
                                color: const Color(0xFF00B4D8),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 1.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: widget.finding.severity.color
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(3.r),
                                border: Border.all(
                                  color: widget.finding.severity.color
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                widget.finding.severity.label,
                                style: TextStyle(
                                  color: widget.finding.severity.color,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Color(0xFF94A3B8)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Gap(16),

                // Ticketing System Selector
                _buildFieldLabel('TICKETING SYSTEM'),
                const Gap(6),
                Row(
                  children: ['Jira', 'ServiceNow', 'Azure DevOps'].map((sys) {
                    final isSel = _ticketingSystem == sys;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: sys != 'Azure DevOps' ? 8.w : 0),
                        child: InkWell(
                          onTap: () => setState(() => _ticketingSystem = sys),
                          borderRadius: BorderRadius.circular(6.r),
                          child: Container(
                            height: 36.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel
                                  ? const Color(0xFF00B4D8).withValues(alpha: 0.15)
                                  : const Color(0xFF131D31),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: isSel
                                    ? const Color(0xFF00B4D8)
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            child: Text(
                              sys,
                              style: TextStyle(
                                color: isSel ? const Color(0xFF00B4D8) : const Color(0xFF94A3B8),
                                fontSize: 12.sp,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Gap(14),

                // Ticket Title
                _buildFieldLabel('TICKET TITLE'),
                const Gap(6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: TextField(
                    controller: _titleController,
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const Gap(14),

                // Priority & Due Date Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('PRIORITY'),
                          const Gap(6),
                          Row(
                            children: ['P1', 'P2', 'P3', 'P4'].map((p) {
                              final isSel = _priority == p;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: p != 'P4' ? 6.w : 0),
                                  child: InkWell(
                                    onTap: () => setState(() => _priority = p),
                                    borderRadius: BorderRadius.circular(4.r),
                                    child: Container(
                                      height: 32.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSel
                                            ? const Color(0xFFEF4444).withValues(alpha: 0.25)
                                            : const Color(0xFF131D31),
                                        borderRadius: BorderRadius.circular(4.r),
                                        border: Border.all(
                                          color: isSel
                                              ? const Color(0xFFEF4444)
                                              : const Color(0xFF1E293B),
                                        ),
                                      ),
                                      child: Text(
                                        p,
                                        style: TextStyle(
                                          color: isSel ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const Gap(14),

                    // Due Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('DUE DATE (SLA: 7D)'),
                          const Gap(6),
                          Container(
                            height: 32.h,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131D31),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: const Color(0xFF1E293B)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '04/07/2026',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 13.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(14),

                // Assign To
                _buildFieldLabel('ASSIGN TO'),
                const Gap(6),
                Container(
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _assignee,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF131D31),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF64748B),
                        size: 16.sp,
                      ),
                      style: TextStyle(
                        color: const Color(0xFFCBD5E1),
                        fontSize: 11.5.sp,
                      ),
                      onChanged: (val) {
                        if (val != null) setState(() => _assignee = val);
                      },
                      items: const [
                        DropdownMenuItem(
                          value: '- Add to backlog -',
                          child: Text('- Add to backlog -'),
                        ),
                        DropdownMenuItem(
                          value: 'Priya Nair (Security Lead)',
                          child: Text('Priya Nair (Security Lead)'),
                        ),
                        DropdownMenuItem(
                          value: 'DevOps Engineering Team',
                          child: Text('DevOps Engineering Team'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(14),

                // Finding Context Auto-Populated
                _buildFieldLabel('FINDING CONTEXT (AUTO-POPULATED)'),
                const Gap(6),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090E1A),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resource: ${widget.finding.resource}',
                        style: TextStyle(
                          color: const Color(0xFF00B4D8),
                          fontSize: 11.sp,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Gap(2),
                      Text(
                        'Account: ${widget.finding.account}  ·  Service: ${widget.finding.service}  ·  Age: ${widget.finding.age}',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 10.5.sp,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        'Risk Score: ${widget.finding.riskScore}/100',
                        style: TextStyle(
                          color: const Color(0xFFEF4444),
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(14),

                // Additional Notes
                _buildFieldLabel('ADDITIONAL NOTES'),
                const Gap(6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: TextField(
                    controller: _notesController,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white, fontSize: 11.5.sp),
                    decoration: InputDecoration(
                      hintText:
                          'Add context, links to runbooks, or special instructions...',
                      hintStyle: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 11.sp,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const Gap(20),

                // Footer Actions
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
                    const Gap(12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ToastService.show(
                          context: context,
                          message: 'Ticket successfully created in $_ticketingSystem!',
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
                      child: Text(
                        'Create Ticket in $_ticketingSystem',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/dialogs/evidence_viewer_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/models/compliance_framework_model.dart';

class ComplianceControlsTable extends StatelessWidget {
  final ComplianceFrameworkModel framework;

  const ComplianceControlsTable({
    super.key,
    required this.framework,
  });

  void _openEvidence(BuildContext context, ControlItemModel control) {
    showDialog(
      context: context,
      builder: (ctx) => EvidenceViewerDialog(control: control),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${framework.name.toUpperCase()} — CONTROL SAMPLE',
              style: TextStyle(
                color: const Color(0xFF00B4D8),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            Text(
              '${framework.totalControls} total controls',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Gap(14),

        // Table Container
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B132B).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFF1E293B)),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120.w,
                      child: _buildHeaderLabel('CONTROL ID'),
                    ),
                    Expanded(
                      flex: 4,
                      child: _buildHeaderLabel('CONTROL NAME'),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: _buildHeaderLabel('STATUS'),
                    ),
                    SizedBox(
                      width: 130.w,
                      child: _buildHeaderLabel('SCORE'),
                    ),
                    SizedBox(
                      width: 110.w,
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // Rows
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: framework.controls.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFF1E293B),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final control = framework.controls[index];
                  return _ControlTableRow(
                    control: control,
                    onGetEvidence: () => _openEvidence(context, control),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ControlTableRow extends StatefulWidget {
  final ControlItemModel control;
  final VoidCallback onGetEvidence;

  const _ControlTableRow({
    required this.control,
    required this.onGetEvidence,
  });

  @override
  State<_ControlTableRow> createState() => _ControlTableRowState();
}

class _ControlTableRowState extends State<_ControlTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final control = widget.control;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? const Color(0xFF1E293B).withValues(alpha: 0.45)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            // Control ID
            SizedBox(
              width: 120.w,
              child: GestureDetector(
                onTap: widget.onGetEvidence,
                child: Text(
                  control.controlId,
                  style: TextStyle(
                    color: const Color(0xFF00B4D8),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Control Name
            Expanded(
              flex: 4,
              child: Text(
                control.controlName,
                style: TextStyle(
                  color: const Color(0xFFF1F5F9),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Status indicator with dot
            SizedBox(
              width: 100.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: control.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    control.statusLabel,
                    style: TextStyle(
                      color: control.statusColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Score with progress bar
            SizedBox(
              width: 130.w,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: LinearProgressIndicator(
                        value: control.score / 100,
                        backgroundColor: const Color(0xFF1E293B),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          control.statusColor,
                        ),
                        minHeight: 4.h,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    '${control.score}%',
                    style: TextStyle(
                      color: const Color(0xFFCBD5E1),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Action Button: Get Evidence
            SizedBox(
              width: 110.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: widget.onGetEvidence,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3E57).withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'Get Evidence',
                      style: TextStyle(
                        color: const Color(0xFF38BDF8),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

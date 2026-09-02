import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/grc_compliance/compliance_framework_model.dart';
import 'package:grc/features/cyber_security/sub_modules/grc_compliance/dialogs/evidence_viewer_dialog.dart';

class ComplianceControlsTable extends StatelessWidget {
  final ComplianceFrameworkModel framework;

  const ComplianceControlsTable({
    super.key,
    required this.framework,
  });

  void _openEvidence(BuildContext context, ControlItemModel control) {
    showDialog(
      context: context,
      builder: (ctx) => EvidenceViewerDialog(
        control: control,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${framework.name.toUpperCase()} CONTROLS',
              style: TextStyle(
                color: AppColors.textPlaceholderDark,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              '${framework.controls.length} controls mapped',
              style: TextStyle(
                color: AppColors.textPlaceholderDark,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        const Gap(14),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cyberCardBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.cyberCardBorder),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minWidth = constraints.maxWidth > 850 ? constraints.maxWidth : 850.0;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: minWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          border: const Border(
                            bottom: BorderSide(color: AppColors.cyberCardBorder),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120.w,
                              child: _buildHeaderLabel('CONTROL ID'),
                            ),
                            SizedBox(
                              width: 250.w,
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
                      ...framework.controls.map((control) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ControlTableRow(
                              control: control,
                              onGetEvidence: () => _openEvidence(context, control),
                            ),
                            const Divider(
                              color: AppColors.cyberCardBorder,
                              height: 1,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPlaceholderDark,
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
            ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.3)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: Row(
          children: [
            SizedBox(
              width: 120.w,
              child: GestureDetector(
                onTap: widget.onGetEvidence,
                child: Text(
                  control.controlId,
                  style: TextStyle(
                    color: AppColors.dashCyberSecurity,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 250.w,
              child: Text(
                control.controlName,
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 100.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
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
            SizedBox(
              width: 130.w,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: LinearProgressIndicator(
                        value: control.score / 100,
                        backgroundColor: AppColors.cardBackgroundGreyDark,
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
                      color: AppColors.textSecondaryDark,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
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
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'Get Evidence',
                      style: TextStyle(
                        color: AppColors.cyberLow,
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

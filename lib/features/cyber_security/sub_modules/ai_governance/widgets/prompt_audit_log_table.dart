import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_governance/ai_governance_models.dart';

class PromptAuditLogTable extends StatelessWidget {
  final List<AiPromptLogItem> logs;

  const PromptAuditLogTable({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minWidth = constraints.maxWidth > 800
              ? constraints.maxWidth
              : 800.0;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
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
                          width: 100.w,
                          child: _buildHeaderLabel('PROMPT ID'),
                        ),
                        SizedBox(
                          width: 120.w,
                          child: _buildHeaderLabel('USER'),
                        ),
                        SizedBox(
                          width: 250.w,
                          child: _buildHeaderLabel('ACTION / QUERY'),
                        ),
                        SizedBox(
                          width: 120.w,
                          child: _buildHeaderLabel('MODEL'),
                        ),
                        SizedBox(width: 90.w, child: _buildHeaderLabel('TIME')),
                        SizedBox(
                          width: 90.w,
                          child: _buildHeaderLabel('STATUS'),
                        ),
                      ],
                    ),
                  ),
                  if (logs.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 36.h,
                        horizontal: 20.w,
                      ),
                      child: Center(
                        child: Text(
                          'No prompt logs recorded.',
                          style: TextStyle(
                            color: AppColors.textPlaceholderDark,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    )
                  else
                    ...logs.map((item) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PromptLogRow(item: item),
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

class _PromptLogRow extends StatefulWidget {
  final AiPromptLogItem item;

  const _PromptLogRow({required this.item});

  @override
  State<_PromptLogRow> createState() => _PromptLogRowState();
}

class _PromptLogRowState extends State<_PromptLogRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

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
              width: 100.w,
              child: Text(
                item.promptId,
                style: TextStyle(
                  color: AppColors.dashCyberSecurity,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 120.w,
              child: Text(
                item.user,
                style: TextStyle(
                  color: AppColors.textTertiaryDark,
                  fontSize: 11.5.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 250.w,
              child: Text(
                item.actionQuery,
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
              width: 120.w,
              child: Text(
                item.model,
                style: TextStyle(
                  color: AppColors.barPurple,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 90.w,
              child: Text(
                item.timeAgo,
                style: TextStyle(
                  color: AppColors.textPlaceholderDark,
                  fontSize: 11.sp,
                ),
              ),
            ),
            SizedBox(
              width: 90.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: const BoxDecoration(
                      color: AppColors.cyberLiveGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    item.status,
                    style: TextStyle(
                      color: AppColors.cyberLiveGreen,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

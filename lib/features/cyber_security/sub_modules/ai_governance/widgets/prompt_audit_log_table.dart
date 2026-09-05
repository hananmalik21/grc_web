import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_governance/ai_governance_models.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class PromptAuditLogTable extends StatelessWidget {
  final List<AiPromptLogItem> logs;

  const PromptAuditLogTable({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
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
                      color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? AppColors.cyberCardBorder : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: _buildHeaderLabel('PROMPT ID', isDark),
                        ),
                        SizedBox(
                          width: 120.w,
                          child: _buildHeaderLabel('USER', isDark),
                        ),
                        SizedBox(
                          width: 250.w,
                          child: _buildHeaderLabel('ACTION / QUERY', isDark),
                        ),
                        SizedBox(
                          width: 120.w,
                          child: _buildHeaderLabel('MODEL', isDark),
                        ),
                        SizedBox(width: 90.w, child: _buildHeaderLabel('TIME', isDark)),
                        SizedBox(
                          width: 90.w,
                          child: _buildHeaderLabel('STATUS', isDark),
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
                          _PromptLogRow(item: item, isDark: isDark),
                          Divider(
                            color: isDark ? AppColors.cyberCardBorder : const Color(0xFFE2E8F0),
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

  Widget _buildHeaderLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        color: isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B),
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _PromptLogRow extends StatefulWidget {
  final AiPromptLogItem item;
  final bool isDark;

  const _PromptLogRow({required this.item, required this.isDark});

  @override
  State<_PromptLogRow> createState() => _PromptLogRowState();
}

class _PromptLogRowState extends State<_PromptLogRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = widget.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered
            ? (isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.3) : const Color(0xFFF1F5F9))
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
                  color: isDark ? AppColors.textTertiaryDark : const Color(0xFF64748B),
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
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
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
                  color: isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B),
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

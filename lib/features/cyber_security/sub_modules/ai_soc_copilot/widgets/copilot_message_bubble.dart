import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/ai_soc_copilot/ai_soc_copilot_models.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CopilotMessageBubble extends StatelessWidget {
  final CopilotMessage message;
  final VoidCallback? onExecuteActions;

  const CopilotMessageBubble({
    super.key,
    required this.message,
    this.onExecuteActions,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final isDark = context.isDark;

    if (isUser) {
      return _buildUserBubble(context, isDark);
    } else {
      return _buildCopilotBubble(context, isDark);
    }
  }

  Widget _buildUserBubble(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 560.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(4.r),
                ),
                border: Border.all(color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFCBD5E1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    message.timestamp,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
          // User Avatar
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFF94A3B8)),
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                size: 16.sp,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopilotBubble(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Robot Avatar
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: const Color(0xFF0D9488).withValues(alpha: 0.4),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.smart_toy_outlined,
                size: 15.sp,
                color: const Color(0xFF2DD4BF),
              ),
            ),
          ),
          const Gap(10),

          // Message Card Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE2E8F0)),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title / Header
                  if (!message.isIntro) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            message.content,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (message.confidence != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 2.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Text(
                              'Confidence: ${message.confidence} | ${message.mitreMapping ?? ''}',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Gap(6),
                  ],

                  // Status line
                  if (message.status != null) ...[
                    Text(
                      message.status!,
                      style: TextStyle(
                        color: const Color(0xFFF59E0B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(12),
                  ],

                  // Intro content
                  if (message.isIntro) ...[
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        fontSize: 12.5.sp,
                        height: 1.55,
                      ),
                    ),
                    const Gap(10),
                  ],

                  // Evidence List
                  if (message.evidence.isNotEmpty) ...[
                    Text(
                      'Evidence:',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(6),
                    ...message.evidence.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                color: const Color(0xFF00B4D8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
                                  fontSize: 12.sp,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                  ],

                  // Risk line
                  if (message.riskLevel != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: (message.riskColor ?? const Color(0xFFEF4444))
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: (message.riskColor ?? const Color(0xFFEF4444))
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Risk: ${message.riskLevel}',
                        style: TextStyle(
                          color: message.riskColor ?? const Color(0xFFEF4444),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Gap(12),
                  ],

                  // Recommended Actions List
                  if (message.recommendedActions.isNotEmpty) ...[
                    Text(
                      'Required actions (all pending human approval):',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(6),
                    ...message.recommendedActions.asMap().entries.map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key + 1}. ',
                              style: TextStyle(
                                color: const Color(0xFF38BDF8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
                                  fontSize: 12.sp,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(12),
                  ],

                  // Source Citations
                  if (message.source != null) ...[
                    Text(
                      'Source: ${message.source}',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Gap(8),
                  ],

                  // Timestamp
                  Text(
                    message.timestamp,
                    style: TextStyle(
                      color: const Color(0xFF475569),
                      fontSize: 10.5.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

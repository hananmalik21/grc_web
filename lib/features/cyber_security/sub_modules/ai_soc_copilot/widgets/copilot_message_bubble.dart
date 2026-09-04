import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/models/copilot_message_model.dart';

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

    if (isUser) {
      return _buildUserBubble(context);
    } else {
      return _buildCopilotBubble(context);
    }
  }

  Widget _buildUserBubble(BuildContext context) {
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
                color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(4.r),
                ),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: const Color(0xFFF1F5F9),
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    message.timestamp,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
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
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF475569)),
            ),
            child: Center(
              child: Icon(
                Icons.person_rounded,
                size: 16.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopilotBubble(BuildContext context) {
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
                color: const Color(0xFF0B132B).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF1E293B)),
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
                              color: Colors.white,
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
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: const Color(0xFF334155),
                              ),
                            ),
                            child: Text(
                              'Confidence: ${message.confidence} | ${message.mitreMapping ?? ''}',
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
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
                        color: const Color(0xFFCBD5E1),
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
                        color: const Color(0xFF94A3B8),
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
                                  color: const Color(0xFFE2E8F0),
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
                        color: const Color(0xFF94A3B8),
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
                                  color: const Color(0xFFE2E8F0),
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

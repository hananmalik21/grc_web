import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_governance/ai_governance_models.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class RecentApprovalQueueCard extends StatelessWidget {
  const RecentApprovalQueueCard({super.key});

  static const List<AiApprovalItem> defaultApprovals = [
    AiApprovalItem(
      title: 'Disable account j.martinez',
      agent: 'AI SOC Copilot',
      timeAgo: '32 min ago',
      isApproved: true,
    ),
    AiApprovalItem(
      title: 'Block IP range 185.220.101.0/24',
      agent: 'AI SOC Copilot',
      timeAgo: '32 min ago',
      isApproved: true,
    ),
    AiApprovalItem(
      title: 'Create ticket for finding F-2401',
      agent: 'AI CSPM',
      timeAgo: '1 hr ago',
      isApproved: true,
    ),
    AiApprovalItem(
      title: 'Draft executive report INC-2847',
      agent: 'AI Reporting',
      timeAgo: '2 hr ago',
      isApproved: true,
    ),
    AiApprovalItem(
      title: 'Send customer breach notification',
      agent: 'AI GRC',
      timeAgo: '1 day ago',
      isApproved: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 14.r : 20.r),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT APPROVAL QUEUE',
            style: TextStyle(
              color: isDark ? AppColors.textTertiaryDark : const Color(0xFF64748B),
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(14),
          ...defaultApprovals.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      color: item.isApproved
                          ? AppColors.cyberLiveGreen.withValues(alpha: 0.15)
                          : AppColors.cyberCritical.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.isApproved ? Icons.check : Icons.close,
                      size: 11.sp,
                      color: item.isApproved
                          ? AppColors.cyberLiveGreen
                          : AppColors.cyberCritical,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(2),
                        Row(
                          children: [
                            Text(
                              item.agent,
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              '• ${item.timeAgo}',
                              style: TextStyle(
                                color: isDark ? AppColors.textPlaceholderDark : const Color(0xFF64748B),
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

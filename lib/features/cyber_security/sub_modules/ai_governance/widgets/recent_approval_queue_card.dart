import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/models/ai_governance_models.dart';

class RecentApprovalQueueCard extends StatelessWidget {
  const RecentApprovalQueueCard({super.key});

  @override
  Widget build(BuildContext context) {
    final approvals = AiApprovalItem.getMockApprovals();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'RECENT APPROVAL QUEUE',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(14),

          // Items List
          ...approvals.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.isApproved
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    size: 14.sp,
                    color: item.isApproved
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: const Color(0xFFE2E8F0),
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '${item.agent} · ${item.timeAgo}',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: 10.5.sp,
                          ),
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

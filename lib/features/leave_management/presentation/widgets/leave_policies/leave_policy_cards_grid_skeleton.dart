import 'package:grc/features/leave_management/domain/models/leave_policy.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_policies/components/leave_policy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeavePolicyCardsGridSkeleton extends StatelessWidget {
  final bool isDark;

  const LeavePolicyCardsGridSkeleton({super.key, required this.isDark});

  static const LeavePolicy _skeletonPolicy = LeavePolicy(
    nameEn: 'Annual Leave',
    nameAr: 'إجازة سنوية',
    isKuwaitLaw: true,
    description: 'Standard annual leave per Kuwait Labor Law — 30 days after 1 year of service.',
    entitlement: '30 days',
    accrualType: 'Monthly',
    minService: '12 months',
    advanceNotice: '7 days',
    isPaid: true,
    carryoverDays: 30,
    requiresAttachment: false,
    probationAllowed: true,
    allowEncashment: true,
    autoForfeit: false,
    countWeekendsAsLeave: false,
    countPublicHolidaysAsLeave: false,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 20.w;
        final cardHeight = 263.h;
        final crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
        final availableWidth = constraints.maxWidth - (spacing * (crossAxisCount - 1));
        final cardWidth = availableWidth / crossAxisCount;
        const skeletonCount = 6;

        return Skeletonizer(
          enabled: true,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: 20.h,
              childAspectRatio: cardWidth / cardHeight,
            ),
            itemCount: skeletonCount,
            itemBuilder: (context, index) {
              return LeavePolicyCard(policy: _skeletonPolicy, isDark: isDark);
            },
          ),
        );
      },
    );
  }
}

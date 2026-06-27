import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/common/leave_management_stat_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeavePoliciesStatCards extends ConsumerStatefulWidget {
  const LeavePoliciesStatCards({super.key, required this.isDark});

  final bool isDark;

  @override
  ConsumerState<LeavePoliciesStatCards> createState() => _LeavePoliciesStatCardsState();
}

class _LeavePoliciesStatCardsState extends ConsumerState<LeavePoliciesStatCards> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final policiesAsync = ref.watch(leavePoliciesTabLeavePoliciesFromAbsProvider);
    final isLoading = policiesAsync.isLoading;

    final total = policiesAsync.value?.length ?? 0;
    final kuwaitCompliant = policiesAsync.value?.where((p) => p.kuwaitLaborCompliant == 'Y').length ?? 0;
    final paid = total;
    const custom = 0;

    final cards = [
      LeaveManagementStatCard(
        label: 'Total Policies',
        value: '$total',
        isDark: widget.isDark,
        iconPath: Assets.icons.leaveManagement.leavePolicy.path,
      ),
      LeaveManagementStatCard(
        label: 'Kuwait Law Compliant',
        value: '$kuwaitCompliant',
        isDark: widget.isDark,
        iconPath: Assets.icons.leaveManagement.shield.path,
      ),
      LeaveManagementStatCard(
        label: 'Paid Leave Types',
        value: '$paid',
        isDark: widget.isDark,
        iconPath: Assets.icons.leaveManagement.dollar.path,
      ),
      LeaveManagementStatCard(
        label: 'Custom Policies',
        value: '$custom',
        isDark: widget.isDark,
        iconPath: Assets.icons.leaveManagement.policyConfiguration.path,
      ),
    ];

    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 180, tablet: 210, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    return Skeletonizer(
      enabled: isLoading,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                SizedBox(width: cardWidth, child: cards[i]),
                if (i < cards.length - 1) Gap(spacing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

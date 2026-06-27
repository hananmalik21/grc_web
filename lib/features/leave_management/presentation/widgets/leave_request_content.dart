import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_filter_tabs.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_requests_mobile_list.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_requests_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class LeaveRequestContent extends ConsumerWidget {
  const LeaveRequestContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMobile = context.isMobile;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            const LeaveFilterTabs(),
            Gap(16),
            if (isMobile) const LeaveRequestsMobileList() else const LeaveRequestsTable(),
          ],
        ),
      ),
    );
  }
}

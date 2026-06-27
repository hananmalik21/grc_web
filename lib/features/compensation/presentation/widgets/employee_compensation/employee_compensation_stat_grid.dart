import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_stat_grid.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeCompensationStatGrid extends ConsumerStatefulWidget {
  const EmployeeCompensationStatGrid({required this.totalEmployees, super.key});

  final int totalEmployees;

  @override
  ConsumerState<EmployeeCompensationStatGrid> createState() => _EmployeeCompensationStatGridState();
}

class _EmployeeCompensationStatGridState extends ConsumerState<EmployeeCompensationStatGrid> {
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
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    const iconColor = AppColors.statIconBlue;
    const iconBgColor = AppColors.infoBg;

    final cards = [
      ComponentStatCard(
        title: 'Total Employees',
        value: '${widget.totalEmployees}',
        iconPath: Assets.icons.compensation.users.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'Average Compensation',
        value: '—',
        iconPath: Assets.icons.compensation.calculator.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'Total Compensation',
        value: '—',
        iconPath: Assets.icons.compensation.layers.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
    ];

    return Scrollbar(
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
            for (var index = 0; index < cards.length; index++) ...[
              SizedBox(width: cardWidth, child: cards[index]),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

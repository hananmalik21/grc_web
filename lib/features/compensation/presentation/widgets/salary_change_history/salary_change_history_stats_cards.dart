import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_stat_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'salary_change_history_config.dart';

class SalaryChangeHistoryStatsCards extends StatefulWidget {
  const SalaryChangeHistoryStatsCards({required this.cards, super.key});

  final List<SalaryChangeHistoryStatCardData> cards;

  @override
  State<SalaryChangeHistoryStatsCards> createState() => _SalaryChangeHistoryStatsCardsState();
}

class _SalaryChangeHistoryStatsCardsState extends State<SalaryChangeHistoryStatsCards> {
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

    final cards = widget.cards
        .map(
          (c) => ComponentStatCard(
            title: c.title,
            value: c.value,
            iconPath: c.iconPath,
            iconColor: iconColor,
            iconBgColor: iconBgColor,
          ),
        )
        .toList();

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

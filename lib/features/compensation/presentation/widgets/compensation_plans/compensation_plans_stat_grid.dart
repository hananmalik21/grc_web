import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/components_stat_grid.dart';

class CompensationPlansStatGrid extends ConsumerStatefulWidget {
  const CompensationPlansStatGrid({super.key});

  @override
  ConsumerState<CompensationPlansStatGrid> createState() => _CompensationPlansStatGridState();
}

class _CompensationPlansStatGridState extends ConsumerState<CompensationPlansStatGrid> {
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

    final cards = [
      ComponentStatCard(
        title: 'Total Plans',
        value: '6',
        subtext: '+2 this quarter',
        iconPath: Assets.icons.compensation.fileList.path,
        iconColor: AppColors.statIconBlue,
        iconBgColor: AppColors.infoBg,
      ),
      ComponentStatCard(
        title: 'Active Plans',
        value: '5',
        subtext: 'Currently effective',
        iconPath: Assets.icons.activeDepartmentsIcon.path,
        iconColor: AppColors.statIconBlue,
        iconBgColor: AppColors.infoBg,
      ),
      ComponentStatCard(
        title: 'Draft Plans',
        value: '1',
        subtext: 'In preparation',
        iconPath: Assets.icons.editIcon.path,
        iconColor: AppColors.statIconBlue,
        iconBgColor: AppColors.infoBg,
      ),
      ComponentStatCard(
        title: 'Pending Approval',
        value: '0',
        subtext: 'Awaiting review',
        iconPath: Assets.icons.clockIcon.path,
        iconColor: AppColors.statIconBlue,
        iconBgColor: AppColors.infoBg,
      ),
      ComponentStatCard(
        title: 'Employees Covered',
        value: '335',
        subtext: 'Total coverage',
        iconPath: Assets.icons.compensation.users.path,
        iconColor: AppColors.statIconBlue,
        iconBgColor: AppColors.infoBg,
      ),
      ComponentStatCard(
        title: 'Monthly Cost',
        value: '175K',
        subtext: '+2.3% MoM',
        iconPath: Assets.icons.compensation.calculator.path,
        iconColor: AppColors.statIconBlue,
        iconBgColor: AppColors.infoBg,
      ),
      ComponentStatCard(
        title: 'Annual Cost',
        value: '21.06M',
        subtext: 'KWD projected',
        iconPath: Assets.icons.compensation.calculator.path,
        iconColor: AppColors.statIconBlue,
        iconBgColor: AppColors.infoBg,
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

import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/leave_balances_labor_law_config.dart';
import 'package:grc/features/leave_management/data/mappers/color_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalancesLaborLawSection extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveBalancesLaborLawSection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cards = LeaveBalancesLaborLawConfig.getCards();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.kuwaitLaborLawLeaveEntitlements,
            style: context.theme.textTheme.titleSmall?.copyWith(fontSize: 17.sp, color: AppColors.dialogTitle),
          ),
          Gap(16.h),
          _buildCardsGrid(context, cards),
        ],
      ),
    );
  }

  Widget _buildCardsGrid(BuildContext context, List<LeaveBalancesLaborLawCard> cards) {
    final crossAxisCount = context.isMobile ? 1 : (context.isTablet ? 2 : 3);
    final spacing = 16.w;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16.h,
      crossAxisSpacing: spacing,
      childAspectRatio: context.isMobile ? 3.0 : (context.isTablet ? 2.5 : 2.6),
      children: cards.map((card) => _buildLawCard(context, card)).toList(),
    );
  }

  Widget _buildLawCard(BuildContext context, LeaveBalancesLaborLawCard card) {
    final title = card.title == 'Sick Leave' ? localizations.sickLeave : card.title;
    final backgroundColor = ColorMapper.getColor(card.backgroundColorKey);
    final titleColor = ColorMapper.getColor(card.titleColorKey);
    final descriptionColor = ColorMapper.getColor(card.descriptionColorKey);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: context.theme.textTheme.bodyLarge?.copyWith(color: titleColor)),
          Gap(3.h),
          Text(
            card.description,
            style: context.theme.textTheme.bodyLarge?.copyWith(color: descriptionColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

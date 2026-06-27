import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_stats_cards.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WorkPatternsContent extends StatelessWidget {
  const WorkPatternsContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    required this.enterpriseId,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;
  final int? enterpriseId;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

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
            TimeManagementStatsCards(localizations: localizations, isDark: isDark),
            Gap(sectionSpacing),
            if (enterpriseId != null) WorkPatternsContentWidget(enterpriseId: enterpriseId!),
          ],
        ),
      ),
    );
  }
}

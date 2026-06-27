import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offers_filter_bar.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offers_list_desktop.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offers_stats_section.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/mobile/offers_filter_bar_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/mobile/offers_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class OffersContent extends ConsumerWidget {
  const OffersContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    required this.onCreateOfferPressed,
    required this.onExportPressed,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;
  final VoidCallback onCreateOfferPressed;
  final VoidCallback onExportPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);

    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.background,
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
            const OffersStatsSection(),
            Gap(sectionSpacing),
            if (isMobile) ...[
              const OffersFilterBarMobile(),
              Gap(sectionSpacing),
              const OffersListMobile(),
            ] else ...[
              const OffersFilterBar(),
              Gap(sectionSpacing),
              const OffersListDesktop(),
            ],
          ],
        ),
      ),
    );
  }
}

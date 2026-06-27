import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/applications_tab/applications_tab_config.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/applications_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationsStatGrid extends ConsumerStatefulWidget {
  const ApplicationsStatGrid({super.key});

  @override
  ConsumerState<ApplicationsStatGrid> createState() => _ApplicationsStatGridState();
}

class _ApplicationsStatGridState extends ConsumerState<ApplicationsStatGrid> {
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
    ref.watch(applicationsTabEnterpriseIdProvider);

    final loc = AppLocalizations.of(context)!;
    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 16);

    final statData = ApplicationsTabConfig.buildStatCards(loc);

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
            for (var index = 0; index < statData.length; index++) ...[
              SizedBox(
                width: cardWidth,
                child: ApplicationsStatCard(data: statData[index]),
              ),
              if (index < statData.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

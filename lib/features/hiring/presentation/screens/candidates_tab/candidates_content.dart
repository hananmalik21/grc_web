import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_data_table.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_filter_bar.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_list_desktop.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_stat_grid.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/mobile/candidates_filter_bar_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/mobile/candidates_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CandidatesContent extends ConsumerWidget {
  const CandidatesContent({required this.padding, required this.header, required this.enterpriseSelector, super.key});

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final viewMode = ref.watch(candidatesViewModeProvider);
    final isGrid = viewMode == CandidatesViewMode.grid;

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
            const CandidatesStatGrid(),
            Gap(sectionSpacing),
            if (isMobile) const CandidatesFilterBarMobile() else const CandidatesFilterBar(),
            Gap(sectionSpacing),
            if (isMobile)
              const CandidatesListMobile()
            else if (isGrid)
              const CandidatesDataTable()
            else
              const CandidatesListDesktop(),
          ],
        ),
      ),
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interviews_calendar_view.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interviews_filter_bar.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interviews_list_desktop.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interviews_stats_section.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mobile/interviews_filter_bar_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mobile/interviews_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class InterviewsContent extends ConsumerWidget {
  const InterviewsContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    required this.onScheduleInterviewPressed,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;
  final VoidCallback onScheduleInterviewPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final viewMode = ref.watch(interviewsViewModeProvider);

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
            const InterviewsStatsSection(),
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            if (isMobile) const InterviewsFilterBarMobile() else const InterviewsFilterBar(),
            Gap(sectionSpacing),
            if (viewMode == InterviewsViewMode.calendar)
              const InterviewsCalendarView()
            else
              isMobile ? const InterviewsListMobile() : const InterviewsListDesktop(),
          ],
        ),
      ),
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/core/widgets/feedback/placeholder_screen.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/grade_structure_tab.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_families_tab.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_levels_tab.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/positions_tab.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/reporting_structure_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WorkforceStructureScreen extends ConsumerWidget {
  const WorkforceStructureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(workforceTabStateProvider.select((s) => s.currentTabIndex));
    final isMobile = ResponsiveHelper.isMobile(context);
    final tabs = WorkforceTab.values;
    final currentTab = (currentTabIndex >= 0 && currentTabIndex < tabs.length)
        ? tabs[currentTabIndex]
        : WorkforceTab.positions;
    final headerTitle = currentTab.label(localizations);
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('workforceStructure');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveHelper.getPagePadding(context),
            child: isMobile
                ? null
                : DigifyBreadcrumb(
                    items: [
                      DigifyBreadcrumbItem(label: 'Dashboard', onTap: () => context.go(AppRoutes.dashboard)),
                      const DigifyBreadcrumbItem(label: 'Workforce Structure'),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: headerTitle),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabWidget(context, currentTabIndex)),
        ],
      ),
    );
  }

  Widget _buildTabWidget(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const PositionsTab();
      case 1:
        return const JobFamiliesTab();
      case 2:
        return const JobLevelsTab();
      case 3:
        return const GradeStructureTab();
      case 4:
        return const ReportingStructureTab();
      case 5:
        return PlaceholderScreen(title: 'Position Tree');
      default:
        return const PositionsTab();
    }
  }
}

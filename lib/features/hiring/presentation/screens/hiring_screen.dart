import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/core/widgets/feedback/placeholder_screen.dart';
import 'package:grc/features/hiring/presentation/providers/hiring_tab_state_provider.dart';
import 'package:grc/features/hiring/presentation/screens/applications_tab/applications_tab.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_tab.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/requisitions_tab.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_tab.dart';
import 'package:grc/features/hiring/presentation/screens/hr_interface_tab/hr_interface_tab.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/offers_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class _HiringTabIndex {
  static const int requisitions = 0;
  static const int candidates = 1;
  static const int applications = 2;
  static const int interviews = 3;
  static const int offers = 4;
  static const int hrInterface = 5;
  static const int careerSite = 6;
}

class HiringScreen extends ConsumerWidget {
  const HiringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final loc = AppLocalizations.of(context)!;
    final selectedTabIndex = ref.watch(hiringTabStateProvider.select((s) => s.currentTabIndex));
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('hiring');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTab(selectedTabIndex, loc);

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
                      DigifyBreadcrumbItem(label: loc.dashboard, onTap: () => context.go(AppRoutes.dashboard)),
                      DigifyBreadcrumbItem(label: loc.hiring),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(selectedTabIndex, loc)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex, AppLocalizations loc) {
    switch (tabIndex) {
      case _HiringTabIndex.requisitions:
        return const RequisitionsTab();
      case _HiringTabIndex.candidates:
        return const CandidatesTab();
      case _HiringTabIndex.applications:
        return const ApplicationsTab();
      case _HiringTabIndex.interviews:
        return const InterviewsTab();
      case _HiringTabIndex.offers:
        return const OffersTab();
      case _HiringTabIndex.hrInterface:
        return const HrInterfaceTab();
      case _HiringTabIndex.careerSite:
        return PlaceholderScreen(title: loc.hiringCareerSite);
      default:
        return PlaceholderScreen(title: loc.hiringRequisitions);
    }
  }

  String _childLabelForTab(int tabIndex, AppLocalizations loc) {
    switch (tabIndex) {
      case _HiringTabIndex.requisitions:
        return loc.hiringRequisitions;
      case _HiringTabIndex.candidates:
        return loc.hiringCandidates;
      case _HiringTabIndex.applications:
        return loc.hiringApplications;
      case _HiringTabIndex.interviews:
        return loc.hiringInterviews;
      case _HiringTabIndex.offers:
        return loc.hiringOffers;
      case _HiringTabIndex.hrInterface:
        return loc.hiringHrInterface;
      case _HiringTabIndex.careerSite:
        return loc.hiringCareerSite;
      default:
        return loc.hiringRequisitions;
    }
  }
}

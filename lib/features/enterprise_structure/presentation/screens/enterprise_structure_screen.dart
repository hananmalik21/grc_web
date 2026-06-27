import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprise_structure_tab_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_screen.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EnterpriseStructureScreen extends ConsumerWidget {
  const EnterpriseStructureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final currentTabIndex = ref.watch(enterpriseStructureTabStateProvider.select((s) => s.currentTabIndex));
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;

    final defaultChildLabel = _childLabelForIndex(localizations, ref, currentTabIndex);
    final childLabel = navExtra?.leafLabel ?? defaultChildLabel;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('enterpriseStructure');
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
                      const DigifyBreadcrumbItem(label: 'Enterprise Structure'),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(context, currentTabIndex)),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const ManageEnterpriseStructureScreen();
      case 1:
        return const ManageComponentValuesScreen();
      case 2:
        return const ManageComponentValuesScreen(initialLevelCode: 'COMPANY');
      case 3:
        return const ManageComponentValuesScreen(initialLevelCode: 'DIVISION');
      case 4:
        return const ManageComponentValuesScreen(initialLevelCode: 'BUSINESS_UNIT');
      case 5:
        return const ManageComponentValuesScreen(initialLevelCode: 'DEPARTMENT');
      case 6:
        return const ManageComponentValuesScreen(initialLevelCode: 'SECTION');
      default:
        return const ManageEnterpriseStructureScreen();
    }
  }

  String _childLabelForIndex(AppLocalizations localizations, WidgetRef ref, int tabIndex) {
    const manageComponentsLabel = 'Manage Component Values';

    if (tabIndex == 0) return localizations.manageEnterpriseStructure;

    if (tabIndex == 1) {
      final state = ref.watch(manageComponentValuesScreenProvider);
      final selected = (!state.isTreeView && state.selectedLevel != null) ? _labelForLevel(state.selectedLevel) : null;
      return selected ?? manageComponentsLabel;
    }

    final level = _levelForTabIndex(tabIndex);
    return _labelForLevel(level) ?? manageComponentsLabel;
  }

  OrganizationLevel? _levelForTabIndex(int tabIndex) {
    return switch (tabIndex) {
      2 => OrganizationLevel.company,
      3 => OrganizationLevel.division,
      4 => OrganizationLevel.businessUnit,
      5 => OrganizationLevel.department,
      6 => OrganizationLevel.section,
      _ => null,
    };
  }

  String? _labelForLevel(OrganizationLevel? level) {
    return switch (level) {
      OrganizationLevel.company => 'Company',
      OrganizationLevel.division => 'Division',
      OrganizationLevel.businessUnit => 'Business Unit',
      OrganizationLevel.department => 'Department',
      OrganizationLevel.section => 'Section',
      _ => null,
    };
  }
}

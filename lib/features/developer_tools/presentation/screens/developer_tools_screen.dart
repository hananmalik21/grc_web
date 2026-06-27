import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/features/developer_tools/presentation/providers/developer_tools_tab_state_provider.dart';
import 'package:grc/features/developer_tools/presentation/screens/desktop_management_mock_screen.dart';
import 'package:grc/features/developer_tools/presentation/screens/function_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class _DeveloperToolsTabIndex {
  static const int functionManagement = 0;
  static const int desktopManagement = 1;
}

class DeveloperToolsScreen extends ConsumerWidget {
  const DeveloperToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final selectedTabIndex = ref.watch(developerToolsTabStateProvider.select((s) => s.currentTabIndex));
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('developerTools');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTab(selectedTabIndex);

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
                      const DigifyBreadcrumbItem(label: 'Developer Tools'),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(selectedTabIndex)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case _DeveloperToolsTabIndex.functionManagement:
        return const FunctionManagementScreen();
      case _DeveloperToolsTabIndex.desktopManagement:
        return const DesktopManagementMockScreen();
      default:
        return const FunctionManagementScreen();
    }
  }

  String _childLabelForTab(int tabIndex) {
    switch (tabIndex) {
      case _DeveloperToolsTabIndex.functionManagement:
        return 'Function';
      case _DeveloperToolsTabIndex.desktopManagement:
        return 'Desktop Management';
      default:
        return 'Function';
    }
  }
}

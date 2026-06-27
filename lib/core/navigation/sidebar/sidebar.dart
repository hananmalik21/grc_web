import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/sidebar/config/sidebar_config.dart';
import 'package:grc/core/navigation/sidebar/mixins/tab_index_mixin.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/navigation/sidebar/widgets/sidebar_footer.dart';
import 'package:grc/core/navigation/sidebar/widgets/sidebar_header.dart';
import 'package:grc/core/navigation/sidebar/widgets/sidebar_menu.dart';
import 'package:grc/core/navigation/sidebar/widgets/sidebar_menu_item.dart';
import 'package:grc/core/navigation/sidebar/widgets/sidebar_search_section.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/employee_self_service/presentation/providers/employee_self_service_tab_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_management_tab_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprise_structure_tab_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_tab_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_tab_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:grc/features/payroll/application/payroll/providers/payroll_tab_state_provider.dart';
import '../../../features/compensation/presentation/providers/compensation_tab_state_provider.dart';
import '../../../features/developer_tools/presentation/providers/developer_tools_tab_state_provider.dart';
import '../../../features/hiring/presentation/providers/hiring_tab_state_provider.dart';
import '../../../features/security_manager/presentation/providers/security_manager_tab_state_provider.dart';
import '../../../features/time_tracking_and_attendance/presentation/providers/time_tracking_and_attendance_tab_state_provider.dart';
import 'package:digify_grc_suite/grc/presentation/providers/grc_tab_state_provider.dart';

class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> with TabIndexMixin {
  final Map<String, bool> _expandedItems = {};
  String? _lastAutoExpandedRoute;
  final ScrollController _menuScrollController = ScrollController();

  @override
  void dispose() {
    _menuScrollController.dispose();
    super.dispose();
  }

  void _handleNavigation(SidebarItem item) {
    if (item.route != null && mounted) {
      if (item.route == AppRoutes.employees) {
        final tabIndex = getEmployeeManagementTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(employeeManagementTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.employeeSelfService) {
        final tabIndex = getEmployeeSelfServiceTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(employeeSelfServiceTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.enterpriseStructure) {
        final tabIndex = getEnterpriseStructureTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(enterpriseStructureTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.timeManagement) {
        final tabIndex = getTimeManagementTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(timeManagementTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.workforceStructure) {
        final tabIndex = getWorkforceStructureTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(workforceTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.leaveManagement) {
        final tabIndex = getLeaveManagementTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(leaveManagementTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.timeTrackingAndAttendance) {
        final tabIndex = getTimeTrackingAndAttendanceTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(timeTrackingAndAttendanceTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.compensation) {
        final tabIndex = getCompensationTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(compensationTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.securityManager) {
        final tabIndex = getSecurityManagerTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(securityManagerTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.hiring) {
        final tabIndex = getHiringTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(hiringTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.developerTools) {
        final tabIndex = getDeveloperToolsTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(developerToolsTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.payroll) {
        final tabIndex = getPayrollTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(payrollTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      } else if (item.route == AppRoutes.grc) {
        final tabIndex = getGrcTabIndex(item.id);
        if (tabIndex != null) {
          ref.read(grcTabStateProvider.notifier).setTabIndex(tabIndex);
        }
      }
      context.go(item.route!);
      if (!ResponsiveHelper.isWeb(context)) {
        ref.read(sidebarProvider.notifier).collapse();
        Scaffold.maybeOf(context)?.closeDrawer();
      }
    }
  }

  bool _isTabIndexActive(String itemId, String route) {
    if (route == AppRoutes.employees) {
      final state = ref.watch(employeeManagementTabStateProvider);
      final itemTabIndex = getEmployeeManagementTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.employeeSelfService) {
      final state = ref.watch(employeeSelfServiceTabStateProvider);
      final itemTabIndex = getEmployeeSelfServiceTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.enterpriseStructure) {
      final state = ref.watch(enterpriseStructureTabStateProvider);
      final itemTabIndex = getEnterpriseStructureTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.timeManagement) {
      final state = ref.watch(timeManagementTabStateProvider);
      final itemTabIndex = getTimeManagementTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.workforceStructure) {
      final state = ref.watch(workforceTabStateProvider);
      final itemTabIndex = getWorkforceStructureTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.leaveManagement) {
      final state = ref.watch(leaveManagementTabStateProvider);
      final itemTabIndex = getLeaveManagementTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.timeTrackingAndAttendance) {
      final state = ref.watch(timeTrackingAndAttendanceTabStateProvider);
      final itemTabIndex = getTimeTrackingAndAttendanceTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.compensation) {
      final state = ref.watch(compensationTabStateProvider);
      final itemTabIndex = getCompensationTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.grc) {
      final state = ref.watch(grcTabStateProvider);
      final itemTabIndex = getGrcTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.securityManager) {
      final state = ref.watch(securityManagerTabStateProvider);
      final itemTabIndex = getSecurityManagerTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.hiring) {
      final state = ref.watch(hiringTabStateProvider);
      final itemTabIndex = getHiringTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.developerTools) {
      final state = ref.watch(developerToolsTabStateProvider);
      final itemTabIndex = getDeveloperToolsTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    } else if (route == AppRoutes.payroll) {
      final state = ref.watch(payrollTabStateProvider);
      final itemTabIndex = getPayrollTabIndex(itemId);
      if (itemTabIndex == null) return false;
      return itemTabIndex == state.currentTabIndex;
    }
    return true;
  }

  void _toggleExpanded(String id, List<SidebarItem> allItems) {
    setState(() {
      final isCurrentlyExpanded = _expandedItems[id] ?? false;
      if (!isCurrentlyExpanded) {
        for (final item in allItems) {
          if (item.id != id && item.children != null && item.children!.isNotEmpty) {
            _expandedItems[item.id] = false;
          }
        }
      }
      _expandedItems[id] = !isCurrentlyExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = ref.watch(sidebarProvider);
    final localizations = AppLocalizations.of(context)!;
    final menuItems = SidebarConfig.getMenuItems();
    final currentRoute = GoRouterState.of(context).uri.path;

    if (_lastAutoExpandedRoute != currentRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        String? itemToExpand;
        for (final item in menuItems) {
          if (item.children != null) {
            final hasActiveChild = item.children!.any((child) => child.route == currentRoute);
            if (hasActiveChild) {
              itemToExpand = item.id;
              break;
            }
          }
        }
        setState(() {
          if (itemToExpand != null) {
            for (final item in menuItems) {
              if (item.children != null && item.children!.isNotEmpty) {
                _expandedItems[item.id] = item.id == itemToExpand;
              }
            }
          }
          _lastAutoExpandedRoute = currentRoute;
        });
      });
    }

    return Material(
      child: ClipRect(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          width: isExpanded ? 252.w : 0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: AppColors.cardBorder)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(2, 0)),
            ],
          ),
          child: Column(
            children: [
              SidebarHeader(isExpanded: isExpanded),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    opacity: isExpanded ? 1.0 : 0.0,
                    child: ClipRect(child: isExpanded ? const SidebarSearchSection() : const SizedBox.shrink()),
                  ),
                ),
              ),
              Expanded(
                child: SidebarMenu(
                  items: menuItems,
                  isExpanded: isExpanded,
                  scrollController: _menuScrollController,
                  itemBuilder: (context, item, index) =>
                      _buildMenuItem(context, item, menuItems, isExpanded, currentRoute, localizations),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    opacity: isExpanded ? 1.0 : 0.0,
                    child: ClipRect(child: isExpanded ? const SidebarFooter() : const SizedBox.shrink()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    SidebarItem item,
    List<SidebarItem> allItems,
    bool isExpanded,
    String currentRoute,
    AppLocalizations localizations,
  ) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isSectionExpanded = _expandedItems[item.id] ?? false;
    final isDashboardRoute = item.route == AppRoutes.dashboard && currentRoute.startsWith('${AppRoutes.dashboard}/');
    final isRouteMatch =
        item.route == currentRoute ||
        isDashboardRoute ||
        (hasChildren && item.children!.any((child) => child.route == currentRoute));
    final isActive = isRouteMatch && _isTabIndexActive(item.id, item.route ?? '');

    VoidCallback onRowTap;
    if (!isExpanded) {
      onRowTap = () {
        ref.read(sidebarProvider.notifier).expand();
        final route = item.route;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          if (route != null && context.mounted) {
            context.go(route);
          } else if (hasChildren && context.mounted) {
            _toggleExpanded(item.id, allItems);
          }
        });
      };
    } else {
      onRowTap = () => _handleNavigation(item);
    }

    return SidebarMenuItem(
      item: item,
      isSidebarExpanded: isExpanded,
      isSectionExpanded: isSectionExpanded,
      isActive: isActive,
      onRowTap: onRowTap,
      onToggleSection: () => _toggleExpanded(item.id, allItems),
      onChildTap: _handleNavigation,
      isChildActive: (child) => child.route == currentRoute && _isTabIndexActive(child.id, child.route ?? ''),
      localizations: localizations,
    );
  }
}

import 'package:digify_enterprise_structure/digify_enterprise_structure.dart';
import 'package:digify_grc_suite/grc/presentation/providers/grc_tab_state_provider.dart';
import 'package:digify_security_console/digify_security_console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/sidebar/config/sidebar_config.dart';
import 'package:grc/core/navigation/sidebar/mixins/tab_index_mixin.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/features/dashboard/presentation/module_selection/module_selection_sizing.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:grc/features/dashboard/presentation/widgets/sub_module_button.dart';

class ModuleSelectionGrid extends ConsumerWidget with TabIndexMixin {
  final List<SidebarItem> children;
  final Color parentColor;
  final DialogSizing sizing;
  final String parentModuleId;

  const ModuleSelectionGrid({
    super.key,
    required this.children,
    required this.parentColor,
    required this.sizing,
    required this.parentModuleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final spec = _buildSubModuleSpec(sizing.breakpoint);
    return Container(
      child: children.isEmpty
          ? _buildEmptyState()
          : _buildGrid(context, localizations, spec, ref),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No items available',
        style: TextStyle(color: AppColors.textMuted, fontSize: 16.sp),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    AppLocalizations localizations,
    SubModuleSizeSpec spec,
    WidgetRef ref,
  ) {
    final isMobile = sizing.breakpoint == DialogBreakpoint.mobile;

    SubModuleButton buildCard(int index, SidebarItem child) {
      final childLabel = SidebarConfig.getLocalizedLabel(
        child.labelKey,
        localizations,
      );
      final btn = DashboardButton(
        id: child.id,
        icon: child.svgPath ?? 'assets/icons/default_icon.svg',
        label: childLabel,
        color: parentColor,
        route: child.route ?? '',
        isMultiLine: childLabel.contains('\n') || childLabel.length > 20,
        badgeCount: index + 1,
        subtitle:
            child.subtitle ??
            SidebarConfig.getLocalizedDescription(
              child.labelKey,
              localizations,
            ),
      );
      return SubModuleButton(
        button: btn,
        onTap: () {
          if (btn.route.isNotEmpty) {
            context.go(
              btn.route,
              extra: BreadcrumbNavExtra(
                leafLabel: childLabel,
                returnTo: AppRoutes.dashboardModuleSelectionPath(
                  parentModuleId,
                ),
                returnLabel: 'Module Selection',
              ),
            );
            _handleTabNavigation(btn.route, child.id, ref);
          }
        },
        spec: spec,
      );
    }

    if (isMobile) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: sizing.outerPadding),
        crossAxisCount: 2,
        mainAxisSpacing: sizing.gap,
        crossAxisSpacing: sizing.gap,
        childAspectRatio: 0.83,
        children: children
            .asMap()
            .entries
            .map((e) => buildCard(e.key, e.value))
            .toList(),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: sizing.outerPadding),
      child: Wrap(
        spacing: sizing.gap,
        runSpacing: sizing.gap,
        alignment: sizing.wrapAlignment,
        children: children
            .asMap()
            .entries
            .map(
              (e) => SizedBox(
                width: sizing.cardWidth,
                height: sizing.cardHeight,
                child: buildCard(e.key, e.value),
              ),
            )
            .toList(),
      ),
    );
  }

  void _handleTabNavigation(String route, String itemId, WidgetRef ref) {
    final path = Uri.parse(route).path;

    if (path == AppRoutes.enterpriseStructure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        EnterpriseStructureModule.applySidebarTab(ref, path, itemId);
      });
    } else if (path == AppRoutes.grc) {
      final tabIndex = getGrcTabIndex(itemId);
      if (tabIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(grcTabStateProvider.notifier).setTabIndex(tabIndex);
        });
      }
    } else if (path == AppRoutes.securityManager) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SecurityConsoleModule.applySidebarTab(ref, path, itemId);
      });
    }
  }

  SubModuleSizeSpec _buildSubModuleSpec(DialogBreakpoint bp) {
    return SubModuleSizeSpec(
      iconBox: bp == DialogBreakpoint.mobile
          ? 72
          : (bp == DialogBreakpoint.tablet ? 80 : 90),
      iconSize: bp == DialogBreakpoint.mobile
          ? 36
          : (bp == DialogBreakpoint.tablet ? 40 : 45),
      badgeBox: bp == DialogBreakpoint.mobile
          ? 20
          : (bp == DialogBreakpoint.tablet ? 24 : 28),
      badgeFont: bp == DialogBreakpoint.mobile
          ? 10
          : (bp == DialogBreakpoint.tablet ? 11 : 12),
      topPadding: bp == DialogBreakpoint.mobile
          ? 14
          : (bp == DialogBreakpoint.tablet ? 16 : 18),
      gapAfterIcon: bp == DialogBreakpoint.mobile ? 12 : 18,
      gapBeforeSubtitle: bp == DialogBreakpoint.mobile ? 4 : 8,
      titleFont: bp == DialogBreakpoint.mobile ? 13.0 : 15.6,
      subtitleFont: bp == DialogBreakpoint.mobile ? 11.0 : 11.8,
      titleHPad: bp == DialogBreakpoint.mobile
          ? 8
          : (bp == DialogBreakpoint.tablet ? 6 : 8),
      subtitleHPad: bp == DialogBreakpoint.mobile
          ? 4
          : (bp == DialogBreakpoint.tablet ? 4 : 6),
      breakpoint: bp,
    );
  }
}

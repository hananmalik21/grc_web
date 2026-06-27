import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/nav_item_ids.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/sidebar/config/sidebar_config.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/dashboard/presentation/screens/layouts/dashboard_desktop_layout.dart';
import 'package:grc/features/dashboard/presentation/screens/layouts/dashboard_mobile_layout.dart';
import 'package:grc/features/dashboard/presentation/screens/layouts/dashboard_tablet_layout.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_background.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:grc/features/dashboard/presentation/widgets/dashboard_buttons_helper.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleModuleTap(DashboardButton btn) {
    if (btn.id == NavItemIds.dashboard) {
      context.go(btn.route);
      return;
    }

    final sidebarItems = SidebarConfig.getMenuItems();
    SidebarItem? match;

    try {
      match = sidebarItems.firstWhere((item) => item.id == btn.id);
    } catch (_) {
      final camelId = _kebabToCamel(btn.id);
      try {
        match = sidebarItems.firstWhere((item) => item.id == camelId);
      } catch (_) {
        if (btn.id == NavItemIds.settings) {
          try {
            match = sidebarItems.firstWhere(
              (item) => item.id == NavItemIds.settingsConfig,
            );
          } catch (_) {}
        }
      }
    }

    if (match != null && (match.children?.isNotEmpty ?? false)) {
      context.go(AppRoutes.dashboardModuleSelectionPath(btn.id));
    } else {
      context.go(btn.route);
    }
  }

  String _kebabToCamel(String input) {
    if (!input.contains('-')) return input;
    final parts = input.split('-');
    final buffer = StringBuffer(parts[0]);
    for (var i = 1; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        buffer.write(part[0].toUpperCase() + part.substring(1));
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final isLoadingModules =
        currentUserAsync.isLoading && !currentUserAsync.hasValue;
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final buttons = getDashboardButtons(localizations);

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: DigifyAsset(
          assetPath: Assets.icons.manageEnterpriseIcon.path,
          width: 20.w,
          height: 20.h,
          color: AppColors.cardBackground,
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            DashboardBackground(isDark: isDark),
            LayoutBreaker(
              builder: (context, layout, _) {
                final pagePadding = EdgeInsetsDirectional.only(
                  top: layout.isMobile ? 20.h : 45.5.h,
                  start: layout.isMobile ? 12.w : 14.w,
                  end: layout.isMobile ? 12.w : 21.w,
                  bottom: 14.h,
                );

                return SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: pagePadding,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1800),
                        child: switch (layout) {
                          ScreenLayout.desktop => DashboardDesktopLayout(
                            buttons: buttons,
                            localizations: localizations,
                            onButtonTap: _handleModuleTap,
                            isLoadingModules: isLoadingModules,
                          ),
                          ScreenLayout.tabletLarge ||
                          ScreenLayout.tabletMedium => DashboardTabletLayout(
                            buttons: buttons,
                            localizations: localizations,
                            onButtonTap: _handleModuleTap,
                            isLoadingModules: isLoadingModules,
                          ),
                          ScreenLayout.tabletSmall ||
                          ScreenLayout.mobile => DashboardMobileLayout(
                            buttons: buttons,
                            localizations: localizations,
                            onButtonTap: _handleModuleTap,
                            isLoadingModules: isLoadingModules,
                          ),
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

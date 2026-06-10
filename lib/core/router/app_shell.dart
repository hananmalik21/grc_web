import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/locale_provider.dart';
import 'package:grc_web/core/router/app_nav_item.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/theme/theme_provider.dart';
import 'package:grc_web/core/widgets/app_header_bar.dart';
import 'package:grc_web/core/widgets/app_top_nav_bar.dart';
import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final location = GoRouterState.of(context).uri.toString();

    final selected = _selectedForLocation(location);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          AppHeaderBar(
            title: l10n.headerTitle,
            subtitle: l10n.headerSubtitle,
            userName: l10n.userName,
            userRole: l10n.userRole,
          ),
          AppTopNavBar(
            selected: selected,
            onSelect: (item) => _onSelect(context, item),
            onToggleLanguage: () => ref.read(localeProvider.notifier).toggleEnglishArabic(),
            onToggleTheme: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _onSelect(BuildContext context, AppNavItem item) {
    switch (item) {
      case AppNavItem.dashboard:
        context.go(AppRoutes.dashboard);
      case AppNavItem.library:
        context.go(AppRoutes.library);
      case AppNavItem.assets:
        context.go(AppRoutes.assets);
      case AppNavItem.risks:
        context.go(AppRoutes.risks);
      case AppNavItem.assessments:
        context.go(AppRoutes.assessments);
      case AppNavItem.controls:
        context.go(AppRoutes.controls);
      case AppNavItem.tprm:
        context.go(AppRoutes.tprm);
      default:
        // Other tabs not implemented yet.
        break;
    }
  }

  AppNavItem _selectedForLocation(String location) {
    if (location.startsWith(AppRoutes.library)) return AppNavItem.library;
    if (location.startsWith(AppRoutes.assets)) return AppNavItem.assets;
    if (location.startsWith(AppRoutes.risks)) return AppNavItem.risks;
    if (location.startsWith(AppRoutes.assessments)) return AppNavItem.assessments;
    if (location.startsWith(AppRoutes.controls)) return AppNavItem.controls;
    if (location.startsWith(AppRoutes.tprm)) return AppNavItem.tprm;
    if (location.startsWith(AppRoutes.dashboard)) return AppNavItem.dashboard;
    return AppNavItem.dashboard;
  }
}


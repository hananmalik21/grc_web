import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_provider.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'header_left_section.dart';
import 'header_right_section.dart';
import 'header_welcome_section.dart';

class AppHeader extends ConsumerWidget {
  final bool isSidebarExpanded;
  const AppHeader({super.key, this.isSidebarExpanded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final globalLayout = AppBreakpoints.fromShortestSide(context.shortestSide);

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = AppBreakpoints.fromShortestSide(context.shortestSide);
        final double headerHeight = context.responsiveFine(
          mobile: 52.0.h,
          tabletSmall: 52.0.h,
          tabletMedium: 54.0.h,
          tabletLarge: 55.0.h,
          desktop: 56.0.h,
        );
        final double hPadding = context.responsive(mobile: 12.0.w, desktop: 14.0.w);

        return Material(
          color: Colors.transparent,
          child: Container(
            height: headerHeight,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
              border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: hPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderLeftSection(
                    layout: layout,
                    isDark: isDark,
                    isSidebarExpanded: isSidebarExpanded,
                    onMenuTap: () {
                      if (!globalLayout.isDesktop) {
                        if (isSidebarExpanded) {
                          Scaffold.of(context).closeDrawer();
                          ref.read(sidebarProvider.notifier).collapse();
                        } else {
                          Scaffold.of(context).openDrawer();
                          ref.read(sidebarProvider.notifier).expand();
                        }
                      } else {
                        ref.read(sidebarProvider.notifier).toggle();
                      }
                    },
                    onLogoTap: () => context.go(AppRoutes.dashboard),
                  ),
                  if (layout.isDesktop)
                    Expanded(
                      child: HeaderWelcomeSection(localizations: localizations, layout: layout, isDark: isDark),
                    ),
                  HeaderRightSection(
                    layout: globalLayout,
                    isDark: isDark,
                    themeMode: themeMode,
                    locale: locale,
                    localizations: localizations,
                    onToggleTheme: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                    onToggleLocale: () => ref.read(localeProvider.notifier).toggleLocale(),
                    onLogout: () async {
                      await ref.read(authProvider.notifier).logout();
                      PermissionService.instance.clear();
                      if (context.mounted) context.go(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

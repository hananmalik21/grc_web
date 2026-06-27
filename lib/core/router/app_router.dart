import 'package:digify_enterprise_structure/digify_enterprise_structure.dart';
import 'package:digify_grc_suite/digify_grc_suite.dart';
import 'package:digify_security_console/digify_security_console.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/navigation/app_layout.dart';
import 'package:grc/core/navigation/root_navigator_key.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/auth/presentation/screens/login_screen.dart';
import 'package:grc/features/dashboard/presentation/module_selection/module_selection_screen.dart';
import 'package:grc/features/dashboard/presentation/screens/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      if (authState.isRestoring) return null;

      final isAuthenticated = authState.isAuthenticated;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated && !isOnLogin) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isOnLogin) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppLayout(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path:
                    'module-selection/:${AppRoutes.dashboardModuleSelectionParam}',
                name: 'module-selection',
                builder: (context, state) {
                  final moduleId =
                      state.pathParameters[AppRoutes
                          .dashboardModuleSelectionParam] ??
                      '';
                  return ModuleSelectionScreen(moduleId: moduleId);
                },
              ),
            ],
          ),
          ...const EnterpriseStructureModule().routes(),
          ...const SecurityConsoleModule().routes(),
          ...const GrcSuiteModule().routes(),
        ],
      ),
    ],
  );
});

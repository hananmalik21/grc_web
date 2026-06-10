import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grc_web/core/router/app_shell.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/features/auth/presentation/pages/auth_page.dart';
import 'package:grc_web/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:grc_web/features/assets/presentation/pages/assets_page.dart';
import 'package:grc_web/features/library/presentation/pages/library_page.dart';
import 'package:grc_web/features/risks/presentation/pages/risks_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/assessments_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/assessment_hub_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/assessment_questionnaire_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/framework_detail_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/cybersecurity_framework_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/coso_erm_framework_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/orm_framework_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/cloud_vendor_risk_page.dart';
import 'package:grc_web/features/controls/presentation/pages/controls_page.dart';
import 'package:grc_web/features/tprm/presentation/pages/tprm_page.dart';
import 'package:grc_web/features/assessments/presentation/pages/business_continuity_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardPage()),
          ),
          GoRoute(
            path: AppRoutes.library,
            name: 'library',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LibraryPage()),
          ),
          GoRoute(
            path: AppRoutes.assets,
            name: 'assets',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AssetsPage()),
          ),
          GoRoute(
            path: AppRoutes.risks,
            name: 'risks',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RisksPage()),
          ),
          GoRoute(
            path: AppRoutes.controls,
            name: 'controls',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ControlsPage()),
          ),
          GoRoute(
            path: AppRoutes.tprm,
            name: 'tprm',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TprmPage()),
          ),
          GoRoute(
            path: AppRoutes.assessments,
            name: 'assessments',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AssessmentsPage()),
          ),
          GoRoute(
            path: AppRoutes.assessmentHub,
            name: 'assessmentHub',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AssessmentHubPage()),
          ),
          GoRoute(
            path: AppRoutes.assessmentQuestionnaire,
            name: 'assessmentQuestionnaire',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AssessmentQuestionnairePage()),
          ),
          GoRoute(
            path: AppRoutes.assessmentDetail,
            name: 'assessmentDetail',
            pageBuilder: (context, state) => NoTransitionPage(
              child: FrameworkDetailPage(
                frameworkName: state.extra as String? ?? 'SOX (Sarbanes-Oxley)',
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.assessmentCyber,
            name: 'assessmentCyber',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CybersecurityFrameworkPage()),
          ),
          GoRoute(
            path: AppRoutes.assessmentCosoErm,
            name: 'assessmentCosoErm',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CosoErmFrameworkPage()),
          ),
          GoRoute(
            path: AppRoutes.assessmentOrm,
            name: 'assessmentOrm',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: OrmFrameworkPage()),
          ),
          GoRoute(
            path: AppRoutes.assessmentCloudVendor,
            name: 'assessmentCloudVendor',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CloudVendorRiskPage()),
          ),
          GoRoute(
            path: AppRoutes.assessmentBcm,
            name: 'assessmentBcm',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BusinessContinuityPage()),
          ),
        ],
      ),
    ],
  );
});


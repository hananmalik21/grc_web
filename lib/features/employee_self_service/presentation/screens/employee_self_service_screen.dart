import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/features/employee_self_service/presentation/providers/employee_self_service_tab_provider.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/documents_letters_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/employment_info_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/learning_development_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/leave_absence_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/mobile_experience_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/my_payslips_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/pay_benefits_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/performance_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/profile_identity_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/requests_workflow_tab.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/time_attendance_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class _EmployeeSelfServiceTabIndex {
  static const int profileIdentity = 0;
  static const int employmentInfo = 1;
  static const int payBenefits = 2;
  static const int myPayslips = 3;
  static const int leaveAbsence = 4;
  static const int timeAttendance = 5;
  static const int performance = 6;
  static const int learningDevelopment = 7;
  static const int documentsLetters = 8;
  static const int requestsWorkflow = 9;
  static const int mobileExperience = 10;
}

class EmployeeSelfServiceScreen extends ConsumerWidget {
  const EmployeeSelfServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTabIndex = ref.watch(employeeSelfServiceTabStateProvider.select((s) => s.currentTabIndex));
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('employeeSs');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTab(selectedTabIndex);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 14.h),
            child: DigifyBreadcrumb(
              items: [
                DigifyBreadcrumbItem(label: 'Dashboard', onTap: () => context.go(AppRoutes.dashboard)),
                DigifyBreadcrumbItem(label: localizations.employeeSelfService),
                DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                DigifyBreadcrumbItem(label: childLabel),
              ],
            ),
          ),
          Gap(24.h),
          Expanded(child: _buildTabContent(selectedTabIndex)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    return switch (tabIndex) {
      _EmployeeSelfServiceTabIndex.profileIdentity => const ProfileIdentityTab(),
      _EmployeeSelfServiceTabIndex.employmentInfo => const EmploymentInfoTab(),
      _EmployeeSelfServiceTabIndex.payBenefits => const PayBenefitsTab(),
      _EmployeeSelfServiceTabIndex.myPayslips => const MyPayslipsTab(),
      _EmployeeSelfServiceTabIndex.leaveAbsence => const LeaveAbsenceTab(),
      _EmployeeSelfServiceTabIndex.timeAttendance => const TimeAttendanceTab(),
      _EmployeeSelfServiceTabIndex.performance => const PerformanceTab(),
      _EmployeeSelfServiceTabIndex.learningDevelopment => const LearningDevelopmentTab(),
      _EmployeeSelfServiceTabIndex.documentsLetters => const DocumentsLettersTab(),
      _EmployeeSelfServiceTabIndex.requestsWorkflow => const RequestsWorkflowTab(),
      _EmployeeSelfServiceTabIndex.mobileExperience => const MobileExperienceTab(),
      _ => const ProfileIdentityTab(),
    };
  }

  String _childLabelForTab(int tabIndex) {
    switch (tabIndex) {
      case _EmployeeSelfServiceTabIndex.profileIdentity:
        return 'Profile & Identity';
      case _EmployeeSelfServiceTabIndex.employmentInfo:
        return 'Employment Info';
      case _EmployeeSelfServiceTabIndex.payBenefits:
        return 'Pay & Benefits';
      case _EmployeeSelfServiceTabIndex.myPayslips:
        return 'My Payslips';
      case _EmployeeSelfServiceTabIndex.leaveAbsence:
        return 'Leave & Absence';
      case _EmployeeSelfServiceTabIndex.timeAttendance:
        return 'Time & Attendance';
      case _EmployeeSelfServiceTabIndex.performance:
        return 'Performance';
      case _EmployeeSelfServiceTabIndex.learningDevelopment:
        return 'Learning & Development';
      case _EmployeeSelfServiceTabIndex.documentsLetters:
        return 'Documents & Letters';
      case _EmployeeSelfServiceTabIndex.requestsWorkflow:
        return 'Requests & Workflow';
      case _EmployeeSelfServiceTabIndex.mobileExperience:
        return 'Mobile Experience';
      default:
        return 'Profile & Identity';
    }
  }
}

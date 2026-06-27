import 'package:digify_grc_suite/digify_grc_suite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/compensation/presentation/screens/compensation_screen.dart';
import '../../features/compensation/presentation/screens/adjustments/create_salary_adjustment_page.dart';
import '../../features/compensation/presentation/screens/components_tab/component_creation.dart';
import '../../features/compensation/presentation/screens/components_tab/component_update.dart';
import '../../features/compensation/domain/models/components/comp_component.dart';
import '../../features/compensation/presentation/screens/compensation_plans_tab/create_compensation_plan_screen.dart';
import '../../features/compensation/presentation/screens/compensation_plans_tab/compensation_plan_detail_screen.dart';
import '../../features/compensation/presentation/screens/compensation_plans_tab/edit_compensation_plan_screen.dart';
import '../../features/compensation/presentation/screens/employee_compensation/create_employee_compensation_plan_page.dart';
import '../../features/compensation/presentation/screens/employee_compensation/employee_compensation_detail_page.dart';
import '../../features/compensation/presentation/screens/localization_tab/country_rule.dart';
import '../../features/compensation/presentation/screens/manage_salary_structure_tab/create_salary_strcuture.dart';
import '../../features/compensation/presentation/screens/manage_salary_structure_tab/edit_salary_structure.dart';
import '../../features/dashboard/presentation/module_selection/module_selection_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/payroll/presentation/screens/payroll_screen.dart';
import '../../features/payroll/presentation/screens/element_entries/add_element_screen.dart';
import '../../features/payroll/presentation/screens/person_results/person_result_detail_page.dart';
import '../../features/payroll/presentation/screens/person_results/person_result_task_detail_page.dart';
import '../../features/payroll/presentation/models/person_result_task_detail_args.dart';
import '../../features/payroll/domain/models/person_result_employee.dart';
import '../../features/developer_tools/presentation/screens/developer_tools_screen.dart';
import '../../features/hiring/presentation/screens/application_detail_page.dart';
import '../../features/hiring/presentation/screens/candidate_detail_page.dart';
import '../../features/hiring/presentation/screens/hiring_screen.dart';
import '../../features/hiring/presentation/screens/requisition_detail_page.dart';
import '../../features/hiring/presentation/screens/requisitions_tab/create_requisition_screen.dart';
import '../../features/hiring/presentation/screens/offers_tab/create_offer_screen.dart';
import '../../features/hiring/presentation/models/application_table_row_data.dart';
import '../../features/hiring/presentation/models/candidate_data.dart';
import '../../features/hiring/presentation/models/requisition_table_row_data.dart';
import '../../features/employee_self_service/presentation/screens/employee_self_service_screen.dart';
import '../../features/employee_management/domain/models/employee_list_item.dart';
import '../../features/employee_management/presentation/screens/employee_management_screens.dart';
import '../../features/enterprise_structure/presentation/screens/enterprise_structure_screen.dart';
import '../../features/leave_management/presentation/screens/leave_management_screen.dart';
import '../../features/leave_management/presentation/screens/leave_request_employee_detail_screen.dart';
import '../../features/security_manager/presentation/screens/functional_areas/application_role_detail_screen.dart';
import '../../features/security_manager/presentation/screens/user_management/user_detail_screen.dart';
import '../../features/security_manager/presentation/providers/application_roles/application_roles_state.dart';
import '../../features/time_management/presentation/screens/time_management_screen.dart';
import '../../features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import '../../features/time_tracking_and_attendance/presentation/screens/time_tracking_and_attendance_screen.dart';
import '../../features/time_tracking_and_attendance/presentation/screens/timesheet_detail_screen.dart';
import '../../features/security_manager/presentation/screens/security_manager_screen.dart';
import '../../features/security_manager/presentation/screens/user_management/create_user_screen.dart';
import '../../features/security_manager/presentation/screens/user_management/edit_user_screen.dart';
import '../../features/security_manager/domain/models/system_user.dart';
import '../../features/workforce_structure/presentation/screens/workforce_structure_screen.dart';
import '../../features/compensation/presentation/models/compensation_plan_table_row_data.dart';
import '../navigation/app_layout.dart';
import '../navigation/root_navigator_key.dart';
import '../widgets/feedback/placeholder_screen.dart';
import 'app_routes.dart';

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
      GoRoute(path: AppRoutes.login, name: 'login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'module-selection/:${AppRoutes.dashboardModuleSelectionParam}',
                name: 'module-selection',
                builder: (context, state) {
                  final moduleId = state.pathParameters[AppRoutes.dashboardModuleSelectionParam] ?? '';
                  return ModuleSelectionScreen(moduleId: moduleId);
                },
              ),
              GoRoute(
                path: 'overview',
                name: 'dashboard-overview',
                builder: (context, state) => const PlaceholderScreen(title: 'Dashboard Overview'),
              ),
              GoRoute(
                path: 'analytics',
                name: 'dashboard-analytics',
                builder: (context, state) => const PlaceholderScreen(title: 'Analytics'),
              ),
              GoRoute(
                path: 'quick-actions',
                name: 'dashboard-quick-actions',
                builder: (context, state) => const PlaceholderScreen(title: 'Quick Actions'),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.moduleCatalogue,
            name: 'module-catalogue',
            builder: (context, state) => const PlaceholderScreen(title: 'Module Catalogue'),
          ),
          GoRoute(
            path: AppRoutes.productIntro,
            name: 'product-intro',
            builder: (context, state) => const PlaceholderScreen(title: 'Product Introduction'),
          ),
          GoRoute(
            path: AppRoutes.enterpriseStructure,
            name: 'enterprise-structure',
            builder: (context, state) => const EnterpriseStructureScreen(),
          ),
          GoRoute(
            path: AppRoutes.workforceStructure,
            name: 'workforce-structure',
            builder: (context, state) => const WorkforceStructureScreen(),
          ),
          GoRoute(
            path: AppRoutes.employeeSelfService,
            name: 'employee-self-service',
            builder: (context, state) => const EmployeeSelfServiceScreen(),
          ),
          GoRoute(
            path: AppRoutes.timeManagement,
            name: 'time-management',
            builder: (context, state) => const TimeManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.employees,
            name: 'employees',
            builder: (context, state) => const EmployeeManagementScreen(),
            routes: [
              GoRoute(
                path: 'detail',
                name: 'employee-detail',
                builder: (context, state) {
                  final employee = state.extra is EmployeeListItem ? state.extra! as EmployeeListItem : null;
                  if (employee == null) {
                    return Scaffold(body: Center(child: Text('Employee not found')));
                  }
                  return EmployeeDetailScreen(employee: employee);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.leaveManagement,
            name: 'leave-management',
            builder: (context, state) => const LeaveManagementScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.leaveManagementEmployeeLeaveHistorySegment,
                name: 'leave-management-employee-leave-history',
                builder: (context, state) {
                  final employeeGuid = state.extra is String ? state.extra! as String : null;
                  if (employeeGuid == null || employeeGuid.isEmpty) {
                    return Scaffold(body: Center(child: Text('Invalid navigation state')));
                  }
                  return LeaveRequestEmployeeDetailScreen(employeeGuid: employeeGuid);
                },
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.timeTrackingAndAttendance,
            name: 'time-tracking-and-attendance',
            builder: (context, state) => const TimeTrackingAndAttendanceScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.timeTrackingTimesheetDetailSegment,
                name: 'time-tracking-timesheet-detail',
                builder: (context, state) {
                  final timesheet = state.extra is Timesheet ? state.extra! as Timesheet : null;
                  if (timesheet == null) {
                    return const Scaffold(body: Center(child: Text('Invalid navigation state')));
                  }
                  return TimesheetDetailScreen(timesheet: timesheet);
                },
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.compensation,
            name: 'compensation',
            builder: (context, state) => const CompensationScreen(),
            routes: [
              GoRoute(
                path: 'localization/country-rule',
                name: 'compensation-localization-country-rule',
                builder: (context, state) => CountryRuleScreen(),
              ),

              GoRoute(
                path: 'components/component-creation',
                name: ComponentCreationScreen.routeName,
                builder: (context, state) => ComponentCreationScreen(),
              ),

              GoRoute(
                path: 'components/component-update',
                name: ComponentUpdateScreen.routeName,
                builder: (context, state) {
                  final component = state.extra as CompComponent;
                  return ComponentUpdateScreen(component: component);
                },
              ),

              GoRoute(
                path: AppRoutes.compensationManageSalaryStructureCreate,
                name: SalaryStructureCreationScreen.routeName,
                builder: (context, state) => const SalaryStructureCreationScreen(),
              ),
              GoRoute(
                path: AppRoutes.compensationManageSalaryStructureEdit,
                name: SalaryStructureEditScreen.routeName,
                builder: (context, state) =>
                    SalaryStructureEditScreen(structureGuid: state.pathParameters['structureGuid'] ?? ''),
              ),
              GoRoute(
                path: AppRoutes.compensationCompensationPlansCreate,
                name: CreateCompensationPlanScreen.routeName,
                builder: (context, state) => const CreateCompensationPlanScreen(),
              ),
              GoRoute(
                path: AppRoutes.compensationCompensationPlansEditSegment,
                name: EditCompensationPlanScreen.routeName,
                builder: (context, state) =>
                    EditCompensationPlanScreen(planGuid: state.pathParameters['planGuid'] ?? ''),
              ),
              GoRoute(
                path: AppRoutes.compensationCompensationPlansDetailSegment,
                name: CompensationPlanDetailScreen.routeName,
                builder: (context, state) {
                  final row = state.extra is CompensationPlanTableRowData
                      ? state.extra! as CompensationPlanTableRowData
                      : null;

                  if (row == null) {
                    return const Scaffold(body: Center(child: Text('Compensation plan not found')));
                  }

                  return CompensationPlanDetailScreen(row: row);
                },
              ),
              GoRoute(
                path: AppRoutes.compensationEmployeeCompensationDetailSegment,
                name: EmployeeCompensationDetailPage.routeName,
                builder: (context, state) {
                  final extra = state.extra as Map<String, String>?;
                  final employeeId = extra?['employeeGuid'] ?? '';
                  final planGuid = extra?['planGuid'] ?? '';
                  return EmployeeCompensationDetailPage(employeeId: employeeId, planGuid: planGuid);
                },
              ),
              GoRoute(
                path: AppRoutes.compensationEmployeeCompensationCreate,
                name: CreateEmployeeCompensationPlanPage.routeName,
                builder: (context, state) => const CreateEmployeeCompensationPlanPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.compensationAdjustmentsCreate,
            name: CreateSalaryAdjustmentPage.routeName,
            builder: (context, state) {
              final query = state.uri.queryParameters;
              final employeeGuid = query['employeeGuid'];
              final enterpriseId = int.tryParse(query['enterpriseId'] ?? '');
              return CreateSalaryAdjustmentPage(
                initialEmployeeGuid: employeeGuid,
                initialEnterpriseId: enterpriseId,
                lockEmployeeSelection: employeeGuid != null && employeeGuid.isNotEmpty,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.securityManager,
            name: 'security-manager',
            builder: (context, state) => const SecurityManagerScreen(),
            routes: [
              GoRoute(
                path: 'user/add',
                name: CreateUserScreen.routeName,
                builder: (context, state) => const CreateUserScreen(),
              ),
              GoRoute(
                path: 'user/edit',
                name: EditUserScreen.routeName,
                builder: (context, state) {
                  final user = state.extra is SystemUser ? state.extra! as SystemUser : null;
                  if (user == null) {
                    return const Scaffold(body: Center(child: Text('User not found')));
                  }
                  return EditUserScreen(user: user);
                },
              ),
              GoRoute(
                path: 'user/show',
                name: UserDetailScreen.routeName,
                builder: (context, state) {
                  final user = state.extra is SystemUser ? state.extra! as SystemUser : null;
                  return UserDetailScreen(user: user);
                },
              ),
              GoRoute(
                path: 'application-role/detail',
                name: 'security-manager-application-role-detail',
                builder: (context, state) {
                  final role = state.extra is ApplicationRoleItem ? state.extra! as ApplicationRoleItem : null;
                  if (role == null) {
                    return const Scaffold(body: Center(child: Text('Role not found')));
                  }
                  return ApplicationRoleDetailScreen(role: role);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.hiring,
            name: 'hiring',
            builder: (context, state) => const HiringScreen(),
            routes: [
              GoRoute(
                path: RequisitionDetailPage.path,
                name: RequisitionDetailPage.routeName,
                builder: (context, state) {
                  final row = state.extra is RequisitionTableRowData ? state.extra! as RequisitionTableRowData : null;
                  if (row == null) {
                    return const Scaffold(body: Center(child: Text('Requisition not found')));
                  }
                  return RequisitionDetailPage(row: row);
                },
              ),
              GoRoute(
                path: AppRoutes.hiringRequisitionCreate,
                name: CreateRequisitionScreen.routeName,
                builder: (context, state) => const CreateRequisitionScreen(),
              ),
              GoRoute(
                path: AppRoutes.hiringRequisitionEdit,
                name: CreateRequisitionScreen.editRouteName,
                builder: (context, state) {
                  final row = state.extra is RequisitionTableRowData ? state.extra! as RequisitionTableRowData : null;
                  return CreateRequisitionScreen(requisitionToEdit: row);
                },
              ),
              GoRoute(
                path: AppRoutes.hiringRequisitionDuplicate,
                name: CreateRequisitionScreen.duplicateRouteName,
                builder: (context, state) {
                  final row = state.extra is RequisitionTableRowData ? state.extra! as RequisitionTableRowData : null;
                  return CreateRequisitionScreen(requisitionToDuplicate: row);
                },
              ),
              GoRoute(
                path: AppRoutes.hiringOfferCreate,
                name: CreateOfferScreen.routeName,
                builder: (context, state) => const CreateOfferScreen(),
              ),
              GoRoute(
                path: CandidateDetailPage.path,
                name: CandidateDetailPage.routeName,
                builder: (context, state) {
                  final candidate = state.extra is CandidateData ? state.extra! as CandidateData : null;
                  if (candidate == null) {
                    return const Scaffold(body: Center(child: Text('Candidate not found')));
                  }
                  return CandidateDetailPage(candidate: candidate);
                },
              ),
              GoRoute(
                path: ApplicationDetailPage.path,
                name: ApplicationDetailPage.routeName,
                builder: (context, state) {
                  final application = state.extra is ApplicationTableRowData
                      ? state.extra! as ApplicationTableRowData
                      : null;
                  if (application == null) {
                    return const Scaffold(body: Center(child: Text('Application not found')));
                  }
                  return ApplicationDetailPage(application: application);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.developerTools,
            name: 'developer-tools',
            builder: (context, state) => const DeveloperToolsScreen(),
          ),
          GoRoute(
            path: AppRoutes.payroll,
            name: 'payroll',
            builder: (context, state) => const PayrollScreen(),
            routes: [
              GoRoute(
                path: 'add-element',
                name: 'payroll-add-element',
                builder: (context, state) => const AddElementScreen(),
              ),
              GoRoute(
                path: PersonResultDetailPage.path,
                name: PersonResultDetailPage.routeName,
                builder: (context, state) {
                  final employee = state.extra is PersonResultEmployee ? state.extra! as PersonResultEmployee : null;
                  if (employee == null) {
                    return const Scaffold(body: Center(child: Text('Employee not found')));
                  }
                  return PersonResultDetailPage(employee: employee);
                },
                routes: [
                  GoRoute(
                    path: PersonResultTaskDetailPage.path,
                    name: PersonResultTaskDetailPage.routeName,
                    builder: (context, state) {
                      final args = state.extra is PersonResultTaskDetailArgs
                          ? state.extra! as PersonResultTaskDetailArgs
                          : null;
                      if (args == null) {
                        return const Scaffold(body: Center(child: Text('Task not found')));
                      }
                      return PersonResultTaskDetailPage(args: args);
                    },
                  ),
                ],
              ),
            ],
          ),
          ...const GrcSuiteModule().routes(),
          GoRoute(
            path: AppRoutes.eosCalculator,
            name: 'eos-calculator',
            builder: (context, state) => const PlaceholderScreen(title: 'EOS Calculator'),
          ),
          GoRoute(
            path: AppRoutes.reports,
            name: 'reports',
            builder: (context, state) => const PlaceholderScreen(title: 'Reports'),
          ),
          GoRoute(
            path: AppRoutes.governmentForms,
            name: 'government-forms',
            builder: (context, state) => const PlaceholderScreen(title: 'Government Forms'),
          ),
          GoRoute(
            path: AppRoutes.deiDashboard,
            name: 'dei-dashboard',
            builder: (context, state) => const PlaceholderScreen(title: 'DEI Dashboard'),
          ),
          GoRoute(
            path: AppRoutes.hrOperations,
            name: 'hr-operations',
            builder: (context, state) => const PlaceholderScreen(title: 'HR Operations'),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const PlaceholderScreen(title: 'Settings & Configurations'),
          ),
          GoRoute(path: AppRoutes.home, name: 'home', redirect: (context, state) => AppRoutes.dashboard),
        ],
      ),
    ],
  );
});

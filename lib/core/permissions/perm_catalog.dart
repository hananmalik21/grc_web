import 'package:grc/core/router/app_routes.dart';

import 'perm_module.dart';

const kDashboardModule = PermModule(
  label: 'Dashboard',
  baseKey: 'dashboard',
  subModules: [
    PermSubModule(
      label: 'Dashboard',
      baseKey: 'dashboard.overview',
      route: AppRoutes.dashboard,
    ),
  ],
);

const kEnterpriseStructureModule = PermModule(
  label: 'Enterprise Structure',
  baseKey: 'enterprise_structure',
  subModules: [
    PermSubModule(
      label: 'Manage Structure',
      baseKey: 'enterprise_structure.manage_enterprise_structure',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Component Values',
      baseKey: 'enterprise_structure.manage_component_values',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Company',
      baseKey: 'enterprise_structure.company',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Division',
      baseKey: 'enterprise_structure.division',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Business Unit',
      baseKey: 'enterprise_structure.business_unit',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Department',
      baseKey: 'enterprise_structure.department',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Section',
      baseKey: 'enterprise_structure.section',
      route: AppRoutes.enterpriseStructure,
    ),
  ],
);

const kSecurityModule = PermModule(
  label: 'Security Manager',
  baseKey: 'security_manager',
  subModules: [
    PermSubModule(
      label: 'Security Overview',
      baseKey: 'security_manager.overview',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'User Management',
      baseKey: 'security_manager.user_management',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Access Management',
      baseKey: 'security_manager.access_management',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Roles Management',
      baseKey: 'security_manager.roles_management',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Security Policies',
      baseKey: 'security_manager.security_policies',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Active Sessions',
      baseKey: 'security_manager.active_sessions',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Security Alerts',
      baseKey: 'security_manager.security_alerts',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Data Classification',
      baseKey: 'security_manager.data_classification',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Role Delegation',
      baseKey: 'security_manager.role_delegation',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Segregation of Duties',
      baseKey: 'security_manager.segregation_of_duties',
      route: AppRoutes.securityManager,
    ),
  ],
);

const kGrcModule = PermModule(
  label: 'GRC',
  baseKey: 'grc',
  subModules: [
    PermSubModule(
      label: 'Dashboard',
      baseKey: 'grc.dashboard',
      route: AppRoutes.grc,
    ),
    PermSubModule(
      label: 'Library',
      baseKey: 'grc.library',
      route: AppRoutes.grc,
    ),
    PermSubModule(label: 'Assets', baseKey: 'grc.assets', route: AppRoutes.grc),
    PermSubModule(label: 'Risks', baseKey: 'grc.risks', route: AppRoutes.grc),
    PermSubModule(
      label: 'Assessments',
      baseKey: 'grc.assessments',
      route: AppRoutes.grc,
    ),
    PermSubModule(
      label: 'Controls',
      baseKey: 'grc.controls',
      route: AppRoutes.grc,
    ),
    PermSubModule(label: 'TPRM', baseKey: 'grc.tprm', route: AppRoutes.grc),
    PermSubModule(
      label: 'Programs',
      baseKey: 'grc.programs',
      route: AppRoutes.grc,
    ),
  ],
);

const kAllModules = <PermModule>[
  kDashboardModule,
  kEnterpriseStructureModule,
  kSecurityModule,
  kGrcModule,
];

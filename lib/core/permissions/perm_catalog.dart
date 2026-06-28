import 'package:digify_core/permissions/perm_catalog.dart'
    show kDashboardModule;
import 'package:digify_core/permissions/perm_module.dart';
import 'package:digify_enterprise_structure/integration/es_suite_permissions.dart';
import 'package:digify_grc_suite/integration/grc_suite_permissions.dart';
import 'package:digify_security_console/integration/sc_suite_permissions.dart';

export 'package:digify_core/permissions/perm_catalog.dart'
    show kDashboardModule, kSecurityModule;
export 'package:digify_enterprise_structure/integration/es_suite_permissions.dart'
    show kEnterpriseStructureModule, kEnterpriseStructurePermissionModules;
export 'package:digify_grc_suite/integration/grc_suite_permissions.dart'
    show kGrcModule, kGrcPermissionModules;
export 'package:digify_security_console/integration/sc_suite_permissions.dart'
    show kSecurityConsolePermissionModules;

const kAllModules = <PermModule>[
  kDashboardModule,
  ...kEnterpriseStructurePermissionModules,
  ...kSecurityConsolePermissionModules,
  ...kGrcPermissionModules,
];

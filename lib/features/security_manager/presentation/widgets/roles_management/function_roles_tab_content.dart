import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_modules/security_modules_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/function_roles/function_roles_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FunctionRolesTabContent extends ConsumerStatefulWidget {
  const FunctionRolesTabContent({super.key});

  @override
  ConsumerState<FunctionRolesTabContent> createState() => _FunctionRolesTabContentState();
}

class _FunctionRolesTabContentState extends ConsumerState<FunctionRolesTabContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(functionRolesProvider.notifier).refresh();
      ref.read(securityModulesProvider.notifier).load();
    });
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(securityManagerEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.functionRoles(localizations));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int?>(securityManagerEnterpriseIdProvider, (previous, next) {
      if (previous != next) {
        ref.read(functionRolesProvider.notifier).refresh();
        ref.read(securityModulesProvider.notifier).load();
      }
    });

    final isMobile = context.isMobile;
    final localizations = AppLocalizations.of(context)!;
    final isExporting = ref.watch(spreadsheetExportProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.h,
      children: [
        const FunctionRolesStatsRow(),
        if (isMobile) const FunctionRolesSearchCardMobile() else const FunctionRolesSearchCard(),
        if (isMobile)
          FunctionRolesDirectorySectionMobile(onExport: () => _onExport(localizations), isExporting: isExporting)
        else
          FunctionRolesDirectorySection(onExport: () => _onExport(localizations), isExporting: isExporting),
      ],
    );
  }
}

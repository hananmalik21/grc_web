import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles/duty_roles_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DutyRolesTabContent extends ConsumerStatefulWidget {
  const DutyRolesTabContent({super.key});

  @override
  ConsumerState<DutyRolesTabContent> createState() => _DutyRolesTabContentState();
}

class _DutyRolesTabContentState extends ConsumerState<DutyRolesTabContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dutyRolesProvider.notifier).refresh();
    });
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(securityManagerEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.dutyRoles(localizations));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int?>(securityManagerEnterpriseIdProvider, (previous, next) {
      if (previous != next) {
        ref.read(dutyRolesProvider.notifier).refresh();
      }
    });

    final isMobile = context.isMobile;
    final state = ref.watch(dutyRolesProvider);
    final notifier = ref.read(dutyRolesProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final isExporting = ref.watch(spreadsheetExportProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.h,
      children: [
        const DutyRolesStatsRow(),
        if (isMobile) const DutyRolesSearchCardMobile() else const DutyRolesSearchCard(),
        if (isMobile)
          DutyRolesDirectorySectionMobile(onExport: () => _onExport(localizations), isExporting: isExporting)
        else
          DutyRolesDirectorySection(
            state: state,
            onPrevious: notifier.previousPage,
            onNext: notifier.nextPage,
            onPageTap: notifier.goToPage,
            onExport: () => _onExport(localizations),
            isExporting: isExporting,
          ),
      ],
    );
  }
}

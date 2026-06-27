import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/job_roles/job_roles_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobRolesTabContent extends ConsumerStatefulWidget {
  const JobRolesTabContent({super.key});

  @override
  ConsumerState<JobRolesTabContent> createState() => _JobRolesTabContentState();
}

class _JobRolesTabContentState extends ConsumerState<JobRolesTabContent> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(jobRolesProvider).searchQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobRolesProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(securityManagerEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.jobRoles(localizations));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int?>(securityManagerEnterpriseIdProvider, (previous, next) {
      if (previous != next) {
        ref.read(jobRolesProvider.notifier).refresh();
      }
    });

    final isMobile = context.isMobile;
    final state = ref.watch(jobRolesProvider);
    final notifier = ref.read(jobRolesProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final isExporting = ref.watch(spreadsheetExportProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.h,
      children: [
        const JobRolesStatsRow(),
        if (isMobile)
          JobRolesSearchCardMobile(searchController: _searchController, onSearchChanged: notifier.updateSearch)
        else
          JobRolesSearchCard(searchController: _searchController, onSearchChanged: notifier.updateSearch),
        if (isMobile)
          JobRolesDirectorySectionMobile(onExport: () => _onExport(localizations), isExporting: isExporting)
        else
          JobRolesDirectorySection(
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

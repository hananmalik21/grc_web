import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/data_roles_tab_content.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles_tab_content.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/function_roles_tab_content.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/job_roles_tab_content.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_type_tabs.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_type_tabs_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RolesManagementContent extends ConsumerWidget {
  const RolesManagementContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(rolesManagementProvider);
    final notifier = ref.read(rolesManagementProvider.notifier);
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final layout = context.screenLayout;
    final useCompactRoleTypeTabs = layout.isMobile || layout.isTabletSmall;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            useCompactRoleTypeTabs
                ? RolesManagementTypeTabsMobile(selectedType: state.filterType, onTypeSelected: notifier.selectRoleType)
                : RolesManagementTypeTabs(selectedType: state.filterType, onTypeSelected: notifier.selectRoleType),
            Gap(sectionSpacing),
            _buildTabContent(state.filterType),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String filterType) {
    if (filterType == RoleType.function.label) return const FunctionRolesTabContent();
    if (filterType == RoleType.duty.label) return const DutyRolesTabContent();
    if (filterType == RoleType.job.label) return const JobRolesTabContent();
    if (filterType == RoleType.data.label) return const DataRolesTabContent();
    return const FunctionRolesTabContent();
  }
}

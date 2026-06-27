import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/mobile_structures_list_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/stats_cards_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/structures_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ManageEnterpriseStructureContent extends StatelessWidget {
  const ManageEnterpriseStructureContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
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
            StatsCardsWidget(localizations: localizations, isDark: isDark),
            Gap(sectionSpacing),
            if (isMobile)
              MobileStructuresListWidget(
                localizations: localizations,
                isDark: isDark,
                structureListProvider: manageEnterpriseStructureStructureListProvider,
                saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
              )
            else
              StructuresListWidget(
                localizations: localizations,
                isDark: isDark,
                structureListProvider: manageEnterpriseStructureStructureListProvider,
                saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
              ),
          ],
        ),
      ),
    );
  }
}

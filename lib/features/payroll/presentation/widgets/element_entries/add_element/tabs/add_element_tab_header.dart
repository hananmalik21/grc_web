import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/application/element_entries/states/add_element_form_state.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/tabs/add_element_tab_button.dart';
import 'package:flutter/material.dart';

class AddElementTabHeader extends StatelessWidget {
  const AddElementTabHeader({required this.selectedTab, required this.onTabSelected, super.key});

  final AddElementTab selectedTab;
  final ValueChanged<AddElementTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          AddElementTabButton(
            label: loc.payrollAddElementGeneralInformation,
            isSelected: selectedTab == AddElementTab.generalInformation,
            onTap: () => onTabSelected(AddElementTab.generalInformation),
          ),
          AddElementTabButton(
            label: loc.payrollAddElementCosting,
            isSelected: selectedTab == AddElementTab.costing,
            onTap: () => onTabSelected(AddElementTab.costing),
          ),
        ],
      ),
    );
  }
}

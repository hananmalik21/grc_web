import 'package:grc/features/payroll/application/element_entries/states/add_element_form_state.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_section_card.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_costing_tab.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_general_information_tab.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/tabs/add_element_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddElementDetailsTabsSection extends StatelessWidget {
  const AddElementDetailsTabsSection({
    required this.selectedTab,
    required this.onTabSelected,
    required this.generalInformationTab,
    required this.costingTab,
    super.key,
  });

  final AddElementTab selectedTab;
  final ValueChanged<AddElementTab> onTabSelected;
  final AddElementGeneralInformationTab generalInformationTab;
  final AddElementCostingTab costingTab;

  @override
  Widget build(BuildContext context) {
    return AddElementSectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddElementTabHeader(selectedTab: selectedTab, onTabSelected: onTabSelected),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(29.w, 24.h, 29.w, 29.h),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: selectedTab == AddElementTab.generalInformation
                  ? KeyedSubtree(key: const ValueKey('general'), child: generalInformationTab)
                  : KeyedSubtree(key: const ValueKey('costing'), child: costingTab),
            ),
          ),
        ],
      ),
    );
  }
}

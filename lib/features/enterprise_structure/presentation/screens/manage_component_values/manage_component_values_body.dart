import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_level_tabs.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_stat_cards.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageComponentValuesBody extends StatelessWidget {
  const ManageComponentValuesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ComponentValuesStatCards(),
        SizedBox(height: 24.h),
        const ComponentValuesLevelTabs(),
        SizedBox(height: 24.h),
        const ComponentValuesTabContent(),
      ],
    );
  }
}

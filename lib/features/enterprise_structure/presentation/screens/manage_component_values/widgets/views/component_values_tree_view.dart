import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/mobile_org_units_tree_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/org_units_tree_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentValuesTreeView extends ConsumerWidget {
  const ComponentValuesTreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isMobileLayout) {
      return const MobileOrgUnitsTreeWidget();
    }

    return const SizedBox(width: double.infinity, child: OrgUnitsTreeWidget());
  }
}

import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/domain/models/security_module.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_modules/security_modules_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FunctionRolesSearchCard extends ConsumerStatefulWidget {
  const FunctionRolesSearchCard({super.key});

  @override
  ConsumerState<FunctionRolesSearchCard> createState() => _FunctionRolesSearchCardState();
}

class _FunctionRolesSearchCardState extends ConsumerState<FunctionRolesSearchCard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(functionRolesProvider).searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(functionRolesProvider);
    final notifier = ref.read(functionRolesProvider.notifier);
    final modules = ref.watch(securityModulesProvider).modules;
    final moduleItems = [null, ...modules.map((m) => m.moduleId)];

    String moduleLabel(int? id) {
      if (id == null) return 'All Modules';
      final module = modules.cast<SecurityModule?>().firstWhere((m) => m?.moduleId == id, orElse: () => null);
      return module?.moduleName ?? 'Unknown Module';
    }

    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.primaryShadow),
      child: RolesManagementSurfaceCard(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Expanded(
              child: DigifyTextField.search(
                labelText: 'Search',
                controller: _searchController,
                hintText: 'Search by role name, code, or description...',
                filled: true,
                fillColor: Colors.transparent,
                onChanged: notifier.updateSearch,
              ),
            ),
            Gap(14.w),
            Expanded(
              child: DigifySelectFieldWithLabel<int?>(
                label: 'Filter by Module',
                value: state.selectedModuleId,
                items: moduleItems,
                itemLabelBuilder: moduleLabel,
                onChanged: notifier.updateModule,
                fillColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

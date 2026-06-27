import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DutyRolesSearchCard extends ConsumerStatefulWidget {
  const DutyRolesSearchCard({super.key});

  @override
  ConsumerState<DutyRolesSearchCard> createState() => _DutyRolesSearchCardState();
}

class _DutyRolesSearchCardState extends ConsumerState<DutyRolesSearchCard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(dutyRolesProvider).searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dutyRolesProvider);
    final notifier = ref.read(dutyRolesProvider.notifier);
    final hint = state.categoriesLoading ? 'Loading categories…' : 'All Categories';

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
              child: DigifySelectFieldWithLabel<SecurityLookupValue?>(
                label: 'Category',
                value: state.selectedCategoryLookup,
                items: [null, ...state.categoryLookups],
                itemLabelBuilder: (item) => item?.valueName ?? 'All Categories',
                hint: hint,
                onChanged: state.categoriesLoading ? null : (v) => notifier.updateCategory(v?.valueCode),
                fillColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

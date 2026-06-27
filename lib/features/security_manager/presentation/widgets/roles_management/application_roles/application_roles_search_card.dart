import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationRolesSearchCard extends ConsumerStatefulWidget {
  const ApplicationRolesSearchCard({super.key});

  @override
  ConsumerState<ApplicationRolesSearchCard> createState() => _ApplicationRolesSearchCardState();
}

class _ApplicationRolesSearchCardState extends ConsumerState<ApplicationRolesSearchCard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(applicationRolesProvider).searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applicationRolesProvider);
    final notifier = ref.read(applicationRolesProvider.notifier);

    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.primaryShadow),
      child: RolesManagementSurfaceCard(
        padding: EdgeInsets.all(18.w),
        child: Column(
          spacing: 14.h,
          children: [
            DigifyTextField.search(
              controller: _searchController,
              hintText: 'Search by role name or description...',
              filled: true,
              fillColor: Colors.transparent,
              onChanged: (value) => notifier.setSearchQuery(value),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: DigifySelectFieldWithLabel<String>(
                    label: 'Type',
                    value: state.selectedTypeFilter,
                    items: ApplicationRolesNotifier.typeFilterOptions,
                    itemLabelBuilder: (item) => item,
                    onChanged: (value) =>
                        notifier.selectTypeFilter(value ?? ApplicationRolesNotifier.typeFilterOptions.first),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifySelectFieldWithLabel<String>(
                    label: 'Status',
                    value: state.selectedStatusFilter,
                    items: ApplicationRolesNotifier.statusFilterOptions,
                    itemLabelBuilder: (item) => item,
                    onChanged: (value) =>
                        notifier.selectStatusFilter(value ?? ApplicationRolesNotifier.statusFilterOptions.first),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifySelectFieldWithLabel<String>(
                    label: 'Category',
                    value: state.selectedCategoryFilter,
                    items: ApplicationRolesNotifier.categoryFilterOptions,
                    itemLabelBuilder: (item) => item,
                    onChanged: (value) =>
                        notifier.selectCategoryFilter(value ?? ApplicationRolesNotifier.categoryFilterOptions.first),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

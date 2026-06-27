import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'roles_management_surface_card.dart';

class RolesManagementFiltersCard extends StatelessWidget {
  const RolesManagementFiltersCard({
    super.key,
    required this.searchController,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  final TextEditingController searchController;
  final String selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.primaryShadow),
      child: RolesManagementSurfaceCard(
        padding: EdgeInsets.all(18.w),
        child: context.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14.h,
                children: [
                  const RolesManagementFieldLabel(text: 'Search Roles'),
                  DigifyTextField.search(
                    controller: searchController,
                    hintText: 'Search by role name or description...',
                    filled: true,
                    fillColor: Colors.transparent,
                    onChanged: onSearchChanged,
                  ),
                  DigifySelectFieldWithLabel<String>(
                    label: 'Filter by Type',
                    value: selectedFilter,
                    items: RolesManagementNotifier.categoryFilterOptions,
                    itemLabelBuilder: (item) => item,
                    onChanged: (value) => onFilterChanged(value ?? RolesManagementNotifier.categoryFilterOptions.first),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.h,
                      children: [
                        const RolesManagementFieldLabel(text: 'Search Roles'),
                        DigifyTextField.search(
                          controller: searchController,
                          hintText: 'Search by role name or description...',
                          filled: true,
                          fillColor: Colors.transparent,
                          onChanged: onSearchChanged,
                        ),
                      ],
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifySelectFieldWithLabel<String>(
                      label: 'Filter by Type',
                      value: selectedFilter,
                      items: RolesManagementNotifier.categoryFilterOptions,
                      itemLabelBuilder: (item) => item,
                      onChanged: (value) =>
                          onFilterChanged(value ?? RolesManagementNotifier.categoryFilterOptions.first),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

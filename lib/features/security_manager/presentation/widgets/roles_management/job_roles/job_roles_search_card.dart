import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobRolesSearchCard extends StatelessWidget {
  const JobRolesSearchCard({super.key, required this.searchController, required this.onSearchChanged});

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return RolesManagementSurfaceCard(
      padding: EdgeInsets.all(20.w),
      child: DigifyTextField.search(
        labelText: 'Search',
        controller: searchController,
        hintText: 'Search by role name, job title, code, or description...',
        filled: true,
        fillColor: Colors.transparent,
        onChanged: onSearchChanged,
      ),
    );
  }
}

import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobRolesSearchCardMobile extends StatelessWidget {
  const JobRolesSearchCardMobile({super.key, required this.searchController, required this.onSearchChanged});

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.primaryShadow),
      child: RolesManagementSurfaceCard(
        padding: EdgeInsets.all(12.w),
        child: DigifyTextField.search(
          controller: searchController,
          hintText: 'Search by role name, job title, code, or description...',
          filled: true,
          fillColor: Colors.transparent,
          onChanged: onSearchChanged,
        ),
      ),
    );
  }
}

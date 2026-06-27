import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/application_roles_directory_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/application_roles_search_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/application_roles_stats_row.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/mobile/application_roles_directory_section_mobile.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/mobile/application_roles_search_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplicationRolesTabContent extends StatelessWidget {
  const ApplicationRolesTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.h,
      children: [
        const ApplicationRolesStatsRow(),
        if (isMobile) const ApplicationRolesSearchCardMobile() else const ApplicationRolesSearchCard(),
        if (isMobile) const ApplicationRolesDirectorySectionMobile() else const ApplicationRolesDirectorySection(),
      ],
    );
  }
}

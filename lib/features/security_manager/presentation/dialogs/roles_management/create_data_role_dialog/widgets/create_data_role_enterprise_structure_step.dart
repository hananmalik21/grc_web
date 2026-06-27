import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_shared_widgets.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/data_role_enterprise_structure_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDataRoleEnterpriseStructureStep extends StatelessWidget {
  const CreateDataRoleEnterpriseStructureStep({super.key});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateDataRoleSectionTitle(
          iconPath: DataRoleFormConfig.hierarchyIconPath,
          title: DataRoleFormConfig.hierarchySectionTitle,
        ),
        Gap(16.h),
        const DataRoleEnterpriseStructureFields(),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateDataRoleStepHeader(title: DataRoleFormConfig.stepLabels[2]),
        Gap(18.h),
        content,
      ],
    );
  }
}

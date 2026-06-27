import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/data_roles/mobile/data_role_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _mobileSkeletonItem = DataRoleItem(
  id: '0',
  dataRoleGuid: '',
  name: 'Payroll Data Scope Role',
  code: 'PAYROLL_DATA_01',
  description: 'Loading data role details...',
  dataType: 'COMPENSATION',
  iconPath: '',
  orgUnits: const ['Logistics Department'],
  positions: const ['Financial Reporting Manager'],
  grades: const ['SM2'],
  jobFamilies: const ['Supply Chain & Procurement'],
  jobLevels: const ['Associate Professional'],
);

class DataRolesListSkeletonMobile extends StatelessWidget {
  const DataRolesListSkeletonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[
            DataRoleCardMobile(
              role: _mobileSkeletonItem,
              deleteIsLoading: false,
              onView: () {},
              onEdit: () {},
              onDelete: () {},
            ),
            if (i != 2) Gap(12.h),
          ],
        ],
      ),
    );
  }
}

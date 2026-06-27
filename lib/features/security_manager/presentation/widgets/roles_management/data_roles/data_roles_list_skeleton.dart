import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/data_roles/data_roles_role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _skeletonItem = DataRoleItem(
  id: '0',
  dataRoleGuid: '',
  name: 'Payroll Data Scope Role',
  code: 'PAYROLL_DATA_01',
  description: 'Limits payroll data by org and grade.',
  dataType: 'COMPENSATION',
  iconPath: '',
  orgUnits: const ['Logistics Department'],
  positions: const ['Financial Reporting Manager', 'Finance Manager'],
  grades: const ['SM2'],
  jobFamilies: const ['Supply Chain & Procurement'],
  jobLevels: const ['Associate Professional'],
);

/// Skeleton placeholder shown while data roles are loading.
class DataRolesListSkeleton extends StatelessWidget {
  const DataRolesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[DataRoleCard(role: _skeletonItem), if (i != 2) Gap(14.h)],
        ],
      ),
    );
  }
}

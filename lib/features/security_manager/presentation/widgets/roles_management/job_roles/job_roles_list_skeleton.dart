import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/job_roles/job_roles_role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _skeletonItem = JobRoleItem(
  id: '0',
  jobRoleGuid: '',
  name: 'Human Resources Manager Role',
  code: 'JOB_HR_MANAGER',
  description: 'Standard access for HR management position',
  jobTitle: 'Human Resources Manager',
  department: 'Human Resources',
  usersAssignedLabel: '12 users',
  dutyRoles: const ['HR Approver', 'Payroll Approver'],
  dutyRoleCodes: const ['DUTY_HR_APPROVER', 'DUTY_PAYROLL_APPROVER'],
  functionRoles: const ['HR Manager 2', 'HR Manager22'],
  functionRoleCodes: const ['FUNCTION_HR_MANAGER_2', 'FUNCTION_HR_MANAGER_22'],
  dataRoles: const ['Technology Access Role', 'Payroll data scope'],
  dataRoleCodes: const ['DATA_TECH_ACCESS', 'DATA_PAYROLL_SCOPE'],
);

class JobRolesListSkeleton extends StatelessWidget {
  const JobRolesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[JobRoleCard(role: _skeletonItem), if (i != 2) Gap(14.h)],
        ],
      ),
    );
  }
}

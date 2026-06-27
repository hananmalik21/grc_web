import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/job_roles/mobile/job_role_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _mobileSkeletonJobRole = JobRoleItem(
  id: '0',
  jobRoleGuid: '',
  name: 'Human Resources Specialist Role',
  code: 'JOB_HR_SPECIALIST',
  description: 'Loading job role details...',
  jobTitle: 'Human Resources Specialist',
  dutyRoles: ['Duty Role'],
  dutyRoleCodes: ['DUTY_ROLE'],
  functionRoles: ['Function Role'],
  functionRoleCodes: ['FUNCTION_ROLE'],
  dataRoles: ['Data Role'],
  dataRoleCodes: ['DATA_ROLE'],
  usersAssignedLabel: '0 users',
);

class JobRolesListSkeletonMobile extends StatelessWidget {
  const JobRolesListSkeletonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[
            JobRoleCardMobile(
              role: _mobileSkeletonJobRole,
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

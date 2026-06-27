import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles/mobile/duty_role_card_mobile.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _mobileSkeletonRole = DutyRoleItem(
  id: '0',
  dutyRoleGuid: '',
  name: 'Skeleton Duty Role',
  code: 'DUTY_SKL',
  description: 'Loading duty role details...',
  category: 'Category',
  usersAssignedLabel: '0 users assigned',
  includedFunctionRoles: ['Function Role'],
);

class DutyRolesListSkeletonMobile extends StatelessWidget {
  const DutyRolesListSkeletonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[
            DutyRoleCardMobile(
              role: _mobileSkeletonRole,
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

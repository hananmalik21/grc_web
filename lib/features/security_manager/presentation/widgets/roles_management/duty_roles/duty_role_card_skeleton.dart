import 'package:grc/features/security_manager/domain/models/duty_role.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/duty_roles/duty_roles_role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _skeletonItem = DutyRoleItem.fromDutyRole(skeletonDutyRole);

class DutyRolesListSkeleton extends StatelessWidget {
  const DutyRolesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[DutyRoleCard(role: _skeletonItem), if (i != 2) Gap(14.h)],
        ],
      ),
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/employee_self_service/presentation/providers/employment_info/employment_info_state.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/employment_info/widgets/employment_info_person_card.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReportingStructureCard extends StatelessWidget {
  final ReportingPersonInfo directManager;
  final ReportingPersonInfo myTeam;

  const ReportingStructureCard({super.key, required this.directManager, required this.myTeam});

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      title: 'Reporting Structure',
      titleIconPath: Assets.icons.employeeListIcon.path,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 720;
          final directCard = EmploymentInfoPersonCard(
            person: directManager,
            iconPath: Assets.icons.managementIconDepartment.path,
            iconBackgroundColor: AppColors.infoBorder,
            iconColor: AppColors.primary,
          );
          final teamCard = EmploymentInfoPersonCard(
            person: myTeam,
            iconPath: Assets.icons.compensation.users.path,
            iconBackgroundColor: AppColors.infoBorder,
            iconColor: AppColors.primary,
          );

          if (isStacked) {
            return Column(children: [directCard, Gap(16.h), teamCard]);
          }

          return Row(
            children: [
              Expanded(child: directCard),
              Gap(20.w),
              Expanded(child: teamCard),
            ],
          );
        },
      ),
    );
  }
}

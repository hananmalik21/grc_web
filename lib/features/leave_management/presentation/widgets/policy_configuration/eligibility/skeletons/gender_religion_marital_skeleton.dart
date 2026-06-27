import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility/checkbox_group_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GenderReligionMaritalSkeleton extends StatelessWidget {
  final bool isDark;

  const GenderReligionMaritalSkeleton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          final gender = _buildCard(title: 'Gender', iconPath: Assets.icons.employeesBlueIcon.path, count: 2);
          final religion = _buildCard(title: 'Religion', iconPath: Assets.icons.leaveManagement.globe.path, count: 2);
          final marital = _buildCard(
            title: 'Marital Status',
            iconPath: Assets.icons.leaveManagement.martialStatus.path,
            count: 2,
          );

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [gender, Gap(14.h), religion, Gap(14.h), marital],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: gender),
              Gap(14.w),
              Expanded(child: religion),
              Gap(14.w),
              Expanded(child: marital),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({required String title, required String iconPath, required int count}) {
    return CheckboxGroupCard(
      title: title,
      iconPath: iconPath,
      options: List.generate(count, (i) => 'Skeleton Item $i'),
      selectedValues: const [],
      isDark: isDark,
      onToggle: null,
    );
  }
}

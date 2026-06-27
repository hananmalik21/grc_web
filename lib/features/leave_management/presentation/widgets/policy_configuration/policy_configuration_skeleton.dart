import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/leave_types_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Skeleton layout for policy configuration (list + optional details placeholder).
class PolicyConfigurationSkeleton extends StatelessWidget {
  final bool isDark;
  final bool isMobile;

  const PolicyConfigurationSkeleton({super.key, required this.isDark, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300.h),
            child: LeaveTypesListSkeleton(isDark: isDark, itemCount: 5),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350.w, maxHeight: 800.h),
          child: LeaveTypesListSkeleton(isDark: isDark, itemCount: 6),
        ),
        Gap(21.w),
        const Expanded(child: Center(child: AppLoadingIndicator())),
      ],
    );
  }
}

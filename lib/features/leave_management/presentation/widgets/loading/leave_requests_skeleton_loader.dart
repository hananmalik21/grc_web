import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_requests_mobile_list.dart';
import 'package:grc/features/leave_management/presentation/widgets/mock/mock_leave_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveRequestsSkeletonLoader extends StatelessWidget {
  const LeaveRequestsSkeletonLoader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: LeaveRequestCard(
              request: MockLeaveRequest.create(),
              localizations: AppLocalizations.of(context)!,
              isDark: isDark,
              isApproveLoading: false,
              isRejectLoading: false,
              isDeleteLoading: false,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_hint_banner.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_library_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_surface_card.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_list_with_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyListContent extends StatelessWidget {
  const PolicyListContent({
    required this.isDark,
    required this.policies,
    required this.onPolicySelected,
    required this.paginationInfo,
    required this.currentPage,
    required this.pageSize,
    required this.onPrevious,
    required this.onNext,
    required this.isLoading,
    super.key,
  });

  final bool isDark;
  final List<PolicyListItem> policies;
  final void Function(PolicyListItem policy) onPolicySelected;
  final dynamic paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final listHeight = MediaQuery.sizeOf(context).height * 0.68;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14.h,
      children: [
        PolicySurfaceCard(
          isDark: isDark,
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PolicyLibraryHeader(isDark: isDark, count: policies.length),
              Gap(10.h),
              PolicyHintBanner(isDark: isDark),
            ],
          ),
        ),
        PolicyListWithPagination(
          policies: policies,
          selectedPolicy: null,
          onPolicySelected: onPolicySelected,
          isDark: isDark,
          listConstraints: BoxConstraints(maxHeight: listHeight),
          paginationInfo: paginationInfo,
          currentPage: currentPage,
          pageSize: pageSize,
          onPrevious: onPrevious,
          onNext: onNext,
          isLoading: isLoading,
        ),
      ],
    );
  }
}

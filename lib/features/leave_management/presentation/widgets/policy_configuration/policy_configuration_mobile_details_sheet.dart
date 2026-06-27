import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/policy_details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PolicyConfigurationMobileDetailsSheet {
  PolicyConfigurationMobileDetailsSheet._();

  static Future<void> show(BuildContext context, {required PolicyListItem policy}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: policy.policyName?.trim().isNotEmpty == true ? policy.policyName! : policy.name,
      child: _PolicyConfigurationMobileDetailsSheetContent(policy: policy),
    );
  }
}

class _PolicyConfigurationMobileDetailsSheetContent extends StatelessWidget {
  const _PolicyConfigurationMobileDetailsSheetContent({required this.policy});

  final PolicyListItem policy;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [PolicyDetailsContent(selectedPolicy: policy, isDark: isDark)],
            ),
          ),
        ),
      ],
    );
  }
}

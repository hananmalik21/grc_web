import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/leave_management/presentation/providers/forfeit_reports_tab_enterprise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitReportsTab extends ConsumerWidget {
  const ForfeitReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final effectiveEnterpriseId = ref.watch(forfeitReportsTabEnterpriseIdProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(forfeitReportsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
          ),
          Gap(24.h),
          Center(
            child: Text(
              'Forfeit Reports',
              style: TextStyle(fontSize: 18.sp, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/compensation/presentation/models/compensation_plan_table_row_data.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_overview_section.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tab_switcher_section.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs_view.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plan_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompensationPlanDetailScreen extends StatelessWidget {
  static const String routeName = 'compensation-plans-detail';

  final CompensationPlanTableRowData row;

  const CompensationPlanDetailScreen({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Consumer(
      builder: (context, ref, child) {
        final planAsync = ref.watch(compensationPlanDetailProvider(row.planGuid));
        return planAsync.when(
          loading: () => Scaffold(
            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppLoadingIndicator(size: 48.r),
                  Gap(16.h),
                  Text(
                    'Loading plan details...',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (err, stack) => Scaffold(
            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
            body: Center(child: Text('Error: $err')),
          ),
          data: (plan) => DefaultTabController(
            length: 7,
            child: Container(
              color: isDark ? AppColors.backgroundDark : AppColors.background,
              child: Builder(
                builder: (context) {
                  final isMobile = context.isMobileLayout;
                  final hPad = isMobile ? 16.w : 24.w;
                  final vPad = isMobile ? 16.h : 24.h;
                  final sectionGap = isMobile ? 16.h : 24.h;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CompensationPlanDetailHeader(plan: plan),
                        Gap(sectionGap),
                        CompensationPlanDetailOverviewSection(plan: plan),
                        Gap(sectionGap),
                        const CompensationPlanDetailTabSwitcherSection(),
                        Gap(sectionGap),
                        CompensationPlanDetailTabsView(plan: plan),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CompensationPlanDetailHeader extends StatelessWidget {
  final CompensationPlan plan;

  const _CompensationPlanDetailHeader({required this.plan});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DigifyAssetButton(onTap: context.pop, assetPath: Assets.icons.employeeManagement.backArrow.path),
        Gap(isMobile ? 12.w : 24.w),
        Expanded(
          child: isMobile ? DigifyMobileTabHeader(title: plan.planName) : DigifyTabHeader(title: plan.planName),
        ),
      ],
    );
  }
}

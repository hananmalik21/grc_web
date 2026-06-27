import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation_detail/compensation_calculation_summary.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation_detail/compensation_components_editor.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation_detail/compensation_plan_summary.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation_detail/employee_profile_summary.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation_detail/employee_comp_history_section_for_detail.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_detail_provider.dart';

class EmployeeCompensationDetailPage extends ConsumerStatefulWidget {
  static const String routeName = 'employee-compensation-detail';

  final String employeeId;
  final String planGuid;

  const EmployeeCompensationDetailPage({super.key, required this.employeeId, required this.planGuid});

  @override
  ConsumerState<EmployeeCompensationDetailPage> createState() => _EmployeeCompensationDetailPageState();
}

class _EmployeeCompensationDetailPageState extends ConsumerState<EmployeeCompensationDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(employeeCompensationDetailProvider.notifier)
          .loadDetails(employeeGuid: widget.employeeId, planGuid: widget.planGuid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(employeeCompensationDetailProvider);

    if (state.isLoading) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoadingIndicator(size: 48.r),
            Gap(16.h),
            Text(
              'Loading...',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    final isMobile = context.isMobileLayout;
    final horizontalMargin = isMobile ? 16.w : 24.w;

    return Scaffold(
      body: Container(
        color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 24.h),
                child: isMobile
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DigifyAssetButton(
                            onTap: () => context.pop(),
                            assetPath: Assets.icons.employeeManagement.backArrow.path,
                          ),
                          Gap(12.w),
                          Expanded(child: DigifyMobileTabHeader(title: 'Employee Compensation')),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DigifyAssetButton(
                            onTap: () => context.pop(),
                            assetPath: Assets.icons.employeeManagement.backArrow.path,
                          ),
                          Gap(24.w),
                          Expanded(
                            child: DigifyTabHeader(
                              title: 'Employee Compensation',
                              description: 'View and manage compensation details for ${state.employeeName}.',
                            ),
                          ),
                        ],
                      ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                child: Builder(
                  builder: (context) {
                    final isTwoColumn = context.isDesktopLayout;

                    final leftColumn = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 24.h,
                      children: [
                        const EmployeeProfileSummary(),
                        const CompensationPlanSummary(),
                        const CompensationComponentsEditor(),
                        const EmployeeCompHistorySectionForDetail(),
                      ],
                    );

                    final rightColumn = Column(spacing: 24.h, children: [const CompensationCalculationSummary()]);

                    if (!isTwoColumn) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [leftColumn, Gap(24.h), rightColumn],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: leftColumn),
                        Gap(24.w),
                        Expanded(flex: 1, child: rightColumn),
                      ],
                    );
                  },
                ),
              ),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/employee_details_section.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/add_compensation_plans_section.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_calculator_sidebar.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/employee_comp_history_section.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/add_compensation_plans_provider.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/employee_details_provider.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_tab_enterprise_provider.dart';

class CreateEmployeeCompensationPlanPage extends ConsumerStatefulWidget {
  static const String routeName = 'create-employee-compensation-plan';

  const CreateEmployeeCompensationPlanPage({super.key});

  @override
  ConsumerState<CreateEmployeeCompensationPlanPage> createState() => _CreateEmployeeCompensationPlanPageState();
}

class _CreateEmployeeCompensationPlanPageState extends ConsumerState<CreateEmployeeCompensationPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CreateEmployeeCompensationPlanContent(
        showPageHeader: true,
        showEmployeeDetails: true,
        showHistory: true,
        showCalculatorActions: true,
      ),
    );
  }
}

class CreateEmployeeCompensationPlanContent extends ConsumerStatefulWidget {
  final bool showPageHeader;
  final bool showEmployeeDetails;
  final bool showHistory;
  final bool showCalculatorActions;

  const CreateEmployeeCompensationPlanContent({
    super.key,
    this.showPageHeader = false,
    this.showEmployeeDetails = false,
    this.showHistory = false,
    this.showCalculatorActions = false,
  });

  @override
  ConsumerState<CreateEmployeeCompensationPlanContent> createState() => _CreateEmployeeCompensationPlanContentState();
}

class _CreateEmployeeCompensationPlanContentState extends ConsumerState<CreateEmployeeCompensationPlanContent> {
  final TextEditingController _planSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(employeeCompensationDetailsProvider.notifier).clearSelection();
      ref.read(addCompensationPlansProvider.notifier).reset();
      _planSearchController.clear();
    });
  }

  @override
  void dispose() {
    _planSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;
    final enterpriseId = ref.watch(compensationEmployeeTabEnterpriseIdProvider) ?? 0;
    final horizontalMargin = isMobile ? 16.w : 24.w;

    final usePageBackground = widget.showPageHeader;

    return Container(
      color: usePageBackground
          ? (isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground)
          : Colors.transparent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showPageHeader)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 24.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DigifyAssetButton(
                      onTap: () => context.pop(),
                      assetPath: Assets.icons.employeeManagement.backArrow.path,
                    ),
                    Gap(24.w),
                    const Expanded(
                      child: DigifyTabHeader(
                        title: 'Employee Compensation',
                        description:
                            'Assign multiple compensation plans to the employee. Only one plan per type can be assigned.',
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: widget.showPageHeader ? horizontalMargin : 0),
              child: Builder(
                builder: (context) {
                  final isTwoColumn = context.isDesktopLayout;

                  final leftColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showEmployeeDetails) ...[
                        EmployeeDetailsSection(enterpriseId: enterpriseId),
                        Gap(24.h),
                      ],
                      AddCompensationPlansSection(planSearchController: _planSearchController),
                      if (widget.showHistory) ...[Gap(24.h), const EmployeeCompHistorySection()],
                      Gap(24.h),
                    ],
                  );

                  final rightColumn = CompensationCalculatorSidebar(showActions: widget.showCalculatorActions);

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
    );
  }
}

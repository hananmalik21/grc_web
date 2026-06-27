import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/payroll_process_results_data_table.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/payroll_process_results_list_mobile.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultDetailPage extends StatelessWidget {
  const PersonResultDetailPage({required this.employee, super.key});

  final PersonResultEmployee employee;

  static const String routeName = 'payroll-person-result-detail';
  static const String path = 'person-result-detail';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final padding = ResponsiveHelper.getScreenPadding(context).copyWith(top: 24.h);
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonResultDetailHeader(employee: employee, isDark: isDark),
            Gap(sectionSpacing),
            if (isMobile)
              PayrollProcessResultsListMobile(employee: employee)
            else
              PayrollProcessResultsDataTable(employee: employee),
          ],
        ),
      ),
    );
  }
}

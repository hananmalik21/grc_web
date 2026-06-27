import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/presentation/models/person_result_task_detail_args.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_header.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_tabs_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailPage extends StatelessWidget {
  const PersonResultTaskDetailPage({required this.args, super.key});

  final PersonResultTaskDetailArgs args;

  static const String routeName = 'payroll-person-result-task-detail';
  static const String path = 'task-detail';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
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
            PersonResultTaskDetailHeader(employee: args.employee, task: args.task),
            Gap(sectionSpacing),
            const PersonResultTaskDetailToolbar(),
            Gap(sectionSpacing),
            PersonResultTaskDetailTabsSection(task: args.task),
          ],
        ),
      ),
    );
  }
}

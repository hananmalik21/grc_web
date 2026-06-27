import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_process_overview_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_process_rate_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_process_timeline_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_tab_stat_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailProcessDetailsTab extends StatelessWidget {
  const PersonResultTaskDetailProcessDetailsTab({super.key, required this.task});

  final PayrollProcessResultTask task;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cards = _buildCards(loc);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonResultTaskDetailTabStatCards(cards: cards),
        Gap(24.h),
        PersonResultTaskDetailProcessOverviewSection(task: task),
        Gap(24.h),
        const PersonResultTaskDetailProcessTimelineSection(),
        Gap(24.h),
        const PersonResultTaskDetailProcessRateSection(),
      ],
    );
  }

  List<PersonResultTaskDetailTabStatCardData> _buildCards(AppLocalizations loc) {
    final payrollRunStatus = task.status == PayrollProcessTaskStatus.complete
        ? loc.payrollPersonResultsTaskStatusCompleted
        : loc.payrollPersonResultsTaskStatusInProgress;

    return [
      PersonResultTaskDetailTabStatCardData(
        value: payrollRunStatus,
        label: loc.payrollPersonResultsTaskDetailPayrollRunStatus,
        iconPath: Assets.icons.checkIconGreen.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: task.amount,
        label: loc.payrollPersonResultsTaskDetailNetPay,
        iconPath: Assets.icons.leaveManagement.dollar.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailProcessTypeRegularNormal,
        label: loc.payrollPersonResultsTaskDetailProcessType,
        iconPath: Assets.icons.payroll.process.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: task.payrollPeriod,
        label: loc.payrollPersonResultsPayrollPeriod,
        iconPath: Assets.icons.employeesAssignedIcon.path,
      ),
    ];
  }
}

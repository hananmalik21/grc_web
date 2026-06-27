import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_archive_integrity_timeline_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_archive_elements_table_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_archive_summary_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_tab_stat_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailArchiveResultsTab extends StatelessWidget {
  const PersonResultTaskDetailArchiveResultsTab({super.key, required this.task});

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
        PersonResultTaskDetailArchiveSummarySection(task: task),
        Gap(24.h),
        const PersonResultTaskDetailArchiveElementsTableSection(),
        Gap(24.h),
        const PersonResultTaskDetailArchiveIntegrityTimelineSection(),
      ],
    );
  }

  List<PersonResultTaskDetailTabStatCardData> _buildCards(AppLocalizations loc) {
    return [
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailTotalArchivedElementsValue,
        label: loc.payrollPersonResultsTaskDetailTotalArchivedElements,
        iconPath: Assets.icons.compensation.layers.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailNetPayValue,
        label: loc.payrollPersonResultsTaskDetailTotalNetPay,
        iconPath: Assets.icons.leaveManagement.dollar.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailTotalEarningsValue,
        label: loc.payrollPersonResultsTaskDetailTotalEarnings,
        iconPath: Assets.icons.priceUpItem.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailTotalDeductionsValue,
        label: loc.payrollPersonResultsTaskDetailTotalDeductions,
        iconPath: Assets.icons.leaveManagement.downfall.path,
      ),
    ];
  }
}

import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_messages_filter_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_table_section.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_tab_stat_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailMessagesTab extends ConsumerWidget {
  const PersonResultTaskDetailMessagesTab({super.key, required this.task});

  final PayrollProcessResultTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonResultTaskDetailTabStatCards(cards: _buildCards(loc)),
        Gap(24.h),
        PersonResultTaskDetailMessagesFilterSection(
          errorCount: int.parse(loc.payrollPersonResultsTaskDetailErrorsValue),
          warningCount: int.parse(loc.payrollPersonResultsTaskDetailWarningsValue),
          informationCount: int.parse(loc.payrollPersonResultsTaskDetailInformationalValue),
        ),
        Gap(24.h),
        const PersonResultTaskDetailMessagesTableSection(),
      ],
    );
  }

  List<PersonResultTaskDetailTabStatCardData> _buildCards(AppLocalizations loc) {
    return [
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailTotalMessagesValue,
        label: loc.payrollPersonResultsTaskDetailTotalMessages,
        iconPath: Assets.icons.employeeManagement.document.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailWarningsValue,
        label: loc.payrollPersonResultsTaskDetailWarnings,
        iconPath: Assets.icons.securityManager.warning.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailErrorsValue,
        label: loc.payrollPersonResultsTaskDetailErrors,
        iconPath: Assets.icons.errorCircleRed.path,
      ),
      PersonResultTaskDetailTabStatCardData(
        value: loc.payrollPersonResultsTaskDetailInformationalValue,
        label: loc.payrollPersonResultsTaskDetailInformational,
        iconPath: Assets.icons.infoCircleBlue.path,
      ),
    ];
  }
}

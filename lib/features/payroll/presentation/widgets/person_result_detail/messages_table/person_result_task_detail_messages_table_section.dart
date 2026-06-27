import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_task_detail_messages_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_desktop_table.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_mobile_list.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_table_data.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_table_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonResultTaskDetailMessagesTableSection extends ConsumerWidget {
  const PersonResultTaskDetailMessagesTableSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final messagesState = ref.watch(personResultTaskDetailMessagesProvider);
    final messagesController = ref.read(personResultTaskDetailMessagesProvider.notifier);
    final rows = filterMessageRows(buildMessageRows(loc), messagesState);
    final warningCount = countMessagesBySeverity(rows, PersonResultTaskDetailMessageSeverity.warning);
    final errorCount = countMessagesBySeverity(rows, PersonResultTaskDetailMessageSeverity.error);
    final infoCount = countMessagesBySeverity(rows, PersonResultTaskDetailMessageSeverity.information);
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMobile)
            PersonResultTaskDetailMessagesMobileList(
              rows: rows,
              expandedRowIds: messagesState.expandedRowIds,
              onToggleRow: messagesController.toggleRowExpanded,
            )
          else
            PersonResultTaskDetailMessagesDesktopTable(
              rows: rows,
              expandedRowIds: messagesState.expandedRowIds,
              onToggleRow: messagesController.toggleRowExpanded,
            ),
          PersonResultTaskDetailMessagesTableFooter(
            totalCount: rows.length,
            warningCount: warningCount,
            errorCount: errorCount,
            infoCount: infoCount,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}

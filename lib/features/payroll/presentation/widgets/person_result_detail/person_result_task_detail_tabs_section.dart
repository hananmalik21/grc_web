import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_archive_results_tab.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_messages_tab.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_process_details_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum PersonResultTaskDetailTab { processDetails, archiveResults, messages }

class PersonResultTaskDetailTabsSection extends StatefulWidget {
  const PersonResultTaskDetailTabsSection({super.key, required this.task});

  final PayrollProcessResultTask task;

  @override
  State<PersonResultTaskDetailTabsSection> createState() => _PersonResultTaskDetailTabsSectionState();
}

class _PersonResultTaskDetailTabsSectionState extends State<PersonResultTaskDetailTabsSection> {
  PersonResultTaskDetailTab _selectedTab = PersonResultTaskDetailTab.processDetails;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonResultTaskDetailTabHeader(
          selectedTab: _selectedTab,
          onTabSelected: (tab) => setState(() => _selectedTab = tab),
        ),
        Gap(24.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(key: ValueKey(_selectedTab), child: _buildTabContent(loc)),
        ),
      ],
    );
  }

  Widget _buildTabContent(AppLocalizations loc) {
    return switch (_selectedTab) {
      PersonResultTaskDetailTab.processDetails => PersonResultTaskDetailProcessDetailsTab(task: widget.task),
      PersonResultTaskDetailTab.archiveResults => PersonResultTaskDetailArchiveResultsTab(task: widget.task),
      PersonResultTaskDetailTab.messages => PersonResultTaskDetailMessagesTab(task: widget.task),
    };
  }
}

class PersonResultTaskDetailTabHeader extends StatelessWidget {
  const PersonResultTaskDetailTabHeader({required this.selectedTab, required this.onTabSelected, super.key});

  final PersonResultTaskDetailTab selectedTab;
  final ValueChanged<PersonResultTaskDetailTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 2)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PersonResultTaskDetailTabButton(
              label: loc.payrollPersonResultsTaskDetailProcessDetails,
              isSelected: selectedTab == PersonResultTaskDetailTab.processDetails,
              onTap: () => onTabSelected(PersonResultTaskDetailTab.processDetails),
            ),
            PersonResultTaskDetailTabButton(
              label: loc.payrollPersonResultsTaskDetailArchiveResults,
              isSelected: selectedTab == PersonResultTaskDetailTab.archiveResults,
              onTap: () => onTabSelected(PersonResultTaskDetailTab.archiveResults),
            ),
            PersonResultTaskDetailTabButton(
              label: loc.payrollPersonResultsTaskDetailMessages,
              isSelected: selectedTab == PersonResultTaskDetailTab.messages,
              onTap: () => onTabSelected(PersonResultTaskDetailTab.messages),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonResultTaskDetailTabButton extends StatelessWidget {
  const PersonResultTaskDetailTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 14.h),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 1)),
        ),
        child: Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

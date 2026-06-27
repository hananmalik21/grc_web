import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_requisition_section_card.dart';

class CreateRequisitionHiringTeamStep extends ConsumerWidget {
  const CreateRequisitionHiringTeamStep({super.key});

  Widget _buildResponsiveRow({required List<Widget> children, required BuildContext context}) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          final isLast = index == children.length - 1;

          var effectiveWidget = widget;
          if (widget is Expanded) {
            effectiveWidget = widget.child;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [effectiveWidget, if (!isLast) Gap(16.h)],
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        final isLast = index == children.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: widget is Expanded ? widget.child : widget),
              if (!isLast) Gap(16.w),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _coreEmployeeField({
    required AppLocalizations loc,
    required int enterpriseId,
    required String label,
    required bool isRequired,
    required Employee? selectedEmployee,
    required ValueChanged<Employee> onSelected,
  }) {
    return EmployeeSearchField(
      label: label,
      isRequired: isRequired,
      enterpriseId: enterpriseId,
      selectedEmployee: selectedEmployee,
      hintText: loc.typeToSearchEmployees,
      onEmployeeSelected: onSelected,
      fillColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(createRequisitionProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);
    final enterpriseId = ref.watch(requisitionsTabEnterpriseIdProvider)!;

    final hiringTeamCard = CreateRequisitionSectionCard(
      title: loc.hiringRequisitionHiringTeamCardTitle,
      subtitle: loc.hiringCreateRequisitionHiringTeamSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              _coreEmployeeField(
                loc: loc,
                enterpriseId: enterpriseId,
                label: loc.hiringRequisitionDetailHiringManager,
                isRequired: true,
                selectedEmployee: state.hiringManagerEmployee,
                onSelected: notifier.setHiringManagerEmployee,
              ),
              _coreEmployeeField(
                loc: loc,
                enterpriseId: enterpriseId,
                label: loc.hiringRequisitionDetailRecruiter,
                isRequired: true,
                selectedEmployee: state.recruiterEmployee,
                onSelected: notifier.setRecruiterEmployee,
              ),
            ],
          ),
          Gap(16.h),
          _coreEmployeeField(
            loc: loc,
            enterpriseId: enterpriseId,
            label: loc.hiringRequisitionDetailHrbp,
            isRequired: false,
            selectedEmployee: state.hrBusinessPartnerEmployee,
            onSelected: notifier.setHrBusinessPartnerEmployee,
          ),
        ],
      ),
    );

    final interviewPanelCard = CreateRequisitionSectionCard(
      title: loc.hiringCreateRequisitionInterviewPanelTitle,
      subtitle: loc.hiringCreateRequisitionInterviewPanelSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...state.interviewPanelMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            final label = state.interviewPanelMembers.length == 1
                ? loc.interviewers
                : '${loc.interviewers} (${index + 1})';

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: EmployeeSearchField(
                      label: label,
                      isRequired: false,
                      enterpriseId: enterpriseId,
                      selectedEmployee: member,
                      hintText: loc.typeToSearchEmployees,
                      onEmployeeSelected: (e) => notifier.setInterviewPanelMember(index, e),
                      fillColor: Colors.transparent,
                    ),
                  ),
                  if (state.interviewPanelMembers.length > 1 || member != null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 28.h),
                      child: IconButton(
                        icon: Icon(Icons.delete_outline, color: AppColors.error, size: 20.w),
                        onPressed: () => notifier.removeInterviewPanelSlot(index),
                      ),
                    ),
                ],
              ),
            );
          }),
          Gap(4.h),
          TextButton.icon(
            onPressed: notifier.addInterviewPanelSlot,
            icon: Icon(Icons.add, size: 18.w, color: AppColors.primary),
            label: Text(
              loc.hiringCreateRequisitionAddInterviewer,
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );

    if (context.isMobile) {
      return Column(children: [hiringTeamCard, Gap(20.h), interviewPanelCard]);
    }

    return Column(children: [hiringTeamCard, Gap(24.h), interviewPanelCard]);
  }
}

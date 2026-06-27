import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/hiring/application/applications/providers/application_detail_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/applications/states/add_application_note_state.dart';
import 'package:grc/features/hiring/application/applications/states/application_detail_state.dart';
import 'package:grc/features/hiring/application/applications/states/move_application_stage_state.dart';
import 'package:grc/features/hiring/application/applications/states/reject_application_state.dart';
import 'package:grc/features/hiring/application/applications/utils/application_actions_utils.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'application_detail_section.dart';
import 'package:grc/features/hiring/presentation/models/schedule_interview_subject.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/schedule_interview_dialog.dart';
import 'move_stage_dialog.dart';
import 'add_notes_dialog.dart';
import 'reject_application_dialog.dart';

class ApplicationActionsCard extends ConsumerWidget {
  const ApplicationActionsCard({required this.detail, super.key});

  final ApplicationDetailData detail;

  MoveApplicationStageParams _moveStageParams(WidgetRef ref) {
    final enterpriseId = ref.read(applicationsTabEnterpriseIdProvider) ?? 1;
    return MoveApplicationStageParams(
      enterpriseId: enterpriseId,
      applicationGuid: detail.applicationGuid,
      currentStageCode: detail.currentStageCode,
    );
  }

  AddApplicationNoteParams _addNoteParams(WidgetRef ref) {
    final enterpriseId = ref.read(applicationsTabEnterpriseIdProvider) ?? 1;
    return AddApplicationNoteParams(enterpriseId: enterpriseId, applicationGuid: detail.applicationGuid);
  }

  RejectApplicationParams _rejectParams(WidgetRef ref) {
    final enterpriseId = ref.read(applicationsTabEnterpriseIdProvider) ?? 1;
    return RejectApplicationParams(enterpriseId: enterpriseId, applicationGuid: detail.applicationGuid);
  }

  Future<void> _refreshApplicationDetail(WidgetRef ref, int enterpriseId) {
    return ref
        .read(
          applicationDetailControllerProvider(
            ApplicationDetailParams(enterpriseId: enterpriseId, applicationGuid: detail.applicationGuid),
          ).notifier,
        )
        .loadDetail();
  }

  List<Widget> _buildActionButtons(BuildContext context, WidgetRef ref, ApplicationActionsVisibility visibility) {
    final enterpriseId = ref.read(applicationsTabEnterpriseIdProvider) ?? 1;
    final moveStageParams = _moveStageParams(ref);
    final addNoteParams = _addNoteParams(ref);
    final rejectParams = _rejectParams(ref);
    final scheduleSubject = ScheduleInterviewSubject.fromApplicationDetail(detail);

    return [
      if (visibility.showMoveStage)
        AppButton.primary(
          label: 'Move to Next Stage',
          onPressed: () => MoveStageDialog.show(context, params: moveStageParams),
          width: double.infinity,
        ),
      if (visibility.showScheduleInterview)
        AppButton.outline(
          label: 'Schedule Interview',
          onPressed: () => ScheduleInterviewDialog.show(
            context,
            scheduleSubject,
            enterpriseId: enterpriseId,
            onSuccess: () => _refreshApplicationDetail(ref, enterpriseId),
          ),
          width: double.infinity,
        ),
      if (visibility.showAddNotes)
        AppButton.outline(
          label: 'Add Notes',
          onPressed: () => AddNotesDialog.show(context, params: addNoteParams),
          width: double.infinity,
        ),
      if (visibility.showReject)
        AppButton(
          label: 'Reject Application',
          onPressed: () => RejectApplicationDialog.show(context, params: rejectParams),
          width: double.infinity,
          type: AppButtonType.outline,
          foregroundColor: AppColors.brandRed,
          borderColor: AppColors.brandRed,
        ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = resolveApplicationActionsVisibility(
      currentStageCode: detail.currentStageCode,
      isRejected: detail.isRejected,
    );
    final actionButtons = _buildActionButtons(context, ref, visibility);

    return ApplicationDetailSection(
      title: 'Actions',
      child: Column(
        children: [
          for (var i = 0; i < actionButtons.length; i++) ...[if (i > 0) Gap(8.h), actionButtons[i]],
        ],
      ),
    );
  }
}

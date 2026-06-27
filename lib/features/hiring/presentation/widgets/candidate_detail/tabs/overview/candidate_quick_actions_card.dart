import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'candidate_section_card.dart';
import 'package:grc/features/hiring/presentation/models/schedule_interview_subject.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/schedule_interview_dialog.dart';
import 'send_message_dialog.dart';
import 'add_talent_pool_dialog.dart';
import 'request_assessment_dialog.dart';

class CandidateQuickActionsCard extends StatelessWidget {
  const CandidateQuickActionsCard({super.key, required this.isDark, required this.candidate});

  final bool isDark;
  final CandidateData candidate;

  @override
  Widget build(BuildContext context) {
    return CandidateSectionCard(
      title: 'Quick Actions',
      isDark: isDark,
      child: Column(
        children: [
          AppButton.primary(
            label: 'Schedule Interview',
            onPressed: () => ScheduleInterviewDialog.show(context, ScheduleInterviewSubject.fromCandidate(candidate)),
            width: double.infinity,
          ),
          Gap(8.h),
          AppButton.outline(
            label: 'Send Email',
            onPressed: () => SendMessageDialog.show(context, candidate),
            width: double.infinity,
          ),
          Gap(8.h),
          AppButton.outline(
            label: 'Add to Pool',
            onPressed: () => AddTalentPoolDialog.show(context, candidate),
            width: double.infinity,
          ),
          Gap(8.h),
          AppButton.outline(
            label: 'Request Assessment',
            onPressed: () => RequestAssessmentDialog.show(context, candidate),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/url_launch_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interview_card.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mobile/interview_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class QuickInfoDialog extends StatelessWidget {
  const QuickInfoDialog({required this.date, required this.dayInterviews, super.key});

  final DateTime date;
  final List<Interview> dayInterviews;

  static void show(BuildContext context, {required DateTime date, required List<Interview> dayInterviews}) {
    showDialog(
      context: context,
      builder: (context) => QuickInfoDialog(date: date, dayInterviews: dayInterviews),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;
    final formattedDate = DateFormat('MMMM d, yyyy').format(date);

    return AppDialog(
      title: formattedDate,
      subtitle: dayInterviews.isNotEmpty ? '(${dayInterviews.length})' : null,
      width: 600.w,
      content: dayInterviews.isEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(20.h),
                Icon(Icons.calendar_today_outlined, size: 48.w, color: context.themeTextMuted),
                Gap(16.h),
                Text(
                  'No interviews scheduled',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.themeTextPrimary,
                  ),
                ),
                Gap(20.h),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: dayInterviews.map((interview) {
                final onJoinMeeting = interview.meetingLink != null && interview.meetingLink!.isNotEmpty
                    ? () => UrlLaunchService.launchExternal(interview.meetingLink!)
                    : null;

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: isMobile
                      ? InterviewCardMobile(interview: interview, onJoinMeeting: onJoinMeeting)
                      : InterviewCard(interview: interview, onJoinMeeting: onJoinMeeting),
                );
              }).toList(),
            ),
    );
  }
}

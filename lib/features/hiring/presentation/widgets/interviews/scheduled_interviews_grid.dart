import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interview_card.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mobile/interview_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduledInterviewsGrid extends StatelessWidget {
  const ScheduledInterviewsGrid({required this.interviews, super.key});

  final List<Interview> interviews;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final layout = context.screenLayout;

    if (interviews.isEmpty) return const SizedBox.shrink();

    final crossAxisCount = layout.index >= ScreenLayout.tabletMedium.index ? 2 : 1;
    final mainAxisExtent = layout.index < ScreenLayout.tabletSmall.index ? 320.h : 300.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${loc.hiringInterviews} (${interviews.length})',
          style: context.textTheme.titleLarge?.copyWith(color: context.themeTextPrimary),
        ),
        Gap(16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24.w,
            mainAxisSpacing: 24.h,
            mainAxisExtent: mainAxisExtent,
          ),
          itemCount: interviews.length,
          itemBuilder: (context, index) {
            final interview = interviews[index];
            final onJoinMeeting = interview.meetingLink != null && interview.meetingLink!.isNotEmpty
                ? () => _openMeetingLink(interview.meetingLink!)
                : null;

            if (layout.index < ScreenLayout.tabletSmall.index) {
              return InterviewCardMobile(interview: interview, onJoinMeeting: onJoinMeeting);
            }
            return InterviewCard(interview: interview, onJoinMeeting: onJoinMeeting);
          },
        ),
      ],
    );
  }

  Future<void> _openMeetingLink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

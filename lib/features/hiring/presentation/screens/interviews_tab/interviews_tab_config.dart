import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/gen/assets.gen.dart';

class InterviewStatCardData {
  final String title;
  final String value;
  final String subtitle;
  final String iconPath;

  const InterviewStatCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconPath,
  });
}

class InterviewsTabConfig {
  InterviewsTabConfig._();

  static const int pageSize = 10;

  static List<InterviewStatCardData> buildStatCards(
    AppLocalizations loc, {
    required int total,
    required int scheduled,
    required int completed,
    required int rescheduled,
  }) {
    return [
      InterviewStatCardData(
        title: loc.totalInterviews,
        value: '$total',
        subtitle: loc.allTime,
        iconPath: Assets.icons.employeesAssignedIcon.path,
      ),
      InterviewStatCardData(
        title: loc.scheduled,
        value: '$scheduled',
        subtitle: loc.upcomingInterviews,
        iconPath: Assets.icons.hiring.videoMeet.path,
      ),
      InterviewStatCardData(
        title: loc.completed,
        value: '$completed',
        subtitle: loc.thisMonth,
        iconPath: Assets.icons.checkIconGreen.path,
      ),
      InterviewStatCardData(
        title: loc.rescheduled,
        value: '$rescheduled',
        subtitle: loc.upcomingInterviews,
        iconPath: Assets.icons.clockIcon.path,
      ),
    ];
  }
}
